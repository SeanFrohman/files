#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# Caches
export HF_HOME=/workspace/.cache/huggingface
export HUGGINGFACE_HUB_CACHE=$HF_HOME
export TRANSFORMERS_CACHE=$HF_HOME
export TORCH_HOME=/workspace/.cache/torch

mkdir -p "$HF_HOME" "$TORCH_HOME" /workspace/models /workspace/scripts

# Basic packages
apt-get update -y
apt-get install -y git git-lfs wget ca-certificates python3 python3-venv python3-pip
git lfs install

# Hugging Face auth (uses HF_TOKEN env var set in Vast template)
if [ -n "$HF_TOKEN" ]; then
  git config --global credential.helper store
  printf "https://user:%s@huggingface.co\n" "$HF_TOKEN" > /root/.git-credentials
fi

# ComfyUI clone
cd /workspace
git clone https://github.com/comfyanonymous/ComfyUI.git || true

C=/workspace/ComfyUI
cd "$C"

# Python venv
python3 -m venv venv || true
. venv/bin/activate
pip install -U pip setuptools wheel
pip install -r requirements.txt

# OPTIONAL torch override – only if CUDA not available
python - << 'EOF' || true
import torch
import sys
try:
    print("Torch version:", torch.__version__)
    print("CUDA available:", torch.cuda.is_available())
except Exception as e:
    print("Torch check error:", e, file=sys.stderr)
EOF

if ! python - << 'EOF'
import torch
import torch.cuda
print(torch.cuda.is_available())
EOF
then
  pip install --force-reinstall --index-url https://download.pytorch.org/whl/cu128 \
    torch torchvision torchaudio
fi

# Custom nodes
mkdir -p "$C/custom_nodes"
cd "$C/custom_nodes"
for r in \
  https://github.com/ltdrdata/ComfyUI-Manager \
  https://github.com/kijai/ComfyUI-WanVideoWrapper \
  https://github.com/kijai/ComfyUI-WanAnimatePreprocess \
  https://github.com/kijai/ComfyUI-KJNodes \
  https://github.com/kijai/ComfyUI-segment-anything-2 \
  https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite \
  https://github.com/Fannovel16/comfyui_controlnet_aux
do
  git clone "$r" || true
done

# WAN + other model downloads
wget -O /workspace/scripts/downloads.sh \
  https://raw.githubusercontent.com/SeanFrohman/files/refs/heads/main/downloads.sh
chmod +x /workspace/scripts/downloads.sh
/workspace/scripts/downloads.sh || true
