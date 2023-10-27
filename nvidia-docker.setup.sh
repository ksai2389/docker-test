#!/bin/bash

# chdir to prevent apt root-squash errors
cd /tmp

# verbose
set -x

# install nvidia key/repo
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |   sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list |   sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# install nvidia-docker
sudo apt update
sudo apt install -y nvidia-docker2
sudo systemctl restart docker.service

# validate with nvidia-smi outside and inside docker
nvidia-smi
docker run --rm --gpus all docker-registry.qualcomm.com/xrresearch/nvidia/cuda:11.0.3-base nvidia-smi