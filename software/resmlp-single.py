"""
ResMLP Layer 1: Float32 vs Int16/Int8 Hardware Emulation
"""
import torch
import torch.nn.functional as F
import timm
from urllib.request import urlopen
from PIL import Image

# --- Bit-Accurate Hardware Emulation Functions ---
FRC = 12
def fl2fx16(t): return torch.round(t * (2**FRC)).clamp(-32768, 32767).to(torch.int32)
def fl2fx8(t):  return torch.round(t * (2**4)).clamp(-128, 127).to(torch.int32)

def hw_emul(a, b): return ((torch.bitwise_right_shift(a * b, 12) + 32768) % 65536 - 32768)
def hw_eadd(a, b): return ((a + b + 32768) % 65536 - 32768)
def hw_outgb(a):   return torch.clamp(torch.bitwise_right_shift(a + 128, 8), -128, 127).to(torch.int8)
def hw_promote(a): return torch.bitwise_left_shift(a.to(torch.int32), 8).to(torch.int32)

def hw_matmul(a_int8, w_int8):
    accum = torch.matmul(a_int8.to(torch.int32), w_int8.T.to(torch.int32))
    return torch.clamp(torch.bitwise_right_shift(accum * 167, 11), -32768, 32767).to(torch.int16)

def hw_gelu(a_int16):
    g_float = F.gelu(a_int16.to(torch.float32) / (2**FRC))
    return torch.round(g_float * (2**FRC)).clamp(-32768, 32767).to(torch.int32)

def main():
    print("Loading Model and Image...")
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

        # =================================================================
        # 1. PURE PYTORCH FLOAT32 EXECUTION
        # =================================================================
        # Token Mixing (Safely maintaining the 3D batch dimension)
        x_norm1_f = (x_padded * block.norm1.alpha) + (block.norm1.beta if hasattr(block.norm1, 'beta') else 0)
        tok_w, tok_b = F.pad(block.linear_tokens.weight, (0, 12, 0, 12)), F.pad(block.linear_tokens.bias, (0, 12))
        tok_out_f = torch.matmul(x_norm1_f.transpose(1, 2), tok_w.T) + tok_b
        tok_out_f = tok_out_f.transpose(1, 2)
        
        # Extract 2D Tensors for the Channel-Mixing backend
        x_0 = x_padded[0]
        tok_out_0 = tok_out_f[0]
        
        # LS1 + Residual
        x_tok_f = x_0 + (block.ls1 * tok_out_0)
        
        # Channel Mixing
        x_scl_f = (x_tok_f * block.norm2.alpha) + (block.norm2.beta if hasattr(block.norm2, 'beta') else 0)
        fc1_w, fc1_b = block.mlp_channels.fc1.weight, block.mlp_channels.fc1.bias
        fc2_w, fc2_b = block.mlp_channels.fc2.weight, block.mlp_channels.fc2.bias
        
        ch_hid_f = F.gelu(torch.matmul(x_scl_f, fc1_w.T) + fc1_b)
        ch_out_f = torch.matmul(ch_hid_f, fc2_w.T) + fc2_b
        
        # Final LS2 + Residual
        fp32_final = x_tok_f + (block.ls2 * ch_out_f)

        # =================================================================
        # 2. HARDWARE BIT-ACCURATE EMULATION
        # =================================================================
        hw_x       = fl2fx16(x_0)
        hw_tok_out = fl2fx16(tok_out_0) 
        hw_ls1     = fl2fx16(block.ls1)
        hw_n2_a    = fl2fx16(block.norm2.alpha)
        hw_n2_b    = fl2fx16(block.norm2.beta if hasattr(block.norm2, 'beta') else torch.zeros_like(block.norm2.alpha))
        hw_fc1_b   = fl2fx16(fc1_b)
        hw_fc2_b   = fl2fx16(fc2_b)
        hw_ls2     = fl2fx16(block.ls2)
        hw_fc1_w   = fl2fx8(fc1_w)
        hw_fc2_w   = fl2fx8(fc2_w)

        # 6-Phase Pipeline
        hw_x_tok = hw_outgb(hw_eadd(hw_emul(hw_tok_out, hw_ls1), hw_x))
        x_tok_promoted = hw_promote(hw_x_tok)
        hw_x_scl = hw_outgb(hw_eadd(hw_emul(x_tok_promoted, hw_n2_a), hw_n2_b))
        hw_raw1 = hw_matmul(hw_x_scl, hw_fc1_w)
        hw_ch_hid = hw_outgb(hw_gelu(hw_eadd(hw_raw1, hw_fc1_b)))
        hw_raw2 = hw_matmul(hw_ch_hid, hw_fc2_w)
        hw_final = hw_outgb(hw_eadd(hw_emul(hw_eadd(hw_raw2, hw_fc2_b), hw_ls2), x_tok_promoted))

        # Dequantize Hardware Output back to Float
        hw_final_dequantized = hw_final.to(torch.float32) / (2**4)

        # =================================================================
        # 3. STATISTICAL COMPARISON
        # =================================================================
        mse = F.mse_loss(fp32_final, hw_final_dequantized).item()
        cos_sim = F.cosine_similarity(fp32_final.flatten(), hw_final_dequantized.flatten(), dim=0).item()
        max_diff = torch.max(torch.abs(fp32_final - hw_final_dequantized)).item()

        print("\n--- Layer 1 Quantization Analysis ---")
        print(f"Mean Squared Error (MSE): {mse:.6f}")
        print(f"Max Absolute Error:       {max_diff:.6f}")
        print(f"Cosine Similarity:        {cos_sim:.6f} (1.0 is a perfect match)")
        
        if cos_sim > 0.99:
            print("Conclusion: The hardware datapath retains near-perfect spatial representation!")

if __name__ == "__main__":
    main()