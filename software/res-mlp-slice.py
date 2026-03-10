"""
ResMLP SystemC Testbench Stimulus (Pure PyTorch Math)
"""
import os
import numpy as np
import timm
import torch
import torch.nn.functional as F

# --- SystemC Hardware Configuration ---
ACT_WIDTH = 16
ACT_FRAC = 12
OUT_WIDTH = 8
OUT_FRAC = 4

def float_to_fixed_bin(tensor, filename, total_bits, frac_bits):
    """Quantizes using static scaling and returns the dequantized float tensor."""
    scale = 2 ** frac_bits
    qmin, qmax = -(2 ** (total_bits - 1)), (2 ** (total_bits - 1)) - 1
    
    q_tensor_int = torch.round(tensor * scale).clamp(qmin, qmax)
    
    np_type = np.int8 if total_bits == 8 else np.int16
    q_tensor_int.to(torch.int32).detach().numpy().astype(np_type).tofile(filename)
    
    return q_tensor_int / scale 

def main():
    out_dir = "tb_data"
    os.makedirs(out_dir, exist_ok=True)
    
    # Load Model
    model = timm.create_model('resmlp_12_224.fb_in1k', pretrained=True).eval()
    block = model.blocks[0]
    
    # Get 1 Dummy Token 
    torch.manual_seed(42)
    x_tok = torch.randn(1, 1, 384) 

    # Slice 1 Token, 16 Output Channels
    x_tok_sliced = x_tok[:, 0:1, :] # [1, 1, 384]
    fc1_w_sliced = block.mlp_channels.fc1.weight[0:16, :] # [16, 384]

    with torch.no_grad():
        print("Quantizing Inputs...")
        x_tok_hw    = float_to_fixed_bin(x_tok_sliced[0], f"{out_dir}/hw_in_x_tok.bin", ACT_WIDTH, ACT_FRAC)
        norm2_a     = float_to_fixed_bin(block.norm2.alpha, f"{out_dir}/hw_w_norm2_alpha.bin", ACT_WIDTH, ACT_FRAC)
        norm2_b     = float_to_fixed_bin(block.norm2.beta if hasattr(block.norm2, 'beta') else torch.zeros_like(block.norm2.alpha), f"{out_dir}/hw_w_norm2_beta.bin", ACT_WIDTH, ACT_FRAC)
        fc1_w       = float_to_fixed_bin(fc1_w_sliced, f"{out_dir}/hw_w_fc1_weight.bin", OUT_WIDTH, OUT_FRAC)

        print("Phase 1: Affine Norm...")
        hw_golden_norm2 = (x_tok_hw * norm2_a) + norm2_b
        hw_golden_norm2 = float_to_fixed_bin(hw_golden_norm2, f"{out_dir}/golden_1_norm2.bin", OUT_WIDTH, OUT_FRAC)

        print("Phase 2: PECore Matrix Multiplication...")
        # 1. Pure PyTorch Math
        hw_golden_fc1_mm = torch.matmul(hw_golden_norm2, fc1_w.T) 
        
        # 2. Emulate the hardware's intrinsic Datapath scaling
        hw_scaled_fc1_mm = hw_golden_fc1_mm * (167 / 32768.0)
        
        # 3. Quantize and Save
        float_to_fixed_bin(hw_scaled_fc1_mm, f"{out_dir}/golden_2_fc1_matmul.bin", ACT_WIDTH, ACT_FRAC)

    print("Success! 'Pure PyTorch' SystemC stimulus generated.")

if __name__ == "__main__":
    main()