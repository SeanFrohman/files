#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

export HF_HOME=/workspace/.cache/huggingface
export HUGGINGFACE_HUB_CACHE=$HF_HOME
export TRANSFORMERS_CACHE=$HF_HOME
export TORCH_HOME=/workspace/.cache/torch

mkdir -p "$HF_HOME" "$TORCH_HOME" /workspace/models

apt-get update -y
apt-get install -y git git-lfs wget ca-certificates python3 python3-venv python3-pip
git lfs install

if [ -n "$HF_TOKEN" ]; then
  git config --global credential.helper store
  printf "https://user:%s@huggingface.co\n" "$HF_TOKEN" > /root/.git-credentials
fi

cd /workspace
if [ ! -d ComfyUI ]; then
  git clone https://github.com/comfyanonymous/ComfyUI.git
else
  cd ComfyUI && git pull || true
fi

C=/workspace/ComfyUI
cd "$C"
python3 -m venv venv || true
. venv/bin/activate
pip install -U pip setuptools wheel
pip install -r requirements.txt

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
  name=$(basename "$r")
  if [ ! -d "$name" ]; then
    git clone "$r" || true
  else
    (cd "$name" && git pull || true)
  fi
done

wget -O /workspace/scripts/downloads.sh \
  https://raw.githubusercontent.com/SeanFrohman/files/main/downloads.sh
chmod +x /workspace/scripts/downloads.sh
/workspace/scripts/downloads.sh || true
