#!/bin/bash

echo "FlowFormer++ Setup Started"

# ---------------------------
# 1. Install Miniconda locally
# ---------------------------
if [ ! -d "./miniconda" ]; then
    echo "Installing Miniconda"
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p ./miniconda
else
    echo "Miniconda already exists"
fi

export PATH="$(pwd)/miniconda/bin:$PATH"
source ./miniconda/etc/profile.d/conda.sh

# ---------------------------
# 2. Accept Conda Terms
# ---------------------------
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# ---------------------------
# 3. Create Environment
# ---------------------------
if conda info --envs | grep -q "flowformerpp"; then
    echo "Environment exists"
else
    echo "Creating environment flowformerpp"
    conda create -n flowformerpp python=3.9 -y
fi

conda activate flowformerpp

# ---------------------------
# 4. Install PyTorch CUDA 12.8
# ---------------------------
echo "Installing PyTorch"
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

# verify torch before compiling extensions
python -c "import torch; print('Torch version:', torch.__version__)"

# ---------------------------
# 5. Install Dependencies
# ---------------------------
echo "Installing dependencies"
pip install "numpy<2.0"
pip install matplotlib opencv-python pillow scipy glob2 tqdm pandas
pip install scikit-learn
pip install yacs timm==0.4.12 loguru einops

# install correlation extension correctly
pip install --no-build-isolation git+https://github.com/ClementPinard/Pytorch-Correlation-extension.git

# ---------------------------
# 6. Clone FlowFormer++
# ---------------------------
if [ ! -d "./FlowFormerPlusPlus" ]; then
    echo "Cloning FlowFormerPlusPlus"
    git clone https://github.com/XiaoyuShi97/FlowFormerPlusPlus.git
else
    echo "Repository already exists"
fi

cd FlowFormerPlusPlus || exit

# ---------------------------
# 7. Install Jupyter Kernel
# ---------------------------
conda install -y jupyter notebook ipykernel
python -m ipykernel install --user --name=flowformerpp --display-name "FlowFormerPP"

# ---------------------------
# 8. Prepare Checkpoints Folder
# ---------------------------
mkdir -p checkpoints

echo "Place pretrained model at FlowFormerPlusPlus/checkpoints/sintel.pth"

echo "Setup Complete"
echo "Activate environment using: conda activate flowformerpp"
echo "Run demo using: python demo.py"