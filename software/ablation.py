"""
ResMLP Hardware Ablation Test: Isolating Quantization Degradation
"""
import torch
import torch.nn.functional as F
import timm
from urllib.request import urlopen
from PIL import Image

FRC = 12
def fl2fx16(t): return torch.round(t * (2**FRC)).clamp(-32768, 32767).to(torch.int32)
def fl2fx8(t):  return torch.round(t * (2**4)).clamp(-128, 127).to(torch.int32)

def hw_matmul_ablation(a_float, w_float):
    """Isolates the 8-bit MatMul truncation error"""
    a_int8 = fl2fx8(a_float)
    w_int8 = fl2fx8(w_float)
    
    # Simulate hardware accumulator and truncation
    accum = torch.matmul(a_int8.to(torch.int32), w_int8.T.to(torch.int32))
    hw_raw = torch.clamp(torch.bitwise_right_shift(accum * 167, 11), -32768, 32767).to(torch.int16)
    
    # Dequantize by the exact hardware scale (256 * 167 / 2048 = 20.875)
    return hw_raw.to(torch.float32) / 20.875

def hw_gelu_ablation(a_float):
    """Isolates the 16-bit GELU approximation error"""
    a_int16 = fl2fx16(a_float)
    hw_gelu_int = torch.round(F.gelu(a_int16.to(torch.float32) / (2**FRC)) * (2**FRC)).clamp(-32768, 32767).to(torch.int32)
    return hw_gelu_int.to(torch.float32) / (2**FRC)

def run_ablation_model(x, model, mode="float32"):
    for block in model.blocks:
        # Token Mixing (Always Float32)
        x_norm1 = (x * block.norm1.alpha) + (block.norm1.beta if hasattr(block.norm1, 'beta') else 0)
        tok_w, tok_b = F.pad(block.linear_tokens.weight, (0, 12, 0, 12)), F.pad(block.linear_tokens.bias, (0, 12))
        tok_out = torch.matmul(x_norm1.transpose(1, 2), tok_w.T) + tok_b
        x = x + block.ls1 * tok_out.transpose(1, 2)

        # Channel Mixing
        x_scl = (x * block.norm2.alpha) + (block.norm2.beta if hasattr(block.norm2, 'beta') else 0)
        fc1_w, fc1_b = block.mlp_channels.fc1.weight, block.mlp_channels.fc1.bias
        fc2_w, fc2_b = block.mlp_channels.fc2.weight, block.mlp_channels.fc2.bias
        
        # --- ABLATION ROUTING ---
        if mode == "quantize_matmul":
            raw1 = hw_matmul_ablation(x_scl, fc1_w)
            ch_hid = F.gelu(raw1 + fc1_b)
            raw2 = hw_matmul_ablation(ch_hid, fc2_w)
            ch_out = raw2 + fc2_b
            
        elif mode == "quantize_gelu":
            raw1 = torch.matmul(x_scl, fc1_w.T) + fc1_b
            ch_hid = hw_gelu_ablation(raw1)
            ch_out = torch.matmul(ch_hid, fc2_w.T) + fc2_b
            
        else: # pure float32
            ch_hid = F.gelu(torch.matmul(x_scl, fc1_w.T) + fc1_b)
            ch_out = torch.matmul(ch_hid, fc2_w.T) + fc2_b

        x = x + block.ls2 * ch_out
        
    return x

def main():
    print("Loading Model...")
    model = timm.create_model('resmlp_12_224.fb_in1k', pretrained=True).eval()
    
    url = "https://raw.githubusercontent.com/pytorch/hub/master/imagenet_classes.txt"
    labels = [s.strip() for s in urlopen(url).read().decode('utf-8').split('\n') if s.strip()]

    url = 'https://hips.hearstapps.com/hmg-prod/images/schnauzer-carrying-lead-6643258113665.jpeg'
    img = Image.open(urlopen(url)).convert("RGB")
    transforms = timm.data.create_transform(**timm.data.resolve_model_data_config(model), is_training=False)
    input_img = transforms(img).unsqueeze(0)

    with torch.no_grad():
        x_stem = model.stem(input_img)
        x_padded = F.pad(x_stem, (0, 0, 0, 12))

        from timm.data.imagenet_info import ImageNetInfo
        imagenet_info = ImageNetInfo()
        label_descriptions = imagenet_info.label_descriptions(detailed=True, as_dict=False)

        modes = ["float32", "quantize_gelu", "quantize_matmul"]
        
        for mode in modes:
            print(f"\n--- Running Mode: {mode.upper()} ---")
            x_out = run_ablation_model(x_padded, model, mode)
            
            # Classification (Fixed Order of Operations)
            x_unpadded = x_out[:, :-12, :]
            x_normed = model.norm(x_unpadded)
            logits = model.head(x_normed.mean(dim=1))
            
            # Softmax to get probabilities
            probs = torch.nn.functional.softmax(logits[0], dim=0)
            
            # Get Top-3 Predictions
            top3_prob, top3_idx = torch.topk(probs, 3)
            
            print(f"=== TOP 3 PREDICTIONS ({mode.upper()}) ===")
            for i in range(3):
                idx = top3_idx[i].item()
                prob = top3_prob[i].item()
                description = label_descriptions[idx]
                print(f"  {i+1}. {prob:.4f} - {description} (ID: {idx})")

if __name__ == "__main__":
    main()