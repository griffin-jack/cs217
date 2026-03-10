import torch
import torch.nn.functional as F
import timm
from urllib.request import urlopen
from PIL import Image
import ast

# --- Hardware Constants & Emulation Functions ---
FRC = 12
def fl2fx16(t): return torch.round(t * (2**FRC)).clamp(-32768, 32767).to(torch.int32)
def fl2fx8(t):  return torch.round(t * (2**4)).clamp(-128, 127).to(torch.int32)
def hw_emul(a, b): return ((torch.bitwise_right_shift(a * b, 12) + 32768) % 65536 - 32768)
def hw_eadd(a, b): return ((a + b + 32768) % 65536 - 32768)
def hw_outgb(a):   return torch.clamp(torch.bitwise_right_shift(a + 128, 8), -128, 127).to(torch.int8)
def hw_promote(a): return torch.bitwise_left_shift(a.to(torch.int32), 8).to(torch.int32)
def hw_matmul(a, w): return torch.clamp(torch.bitwise_right_shift(torch.matmul(a.to(torch.int32), w.T.to(torch.int32)) * 167, 11), -32768, 32767).to(torch.int16)
def hw_gelu(a): return torch.round(F.gelu(a.to(torch.float32) / (2**FRC)) * (2**FRC)).clamp(-32768, 32767).to(torch.int32)

def execute_hardware_block(x_float, block):
    """Simulates CPU/FPGA Coprocessing for a single ResMLP Block"""
    
    # [ CPU Phase: Token Mixing Transpose & Linear ]
    x_norm1 = (x_float * block.norm1.alpha) + (block.norm1.beta if hasattr(block.norm1, 'beta') else 0)
    tok_w, tok_b = F.pad(block.linear_tokens.weight, (0, 12, 0, 12)), F.pad(block.linear_tokens.bias, (0, 12))
    tok_out_f = torch.matmul(x_norm1.transpose(0, 1), tok_w.T) + tok_b
    tok_out_f = tok_out_f.transpose(0, 1)

    # Quantize for FPGA handoff
    hw_x       = fl2fx16(x_float)
    hw_tok_out = fl2fx16(tok_out_f)
    hw_ls1     = fl2fx16(block.ls1)
    hw_n2_a    = fl2fx16(block.norm2.alpha)
    hw_n2_b    = fl2fx16(block.norm2.beta if hasattr(block.norm2, 'beta') else torch.zeros_like(block.norm2.alpha))
    hw_fc1_b   = fl2fx16(block.mlp_channels.fc1.bias)
    hw_fc2_b   = fl2fx16(block.mlp_channels.fc2.bias)
    hw_ls2     = fl2fx16(block.ls2)
    hw_fc1_w   = fl2fx8(block.mlp_channels.fc1.weight)
    hw_fc2_w   = fl2fx8(block.mlp_channels.fc2.weight)

    # [ FPGA Phase: 6-Step Emulation ]
    hw_x_tok = hw_outgb(hw_eadd(hw_emul(hw_tok_out, hw_ls1), hw_x))
    x_tok_promoted = hw_promote(hw_x_tok)
    
    hw_x_scl = hw_outgb(hw_eadd(hw_emul(x_tok_promoted, hw_n2_a), hw_n2_b))
    hw_raw1 = hw_matmul(hw_x_scl, hw_fc1_w)
    hw_ch_hid = hw_outgb(hw_gelu(hw_eadd(hw_raw1, hw_fc1_b)))
    hw_raw2 = hw_matmul(hw_ch_hid, hw_fc2_w)
    hw_final = hw_outgb(hw_eadd(hw_emul(hw_eadd(hw_raw2, hw_fc2_b), hw_ls2), x_tok_promoted))

    # Dequantize for next CPU handoff (Q4.4 format)
    return hw_final.to(torch.float32) / (2**4)

def main():
    print("Loading ResMLP-12 Model and ImageNet Labels...")
    model = timm.create_model('resmlp_12_224.fb_in1k', pretrained=True).eval()
    
    # Get standard ImageNet-1k labels
    imagenet_classes = ast.literal_eval(urlopen("https://raw.githubusercontent.com/raghakot/keras-resnet/master/imagenet_classes.txt").read().decode('utf-8'))

    url = 'https://hips.hearstapps.com/hmg-prod/images/schnauzer-carrying-lead-6643258113665.jpeg'
    image = Image.open(urlopen(url)).convert("RGB")
    data_config = timm.data.resolve_model_data_config(model)
    transforms = timm.data.create_transform(**data_config, is_training=False)
    input_img = transforms(image).unsqueeze(0)

    with torch.no_grad():
        # Baseline Float32 Execution
        print("\nExecuting Standard Float32 PyTorch Model...")
        fp32_logits = model(input_img)
        fp32_probs = torch.nn.functional.softmax(fp32_logits[0], dim=0)
        fp32_top5 = torch.topk(fp32_probs, 5)

        # Hardware Emulated Execution
        print("Executing 12-Layer CPU/FPGA Hardware Emulation...")
        x = model.stem(input_img)
        x_padded = F.pad(x, (0, 0, 0, 12)) 
        
        # Loop the Token through all 12 Hardware Blocks
        current_x = x_padded[0]
        for i, block in enumerate(model.blocks):
            print(f"  Processing Block {i+1}/12...")
            current_x = execute_hardware_block(current_x, block)
            
        # Revert Padding and run through standard Classification Head
        current_x = current_x[:, :-12].unsqueeze(0)
        hw_logits = model.head(model.norm(current_x.mean(dim=1)))
        hw_probs = torch.nn.functional.softmax(hw_logits[0], dim=0)
        hw_top5 = torch.topk(hw_probs, 5)

        print("\n=== CLASSIFICATION RESULTS ===")
        print("Standard PyTorch Float32 Top-5:")
        for prob, idx in zip(fp32_top5.values, fp32_top5.indices):
            print(f"  {prob.item():.4f} - {imagenet_classes[idx.item()]}")

        print("\nHardware Int16/Int8 Emulation Top-5:")
        for prob, idx in zip(hw_top5.values, hw_top5.indices):
            print(f"  {prob.item():.4f} - {imagenet_classes[idx.item()]}")

if __name__ == "__main__":
    main()