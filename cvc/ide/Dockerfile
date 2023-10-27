FROM docker-registry.qualcomm.com/xrresearch/cvc:latest

# Jetbrains IDE dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libxi6 libxtst6 libxrender1 libxext6 libx11-6 libfontconfig1 && \
    rm -rf /var/lib/apt/lists/*

# CLion dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libsecret-1-0 gnome-keyring git git-man && \
    rm -rf /var/lib/apt/lists/*

# VNC server and basic WM and terminal
RUN apt-get update && \
    apt-get install -y --no-install-recommends tightvncserver xfonts-base openbox xterm && \
    rm -rf /var/lib/apt/lists/*

# Qt3DView dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libxcb-icccm4 \
                                               libxcb-image0 \
                                               libxcb-keysyms1 \
                                               libxcb-render-util0 \
                                               libxcb-xinerama0 && \
    rm -rf /var/lib/apt/lists/*
