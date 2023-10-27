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

# hexagon installer dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/*

# hexagon sdk
COPY qualcomm_hexagon_sdk.bin / 
RUN /qualcomm_hexagon_sdk.bin -i silent -DDOWNLOAD_ANDROID=false -DUSER_INSTALL_DIR=/Qualcomm -DUSER_SHORTCUTS=/dev/null; exit 0

# hexagon dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends lib32z1 lib32ncurses5 make libgmp10 && \
    rm -rf /var/lib/apt/lists/*

# install adb and lsusb
RUN apt-get update && \
    apt-get install -y --no-install-recommends android-tools-adb usbutils && \
    rm -rf /var/lib/apt/lists/*

# environment variables from /Qualcomm/Hexagon_SDK/3.1/setup_sdk_env.source
ENV ANDROID_ROOT_DIR /Qualcomm/Hexagon_SDK/3.1/tools/android-ndk-r10d
ENV LD_LIBRARY_PATH  /Qualcomm/Hexagon_SDK/3.1/tools/libusb/
ENV HEXAGON_SDK_ROOT /Qualcomm/Hexagon_SDK/3.1
ENV SDK_SETUP_ENV Done
ENV UBUNTU_ROOT_DIR /Qualcomm/Hexagon_SDK/3.1/tools/linaro

# add hexagon tools to path
ENV PATH /Qualcomm/Hexagon_SDK/3.1/tools/HEXAGON_Tools/8.0.07/Tools/bin:${PATH}
