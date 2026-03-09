"""
ResMLP SystemC Testbench Stimulus Generator

This script splits a ResMLP layer into two phases:
1. Software Phase: Handles patch embedding and the transpose-heavy token-mixing block.
2. Hardware Phase: The channel-mixing block (element-wise ops and non-transposed matmuls).

It exports exactly what the SystemC simulation needs:
- Padded and quantized hardware input activations.
- Quantized static weights/biases.
- Incremental "Golden" tensors to verify each hardware module step-by-step.
"""
import os
from urllib.request import urlopen
from PIL import Image
import numpy as np
import timm
import torch
import torch.nn.functional as F

# --- SystemC Hardware Configuration ---
# Based on Spec.h: kIntWordWidth = 8, biases/accumulators typically 16/32
ACT_BITS = 8
WEIGHT_BITS = 8
BIAS_BITS = 16

def quantize_and_save(tensor, filename, num_bits=8):
    """
    Quantizes a float32 tensor symmetrically and saves it as a flat raw binary file.
    Returns the quantized tensor in float format for accurate golden modeling downstream.
    """
    qmin, qmax = -(2 ** (num_bits - 1)), (2 ** (num_bits - 1)) - 1
    
    # Calculate scale factor (avoid division by zero)
    scale = qmax / torch.max(torch.abs(tensor)).clamp(min=1e-5)
    
    # Quantize, clamp, and dequantize to keep PyTorch math representative of hardware precision loss
    q_tensor_int = torch.round(tensor * scale).clamp(qmin, qmax)
    q_tensor_dq = q_tensor_int / scale 
    
    # Cast to appropriate numpy type and dump to binary
    np_type = np.int8 if num_bits == 8 else np.int16
    q_tensor_int.to(torch.int32).detach().numpy().astype(np_type).tofile(filename)
    
    return q_tensor_dq

def main():
    out_dir = "tb_data"
    os.makedirs(out_dir, exist_ok=True)
    print(f"Generating SystemC Stimulus in ./{out_dir}/")

    # 1. Load Model (ResMLP 12-layer, 224x224 input)
    model = timm.create_model('resmlp_12_224.fb_in1k', pretrained=True).eval()
    block = model.blocks[0] # Target Layer 0

    # 2. Get Input Image
    url = 'https://hips.hearstapps.com/hmg-prod/images/schnauzer-carrying-lead-6643258113665.jpeg'
    image = Image.open(urlopen(url)).convert("RGB")
    data_config = timm.data.resolve_model_data_config(model)
    transforms = timm.data.create_transform(**data_config, is_training=False)
    input_img = transforms(image).unsqueeze(0)

    with torch.no_grad():
        # =====================================================================
        # [ SOFTWARE PHASE ] - Handled by CPU
        # =====================================================================
        # Patch embedding (196 tokens, 384 channels)
        x = model.stem(input_img) 
        
        # Hardware padding: 196 tokens -> 208 tokens (Multiple of 16 for kVectorSize)
        x_padded = F.pad(x, (0, 0, 0, 12)) 
        
        # Token-Mixing Block (Contains transposes - stay in software!)
        norm1_a = block.norm1.alpha
        norm1_b = block.norm1.beta if hasattr(block.norm1, 'beta') else torch.zeros_like(norm1_a)
        tok_w   = F.pad(block.linear_tokens.weight, (0, 12, 0, 12)) 
        tok_b   = F.pad(block.linear_tokens.bias, (0, 12))          
        
        x_norm1 = (x_padded * norm1_a) + norm1_b
        # Transposed Matrix Multiplication (Software task)
        tok_out = torch.matmul(x_norm1.transpose(1, 2), tok_w.T) + tok_b
        
        # The Checkpoint: The final token-mixed tensor
        x_tok = x_padded + block.ls1 * tok_out.transpose(1, 2)
        
        # =====================================================================
        # [ HANDOFF TO HARDWARE ]
        # =====================================================================
        print("Quantizing Checkpoint Input...")
        x_tok_hw = quantize_and_save(x_tok, f"{out_dir}/hw_in_x_tok.bin", ACT_BITS)

        # =====================================================================
        # [ HARDWARE PHASE ] - Channel Mixing (No Transposes)
        # =====================================================================
        print("Quantizing Weights & Biases...")
        norm2_a  = quantize_and_save(block.norm2.alpha, f"{out_dir}/hw_w_norm2_alpha.bin", WEIGHT_BITS)
        norm2_b  = quantize_and_save(block.norm2.beta if hasattr(block.norm2, 'beta') else torch.zeros_like(norm2_a), f"{out_dir}/hw_w_norm2_beta.bin", BIAS_BITS)
        
        fc1_w    = quantize_and_save(block.mlp_channels.fc1.weight, f"{out_dir}/hw_w_fc1_weight.bin", WEIGHT_BITS)
        fc1_b    = quantize_and_save(block.mlp_channels.fc1.bias,   f"{out_dir}/hw_w_fc1_bias.bin", BIAS_BITS)
        
        fc2_w    = quantize_and_save(block.mlp_channels.fc2.weight, f"{out_dir}/hw_w_fc2_weight.bin", WEIGHT_BITS)
        fc2_b    = quantize_and_save(block.mlp_channels.fc2.bias,   f"{out_dir}/hw_w_fc2_bias.bin", BIAS_BITS)
        
        ls2      = quantize_and_save(block.ls2, f"{out_dir}/hw_w_ls2.bin", WEIGHT_BITS)

        # --- Generate Incremental Golden Outputs ---
        print("Generating Incremental Golden Outputs...")
        
        # 1. Affine Normalization (Tests ActUnit EMUL + EADD)
        hw_golden_norm2 = (x_tok_hw * norm2_a) + norm2_b
        hw_golden_norm2 = quantize_and_save(hw_golden_norm2, f"{out_dir}/golden_1_norm2.bin", ACT_BITS)

        # 2. First MatMul & GELU (Tests PECore Matmul + ActUnit GELU)
        hw_golden_fc1_mm = torch.matmul(hw_golden_norm2, fc1_w.T) + fc1_b
        hw_golden_fc1_mm = quantize_and_save(hw_golden_fc1_mm, f"{out_dir}/golden_2_fc1_matmul.bin", ACT_BITS)
        
        hw_golden_gelu = F.gelu(hw_golden_fc1_mm)
        hw_golden_gelu = quantize_and_save(hw_golden_gelu, f"{out_dir}/golden_3_fc1_gelu.bin", ACT_BITS)

        # 3. Second MatMul (Tests PECore Matmul)
        hw_golden_fc2_mm = torch.matmul(hw_golden_gelu, fc2_w.T) + fc2_b
        hw_golden_fc2_mm = quantize_and_save(hw_golden_fc2_mm, f"{out_dir}/golden_4_fc2_matmul.bin", ACT_BITS)

        # 4. LayerScale & Residual Add (Tests ActUnit EMUL + EADD)
        hw_golden_final = x_tok_hw + (ls2 * hw_golden_fc2_mm)
        quantize_and_save(hw_golden_final, f"{out_dir}/golden_5_final_output.bin", ACT_BITS)

    print("Success! SystemC stimulus files are ready in 'tb_data/'.")

if __name__ == "__main__":
    main()