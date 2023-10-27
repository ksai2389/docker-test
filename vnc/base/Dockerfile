FROM ubuntu:xenial

# crad-docker assumes python is installed in image
RUN apt-get update && \
    apt-get install -y --no-install-recommends python && \
    rm -rf /var/lib/apt/lists/*

# grant sudo capability to "users" group
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/*
RUN echo "%users ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# NVIDIA GPU support
# for testing xeyes/glxgears and xrandr
RUN apt-get update && \
    apt-get install -y --no-install-recommends x11-apps mesa-utils x11-xserver-utils && \
    rm -rf /var/lib/apt/lists/*

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# VNC server and basic WM and terminal
RUN apt-get update && \
    apt-get install -y --no-install-recommends tightvncserver xfonts-base openbox xterm && \
    rm -rf /var/lib/apt/lists/*
