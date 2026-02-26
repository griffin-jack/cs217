"""
Generate Raw Binary Hardware Stimulus and Golden Output for a ResMLP-12 layer
"""
import os
from urllib.request import urlopen
from PIL import Image
import numpy as np
import timm
import torch
import torch.nn.functional as F

# --- Helpers ---

def quantize_and_save(tensor, filename, num_bits=8):
    """
    Quantizes a float32 tensor and saves it as a raw binary file (.bin).
    Returns the quantized tensor for further mathematical modeling.
    """
    qmin, qmax = -(2 ** (num_bits - 1)), (2 ** (num_bits - 1)) - 1
    
    # Avoid division by zero
    scale = qmax / torch.max(torch.abs(tensor)).clamp(min=1e-5)
    
    # Quantize and clamp
    q_tensor = torch.round(tensor * scale).clamp(qmin, qmax)
    
    # Cast to appropriate dtype
    if num_bits == 8:
        q_tensor = q_tensor.to(torch.int8)
        np_type = np.int8
    else:
        q_tensor = q_tensor.to(torch.int16)
        np_type = np.int16
        
    # Flatten and dump to raw binary file
    q_tensor.detach().numpy().astype(np_type).tofile(filename)
    
    return q_tensor, scale


# --- Main Execution ---

def main():
    # 0. Setup Output Directory
    out_dir = "test_data"
    os.makedirs(out_dir, exist_ok=True)

    # 1. Load Model
    model_name = 'resmlp_12_224.fb_in1k'
    model = timm.create_model(model_name, pretrained=True).eval()
    block = model.blocks[0]

    # 2. Process Input Tokens (196 tokens, 384 channels)
    url = 'https://hips.hearstapps.com/hmg-prod/images/schnauzer-carrying-lead-6643258113665.jpeg'
    image = Image.open(urlopen(url)).convert("RGB")
    data_config = timm.data.resolve_model_data_config(model)
    transforms = timm.data.create_transform(**data_config, is_training=False)
    
    with torch.no_grad():
        x = model.stem(transforms(image).unsqueeze(0)) # [1, 196, 384]

    # 3. Extract and Pad Tensors for Hardware (16-element multiple constraints)
    # The spatial dimension (tokens) is 196. We pad it to 208.
    # The channel dimension is 384/1536, which are already multiples of 16.
    
    x_padded = F.pad(x, (0, 0, 0, 12)) # Pad 196 -> 208 tokens [1, 208, 384]
    
    # Token Mixing Sublayer (Requires padding spatial weights to 208x208)
    norm1_a = block.norm1.alpha.detach()
    norm1_b = block.norm1.beta.detach() if hasattr(block.norm1, 'beta') else torch.zeros_like(norm1_a)
    ls1     = block.ls1.detach()
    tok_w   = F.pad(block.linear_tokens.weight.detach(), (0, 12, 0, 12)) # [208, 208]
    tok_b   = F.pad(block.linear_tokens.bias.detach(), (0, 12))          # [208]
    
    # Channel Mixing Sublayer (No padding needed)
    norm2_a  = block.norm2.alpha.detach()
    norm2_b  = block.norm2.beta.detach() if hasattr(block.norm2, 'beta') else torch.zeros_like(norm2_a)
    ls2      = block.ls2.detach()
    ch_fc1_w = block.mlp_channels.fc1.weight.detach() # [1536, 384]
    ch_fc1_b = block.mlp_channels.fc1.bias.detach()   # [1536]
    ch_fc2_w = block.mlp_channels.fc2.weight.detach() # [384, 1536]
    ch_fc2_b = block.mlp_channels.fc2.bias.detach()   # [384]

    # 4. Calculate Padded Golden Output
    # We calculate the golden output USING the padded tensors to ensure 
    # the hardware's 0-padded math exactly matches the software reference.
    with torch.no_grad():
        # Token Mixing Phase
        x_norm1 = (x_padded * norm1_a) + norm1_b
        x_tok = x_padded + ls1 * (torch.matmul(x_norm1.transpose(1, 2), tok_w.T) + tok_b).transpose(1, 2)
        
        # Channel Mixing Phase
        x_norm2 = (x_tok * norm2_a) + norm2_b
        h = F.gelu(torch.matmul(x_norm2, ch_fc1_w.T) + ch_fc1_b)
        y = torch.matmul(h, ch_fc2_w.T) + ch_fc2_b
        golden_output = x_tok + ls2 * y

    # 5. Quantize and Dump all Tensors to .bin files
    print(f"Quantizing and saving to ./{out_dir}/...")
    
    # Input & Golden Output
    quantize_and_save(x_padded,      f"{out_dir}/input_tokens.bin", num_bits=8)
    quantize_and_save(golden_output, f"{out_dir}/golden_output.bin", num_bits=8)

    # Token Mixing
    quantize_and_save(norm1_a, f"{out_dir}/norm1_alpha.bin", num_bits=8)
    quantize_and_save(norm1_b, f"{out_dir}/norm1_beta.bin",  num_bits=16)
    quantize_and_save(tok_w,   f"{out_dir}/tok_weight.bin",  num_bits=8)
    quantize_and_save(tok_b,   f"{out_dir}/tok_bias.bin",    num_bits=16)
    quantize_and_save(ls1,     f"{out_dir}/ls1.bin",         num_bits=8)

    # Channel Mixing
    quantize_and_save(norm2_a,  f"{out_dir}/norm2_alpha.bin", num_bits=8)
    quantize_and_save(norm2_b,  f"{out_dir}/norm2_beta.bin",  num_bits=16)
    quantize_and_save(ch_fc1_w, f"{out_dir}/ch_fc1_weight.bin", num_bits=8)
    quantize_and_save(ch_fc1_b, f"{out_dir}/ch_fc1_bias.bin",   num_bits=16)
    quantize_and_save(ch_fc2_w, f"{out_dir}/ch_fc2_weight.bin", num_bits=8)
    quantize_and_save(ch_fc2_b, f"{out_dir}/ch_fc2_bias.bin",   num_bits=16)
    quantize_and_save(ls2,      f"{out_dir}/ls2.bin",         num_bits=8)

    print("Successfully generated all hardware input files.")

if __name__ == "__main__":
    main()