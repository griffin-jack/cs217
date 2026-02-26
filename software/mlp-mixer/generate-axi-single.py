"""
Load the pre-trained MLP-Mixer model and generate AXI hardware stimulus
"""

from urllib.request import urlopen
from PIL import Image
import numpy as np
import timm
import torch
import torch.nn.functional as F

model_name = 'mixer_b16_224.goog_in21k_ft_in1k'

# --- Hardware Translation Helpers ---

def quantize_tensor(tensor, num_bits=8):
    """Quantizes a float32 tensor to an n-bit integer tensor."""
    qmin = -(2 ** (num_bits - 1))
    qmax = (2 ** (num_bits - 1)) - 1
    
    # Simple symmetric quantization
    scale = qmax / torch.max(torch.abs(tensor)).clamp(min=1e-5)
    q_tensor = torch.round(tensor * scale)
    q_tensor = torch.clamp(q_tensor, qmin, qmax)
    
    if num_bits == 8:
        return q_tensor.to(torch.int8), scale
    elif num_bits == 16:
        return q_tensor.to(torch.int16), scale
    else:
        return q_tensor.to(torch.int32), scale

def pack_to_axi_hex(tensor_1d):
    """
    Packs 16 8-bit integers into a single 128-bit hex string.
    The accelerator's AXI bus is 128 bits wide (16 lanes of 8-bit words).
    """
    # Convert to unsigned 8-bit for clean hex representation
    u8_array = tensor_1d.numpy().astype(np.uint8)
    
    # Build hex string (little-endian representation typical for AXI)
    hex_str = "".join([f"{byte:02x}" for byte in reversed(u8_array)])
    return hex_str

def write_axi_writes_csv(filename, memory_map):
    """
    memory_map: list of tuples -> (base_address, data_tensor)
    Writes ONLY AXI Write commands for the testbench stimulus.
    """
    with open(filename, 'w') as f:
        for start_addr, data_tensor in memory_map:
            flat_data = data_tensor.flatten()
            
            # The hardware vector size is 16 elements. 
            # Pad the end with zeros if the total elements aren't a multiple of 16.
            remainder = len(flat_data) % 16
            if remainder != 0:
                pad = torch.zeros(16 - remainder, dtype=flat_data.dtype)
                flat_data = torch.cat([flat_data, pad])
                
            current_addr = start_addr
            
            # Write out chunks of 16 elements (128 bits)
            for i in range(0, len(flat_data), 16):
                vec16 = flat_data[i:i+16]
                hex_val = pack_to_axi_hex(vec16)
                
                # ManagerFromFile CSV format: Mode (1=Write), Address, Data
                f.write(f"1, {hex(current_addr)}, {hex_val}\n")
                
                # Increment AXI address by 16 bytes (128 bits)
                current_addr += 16

# --- Model Definitions ---

def get_model(model_name):
    model = timm.create_model(model_name, pretrained=True)
    model = model.eval()
    return model

def img_to_tokens(url, model):
    image = Image.open(urlopen(url)).convert("RGB")

    data_config = timm.data.resolve_model_data_config(model)
    transforms = timm.data.create_transform(**data_config, is_training=False)

    input_tensor = transforms(image).unsqueeze(0)  # [1, 3, 224, 224]

    stem = model.stem 
    with torch.no_grad():
        x = stem(input_tensor)
    return x

def single_layer(x, block):
    with torch.no_grad():
        # (a) Token-Mixing MLP Block
        normed_tokens = block.norm1(x) 
        normed_tokens_T = normed_tokens.transpose(1, 2) 

        tok_fc1_w = block.mlp_tokens.fc1.weight.detach()
        tok_fc1_b = block.mlp_tokens.fc1.bias.detach()
        tok_fc2_w = block.mlp_tokens.fc2.weight.detach()
        tok_fc2_b = block.mlp_tokens.fc2.bias.detach()

        tok_hidden = F.gelu(torch.matmul(normed_tokens_T, tok_fc1_w.T) + tok_fc1_b)
        tok_out_T  = torch.matmul(tok_hidden, tok_fc2_w.T) + tok_fc2_b

        x = x + tok_out_T.transpose(1, 2) 

        # (b) Channel-Mixing MLP Block
        normed_channels = block.norm2(x) 

        ch_fc1_w = block.mlp_channels.fc1.weight.detach()
        ch_fc1_b = block.mlp_channels.fc1.bias.detach()
        ch_fc2_w = block.mlp_channels.fc2.weight.detach()
        ch_fc2_b = block.mlp_channels.fc2.bias.detach()

        ch_hidden = F.gelu(torch.matmul(normed_channels, ch_fc1_w.T) + ch_fc1_b)
        ch_out    = torch.matmul(ch_hidden, ch_fc2_w.T) + ch_fc2_b

        x = x + ch_out 

    return x

# --- Main Execution ---

def main():
    model = timm.create_model('mixer_s32_224', pretrained=False)
    model = model.eval()
    blocks = model.blocks 
    block = blocks[0]
    
    # 1. Process Input Tokens
    url = 'https://img.freepik.com/free-vector/realistic-blue-umbrella_1284-11412.jpg'
    x = img_to_tokens(url, model) # [1, 196, 768]
    
    # Compute the true FP32 golden output for later python-side validation
    fp32_golden_output = single_layer(x, block)
    
    # 2. Dynamically pad spatial tokens to a multiple of 16
    seq_len = x.shape[1] # For s32_224, this will be 49
    remainder = seq_len % 16
    pad_size = (16 - remainder) if remainder != 0 else 0
    
    # Pad the spatial dimension (dim 1). 
    # F.pad format for 3D tensor is (last_dim_pad_left, last_dim_pad_right, 
    #                                second_last_dim_pad_left, second_last_dim_pad_right)
    # So we pad the sequence length (tokens) by pad_size, and channels by 0
    x_padded = F.pad(x, (0, 0, 0, pad_size)) # Output shape: [1, 64, 512]
    
    # 3. Quantize Inputs and Weights for the Accelerator
    # Inputs (8-bit)
    q_x_padded, scale_x = quantize_tensor(x_padded, num_bits=8)
    
    # Token Mixing Weights (8-bit) and Biases (16-bit)
    q_tok_w1, s_tw1 = quantize_tensor(block.mlp_tokens.fc1.weight.detach(), num_bits=8)
    q_tok_b1, s_tb1 = quantize_tensor(block.mlp_tokens.fc1.bias.detach(), num_bits=16)
    q_tok_w2, s_tw2 = quantize_tensor(block.mlp_tokens.fc2.weight.detach(), num_bits=8)
    q_tok_b2, s_tb2 = quantize_tensor(block.mlp_tokens.fc2.bias.detach(), num_bits=16)
    
    # Channel Mixing Weights (8-bit) and Biases (16-bit)
    q_ch_w1, s_cw1 = quantize_tensor(block.mlp_channels.fc1.weight.detach(), num_bits=8)
    q_ch_b1, s_cb1 = quantize_tensor(block.mlp_channels.fc1.bias.detach(), num_bits=16)
    q_ch_w2, s_cw2 = quantize_tensor(block.mlp_channels.fc2.weight.detach(), num_bits=8)
    q_ch_b2, s_cb2 = quantize_tensor(block.mlp_channels.fc2.bias.detach(), num_bits=16)
    
    # 4. Define Memory Map Addresses
    # Choose arbitrary non-overlapping base addresses depending on the size of the tensors.
    ADDR_INPUT      = 0x10000000 
    
    ADDR_TOK_W1     = 0x20000000
    ADDR_TOK_B1     = 0x21000000
    ADDR_TOK_W2     = 0x22000000
    ADDR_TOK_B2     = 0x23000000
    
    ADDR_CH_W1      = 0x30000000
    ADDR_CH_B1      = 0x31000000
    ADDR_CH_W2      = 0x32000000
    ADDR_CH_B2      = 0x33000000
    
    memory_map = [
        (ADDR_INPUT, q_x_padded),
        (ADDR_TOK_W1, q_tok_w1),
        (ADDR_TOK_B1, q_tok_b1),
        (ADDR_TOK_W2, q_tok_w2),
        (ADDR_TOK_B2, q_tok_b2),
        (ADDR_CH_W1, q_ch_w1),
        (ADDR_CH_B1, q_ch_b1),
        (ADDR_CH_W2, q_ch_w2),
        (ADDR_CH_B2, q_ch_b2),
    ]
    
    # 5. Write the AXI commands CSV for the C++ Testbench
    # Only AXI Writes are written here to allow python-side validation of the hardware dump later
    csv_filename = "axi_commands_test.csv"
    write_axi_writes_csv(csv_filename, memory_map)
    print(f"Successfully generated {csv_filename} with stimulus data.")
    
    # (Optional) Save fp32_golden_output to disk using torch.save to compare against hw_out.csv later
    torch.save(fp32_golden_output, "fp32_golden_output.pt")

if __name__ == "__main__":
    main()