#!/usr/bin/env bash
set -e  # Exit on error

# --- Function to check command existence ---
command_exists() { command -v "$1" >/dev/null 2>&1; }

echo "===== MMFlow Smart Setup Script ====="

# --- Step 0: Install Miniconda if missing ---
if [ -d "$HOME/miniconda" ]; then
    echo "Miniconda already installed. Skipping installation."
else
    echo "Installing Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/Miniconda3-latest-Linux-x86_64.sh
    bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
fi

# --- Step 1: Initialize conda ---
export PATH="$HOME/miniconda/bin:$PATH"
eval "$(conda shell.bash hook)"

# --- Step 1b: Accept ToS ---
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# --- Step 2: Create environment if missing ---
if conda info --envs | grep -q "mmflow"; then
    echo "Conda environment 'mmflow' exists. Skipping creation."
else
    echo "Creating conda environment 'mmflow'..."
    conda create -n mmflow python=3.8 -y
fi

conda activate mmflow

# --- Step 3: Install PyTorch for A100 SXM ---
if python -c "import torch" &> /dev/null; then
    echo "PyTorch installed. Skipping."
else
    echo "Installing PyTorch..."
    pip install torch==1.12.1+cu116 torchvision==0.13.1+cu116 torchaudio==0.12.1 \
        --extra-index-url https://download.pytorch.org/whl/cu116
fi

# --- Step 4: Install MMEngine ---
pip install --upgrade pip
pip install openmim
mim install mmengine
pip install scipy

# --- Step 5: Install MMCV ---
if python -c "import mmcv" &> /dev/null; then
    echo "MMCV installed. Skipping."
else
    mim install mmcv-full
fi

# --- Step 6: Clone MMFlow repo ---
if [ -d "mmflow" ]; then
    echo "MMFlow repo exists. Skipping clone."
else
    git clone https://github.com/open-mmlab/mmflow.git
fi

cd mmflow
pip install -v -e .

# --- Step 7: Install Jupyter kernel ---
conda install ipykernel -y
python -m ipykernel install --user --name=mmflow --display-name "Python (mmflow)"

echo "===== MMFlow setup completed! Activate with: conda activate mmflow ====="