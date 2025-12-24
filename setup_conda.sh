#!/usr/bin/env bash
set -e  # Exit immediately if a command fails

if [ $# -ne 1 ]; then
    echo "Usage: $0 <python_version>"
    exit 1
fi

PYTHON_VERSION=$1

if [ ! -d ~/miniconda3 ]; then
    echo "Miniconda not found. Installing..."
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
else
    echo "Miniconda already installed."
fi
set --
source ~/miniconda3/bin/activate
conda init --all
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

ENV_NAME="hack"

if conda env list | grep -q "^$ENV_NAME"; then
    echo "Conda environment '$ENV_NAME' already exists."
else
    echo "Creating conda environment '$ENV_NAME' with Python $PYTHON_VERSION..."
    conda create -n "$ENV_NAME" python="$PYTHON_VERSION" -y
fi

if ! grep -q "conda activate $ENV_NAME" ~/.bashrc; then
    echo "conda activate $ENV_NAME" >> ~/.bashrc
fi

echo "======================================"
echo "Setup complete!"
echo "Environment: $ENV_NAME"
echo "Python version: $PYTHON_VERSION"
echo "Restart your shell or run: source ~/.bashrc"
echo "======================================"
