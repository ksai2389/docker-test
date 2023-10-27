#!/bin/bash

# Get your current host nvidia driver version, e.g. 340.24
NVPROC=/proc/driver/nvidia/version
[ ! -f $NVPROC ] && echo "nvidia driver not loaded on host, or non-nvidia host" && exit 0
NVVER=$(cat $NVPROC | head -n 1 | awk '{ print $8 }')
NVFILE=NVIDIA-Linux-x86_64-$NVVER.run
cd /tmp
wget -c "http://us.download.nvidia.com/XFree86/Linux-x86_64/$NVVER/$NVFILE"
chmod +x $NVFILE
sudo ./$NVFILE -s -N --no-kernel-module
rm $NVFILE
