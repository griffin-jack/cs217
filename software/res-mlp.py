"""
ResMLP SystemC Stimulus (Full 208-Token Layer)
"""
import os
import torch
import torch.nn.functional as F
import numpy as np
import timm
from urllib.request import urlopen
from PIL import Image

ACT = 16
FRC = 12

def float_to_fixed_int16(tensor, frac_bits=12):
    scale = 2 ** frac_bits
    return torch.round(tensor * scale).clamp(-32768, 32767).to(torch.int32)

def float_to_fixed_int8(tensor, frac_bits=4):
    scale = 2 ** frac_bits
    return torch.round(tensor * scale).clamp(-128, 127).to(torch.int32)

def float_to_fixed_bin(tensor, filename, total_bits, frac_bits):
    scale = 2 ** frac_bits
    qmin, qmax = -(2 ** (total_bits - 1)), (2 ** (total_bits - 1)) - 1
    q_tensor_int = torch.round(tensor * scale).clamp(qmin, qmax)
    np_type = np.int8 if total_bits == 8 else np.int16
    q_tensor_int.to(torch.int32).detach().numpy().astype(np_type).tofile(filename)
    return q_tensor_int / scale

def hw_emul(a, b): return ((torch.bitwise_right_shift(a * b, 12) + 32768) % 65536 - 32768)
def hw_eadd(a, b): return ((a + b + 32768) % 65536 - 32768)
def hw_outgb(a):   return torch.clamp(torch.bitwise_right_shift(a + 128, 8), -128, 127).to(torch.int8)
def hw_promote(a): return torch.bitwise_left_shift(a.to(torch.int32), 8).to(torch.int32)

def hw_matmul(a_int8, w_int8):
    accum = torch.matmul(a_int8.to(torch.int32), w_int8.T.to(torch.int32))
    return torch.clamp(torch.bitwise_right_shift(accum * 167, 11), -32768, 32767).to(torch.int16)

def hw_gelu(a_int16):
    g_float = F.gelu(a_int16.to(torch.float32) / (2 ** FRC))
    return torch.round(g_float * (2 ** FRC)).clamp(-32768, 32767).to(torch.int32)

def save_bin(tensor, filename, is_int8):
    np_type = np.int8 if is_int8 else np.int16
    tensor.detach().numpy().astype(np_type).tofile(filename)

def main():
    out_dir = "tb_data"
    os.makedirs(out_dir, exist_ok=True)
    
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
        
        x_norm1 = (x_padded * block.norm1.alpha) + (block.norm1.beta if hasattr(block.norm1, 'beta') else 0)
        tok_w, tok_b = F.pad(block.linear_tokens.weight, (0, 12, 0, 12)), F.pad(block.linear_tokens.bias, (0, 12))
        tok_out = torch.matmul(x_norm1.transpose(1, 2), tok_w.T) + tok_b
        tok_out = tok_out.transpose(1, 2)

        # Use ALL 208 Tokens
        x_0 = x_padded[0]       
        tok_out_0 = tok_out[0]  

        print("Quantizing Vectors...")
        hw_x       = float_to_fixed_int16(x_0)
        hw_tok_out = float_to_fixed_int16(tok_out_0)
        hw_ls1     = float_to_fixed_int16(block.ls1)
        hw_n2_a    = float_to_fixed_int16(block.norm2.alpha)
        hw_n2_b    = float_to_fixed_int16(block.norm2.beta if hasattr(block.norm2, 'beta') else torch.zeros_like(block.norm2.alpha))
        hw_fc1_b   = float_to_fixed_int16(block.mlp_channels.fc1.bias)
        hw_fc2_b   = float_to_fixed_int16(block.mlp_channels.fc2.bias)
        hw_ls2     = float_to_fixed_int16(block.ls2)

        hw_fc1_w   = float_to_fixed_int8(block.mlp_channels.fc1.weight)
        hw_fc2_w   = float_to_fixed_int8(block.mlp_channels.fc2.weight)

        save_bin(hw_x, f"{out_dir}/in_x.bin", False); save_bin(hw_tok_out, f"{out_dir}/in_tok_out.bin", False)
        save_bin(hw_ls1, f"{out_dir}/w_ls1.bin", False); save_bin(hw_n2_a, f"{out_dir}/w_n2_a.bin", False)
        save_bin(hw_n2_b, f"{out_dir}/w_n2_b.bin", False); save_bin(hw_fc1_b, f"{out_dir}/w_fc1_b.bin", False)
        save_bin(hw_fc2_b, f"{out_dir}/w_fc2_b.bin", False); save_bin(hw_ls2, f"{out_dir}/w_ls2.bin", False)
        save_bin(hw_fc1_w, f"{out_dir}/w_fc1_w.bin", True); save_bin(hw_fc2_w, f"{out_dir}/w_fc2_w.bin", True)

        print("Executing 6-Phase Pipeline...")
        ph1_emul = hw_emul(hw_tok_out, hw_ls1)
        hw_x_tok = hw_outgb(hw_eadd(ph1_emul, hw_x))

        x_tok_promoted = hw_promote(hw_x_tok)
        ph2_emul = hw_emul(x_tok_promoted, hw_n2_a)
        hw_x_scl = hw_outgb(hw_eadd(ph2_emul, hw_n2_b))

        hw_raw1 = hw_matmul(hw_x_scl, hw_fc1_w)

        ph4_eadd = hw_eadd(hw_raw1, hw_fc1_b)
        hw_ch_hid = hw_outgb(hw_gelu(ph4_eadd))

        hw_raw2 = hw_matmul(hw_ch_hid, hw_fc2_w)

        ph6_eadd1 = hw_eadd(hw_raw2, hw_fc2_b)
        ph6_emul  = hw_emul(ph6_eadd1, hw_ls2)
        hw_final  = hw_outgb(hw_eadd(ph6_emul, x_tok_promoted))

        save_bin(hw_final, f"{out_dir}/g6_final.bin", True)

    print("Success! Full Layer generated.")

if __name__ == "__main__":
    main()