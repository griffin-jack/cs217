"""
ResMLP SystemC Stimulus (Full Tensor Bit-Accurate)
"""
import os
import numpy as np
import timm
import torch
import torch.nn.functional as F
from urllib.request import urlopen
from PIL import Image

def float_to_fixed_int16(tensor, frac_bits=12):
    scale = 2 ** frac_bits
    return torch.round(tensor * scale).clamp(-32768, 32767).to(torch.int32)

def float_to_fixed_int8(tensor, frac_bits=4):
    scale = 2 ** frac_bits
    return torch.round(tensor * scale).clamp(-128, 127).to(torch.int32)

def hw_emul(a, b):
    c = torch.bitwise_right_shift(a * b, 12)
    return ((c + 32768) % 65536 - 32768)

def hw_eadd(a, b):
    c = a + b
    return ((c + 32768) % 65536 - 32768)

def hw_outgb(a):
    c = torch.bitwise_right_shift(a + 128, 8)
    return torch.clamp(c, -128, 127).to(torch.int8)

def hw_matmul(a_int8, w_int8):
    """Exactly replicates the PECore integer MAC and truncation drift"""
    accum = torch.matmul(a_int8.to(torch.int32), w_int8.T.to(torch.int32))
    scaled = torch.bitwise_right_shift(accum * 167, 11)
    return torch.clamp(scaled, -32768, 32767).to(torch.int16)

def save_bin(tensor, filename, is_int8):
    np_type = np.int8 if is_int8 else np.int16
    tensor.detach().numpy().astype(np_type).tofile(filename)

def main():
    out_dir = "tb_data"
    os.makedirs(out_dir, exist_ok=True)
    print(f"Generating FULL TENSOR SystemC Stimulus in ./{out_dir}/")
    
    model = timm.create_model('resmlp_12_224.fb_in1k', pretrained=True).eval()
    block = model.blocks[0]
    
    url = 'https://hips.hearstapps.com/hmg-prod/images/schnauzer-carrying-lead-6643258113665.jpeg'
    image = Image.open(urlopen(url)).convert("RGB")
    data_config = timm.data.resolve_model_data_config(model)
    transforms = timm.data.create_transform(**data_config, is_training=False)
    input_img = transforms(image).unsqueeze(0)

    with torch.no_grad():
        x = model.stem(input_img) 
        x_padded = F.pad(x, (0, 0, 0, 12)) 
        norm1_a = block.norm1.alpha
        norm1_b = block.norm1.beta if hasattr(block.norm1, 'beta') else torch.zeros_like(norm1_a)
        tok_w   = F.pad(block.linear_tokens.weight, (0, 12, 0, 12)) 
        tok_b   = F.pad(block.linear_tokens.bias, (0, 12))          
        
        x_norm1 = (x_padded * norm1_a) + norm1_b
        tok_out = torch.matmul(x_norm1.transpose(1, 2), tok_w.T) + tok_b
        x_tok = x_padded + block.ls1 * tok_out.transpose(1, 2) # Full Shape: [1, 208, 384]

        print("Quantizing Vectors...")
        x_tok_int   = float_to_fixed_int16(x_tok[0]) 
        norm2_a_int = float_to_fixed_int16(block.norm2.alpha) 
        norm2_b_int = float_to_fixed_int16(block.norm2.beta if hasattr(block.norm2, 'beta') else torch.zeros_like(block.norm2.alpha)) 
        fc1_w_int   = float_to_fixed_int8(block.mlp_channels.fc1.weight) # Full Shape: [1536, 384]

        save_bin(x_tok_int,   f"{out_dir}/hw_in_x_tok.bin", False)
        save_bin(norm2_a_int, f"{out_dir}/hw_w_norm2_alpha.bin", False)
        save_bin(norm2_b_int, f"{out_dir}/hw_w_norm2_beta.bin", False)
        save_bin(fc1_w_int,   f"{out_dir}/hw_w_fc1_weight.bin", True)

        print("Simulating Phase 1: Affine Norm...")
        hw_norm2_out = hw_outgb(hw_eadd(hw_emul(x_tok_int, norm2_a_int), norm2_b_int)) 

        print("Simulating Phase 2: PECore Matrix Multiplication...")
        hw_fc1_mm_out = hw_matmul(hw_norm2_out, fc1_w_int) 
        save_bin(hw_fc1_mm_out, f"{out_dir}/golden_2_fc1_matmul.bin", False)

    print("Success! Bit-Accurate Full Tensor SystemC stimulus generated.")

if __name__ == "__main__":
    main()