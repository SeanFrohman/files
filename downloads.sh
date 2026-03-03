#!/bin/bash
set -e

C=/workspace/ComfyUI

mkdir -p "$C/models/diffusion_models"
mkdir -p "$C/models/vae"
mkdir -p "$C/models/loras"
mkdir -p "$C/models/text_encoders"

# WAN 2.1 VACE 14B (34.7 GB)
wget -c -O "$C/models/diffusion_models/wan2.1_vace_14B_fp16.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_vace_14B_fp16.safetensors"

# WAN 2.1 VACE 1.3B (smaller, faster)
wget -c -O "$C/models/diffusion_models/wan2.1_vace_1.3B_fp16.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_vace_1.3B_fp16.safetensors"

# WAN 2.1 VAE
wget -c -O "$C/models/vae/wan_2.1_vae.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors"

# Text encoder FP8 (6.74 GB, faster/smaller)
wget -c -O "$C/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

# Text encoder FP16 (full quality)
wget -c -O "$C/models/text_encoders/umt5_xxl_fp16.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors"

# CausVid LoRA 1.3B
wget -c -O "$C/models/loras/Wan21_CausVid_bidirect2_T2V_1_3B_lora_rank32.safetensors" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan21_CausVid_bidirect2_T2V_1_3B_lora_rank32.safetensors"

# CausVid LoRA 14B
wget -c -O "$C/models/loras/Wan21_CausVid_14B_T2V_lora_rank32.safetensors" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan21_CausVid_14B_T2V_lora_rank32.safetensors"

echo "[DOWNLOADS] All models downloaded."
