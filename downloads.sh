#!/bin/bash
set -e
C=/workspace/ComfyUI

mkdir -p $C/models/{checkpoints,vae,text_encoders,clip_vision,loras,onnx,sam2}

wget -O $C/models/text_encoders/umt5-xxl-enc-bf16.safetensors https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors || true
wget -O $C/models/vae/Wan2_1_VAE_bf16.safetensors https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors || true
wget -O $C/models/clip_vision/clip_vision_h.safetensors https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/clip_vision_h.safetensors || true

wget -O $C/models/loras/WanAnimate_relight_lora_fp16.safetensors https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22_relight/WanAnimate_relight_lora_fp16.safetensors || true
wget -O $C/models/loras/lightx2v_l2v_14B_480p_cfg_step_distill_rank64_bf16.safetensors https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_l2v_14B_480p_cfg_step_distill_rank64_bf16.safetensors || true

wget -O $C/models/onnx/det_yolov10m.onnx https://huggingface.co/Wan-AI/Wan2.2-Animate-14B/resolve/main/process_checkpoint/det_yolov10m.onnx || true
wget -O $C/models/onnx/vitpose-l-wholebody.onnx https://huggingface.co/JunkyByte/easy_ViTPose/resolve/main/onnx/vitpose-l-wholebody.onnx || true

wget -O $C/models/sam2/sam2_hiera_base_plus.safetensors https://huggingface.co/Kijai/sam2-safetensors/resolve/main/sam2_hiera_base_plus.safetensors || true

C=/workspace/ComfyUI
cd $C/models/checkpoints
[ -d WanVideo_comfy_fp8_scaled ] || GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled
cd $C/models/checkpoints/WanVideo_comfy_fp8_scaled
git lfs install
git lfs pull --include="Wan22Animate/*" || true
ln -sfn $C/models/checkpoints/WanVideo_comfy_fp8_scaled/Wan22Animate $C/models/checkpoints/Wan22Animate || true
