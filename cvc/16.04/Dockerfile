FROM docker-registry.qualcomm.com/library/ubuntu:16.04

# crad-docker assumes python is installed in image
RUN apt-get update && \
    apt-get install -y --no-install-recommends python && \
    rm -rf /var/lib/apt/lists/*

# grant sudo capability to "users" group
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/*
RUN echo "%users ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends make ninja-build clang-3.6 clang++-3.6 libclang-common-3.7-dev && \
    rm -rf /var/lib/apt/lists/*

# configure default compiler (similar to precise/trusty) to help cmake auto discover compiler
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang-3.6 10 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-3.6 10

# add clang symlinks to help qtcreator auto discover compiler
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 10 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 10

# newer cmake
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*
RUN cd /tmp && \
    wget -q https://cmake.org/files/v3.8/cmake-3.8.1-Linux-x86_64.sh && \
    chmod +x cmake*.sh && \
    ./cmake*.sh --skip-license --prefix=/usr/local/ && \
    rm cmake*.sh

# install Qt (in /prj/omnicast) dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libgl1-mesa-dev libgles2-mesa-dev libglu1-mesa-dev libdbus-1-3 \
                                               libxext-dev libegl1-mesa-dev libglib2.0-0 mesa-utils-extra \
                                               libpulse0 libpulse-mainloop-glib0 && \
    rm -rf /var/lib/apt/lists/*
ENV QTDIR=/prj/omnicast/tools/Qt5.12.3/gcc_64
ENV LD_LIBRARY_PATH=$QTDIR/lib:${LD_LIBRARY_PATH} \
    QT_PLUGIN_PATH=$QTDIR/plugins \
    QT_QPA_PLATFORM_PLUGIN_PATH=$QTDIR/plugins/platforms \
    QML2_IMPORT_PATH=$QTDIR/qml

# NVIDIA GPU support
# for testing xeyes/glxgears and xrandr
RUN apt-get update && \
    apt-get install -y --no-install-recommends x11-apps mesa-utils x11-xserver-utils && \
    rm -rf /var/lib/apt/lists/*

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# debug dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gdb valgrind && \
    rm -rf /var/lib/apt/lists/*

# static analysis tools
# - clang-tidy 3.7 needed for misc-assert-side-effect
RUN apt-get update && \
    apt-get install -y --no-install-recommends clang-tidy-3.7 && \
    rm -rf /var/lib/apt/lists/*

# GNU parallel
RUN echo 'deb http://ppa.launchpad.net/jonathonf/backports/ubuntu xenial main' > /etc/apt/sources.list.d/parallel.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F06FC659 && \
    apt-get update && \
    apt-get install -y --no-install-recommends parallel && \
    rm -rf /var/lib/apt/lists/*

# android dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 file && \
    rm -rf /var/lib/apt/lists/*

# set locale (hexagon dependency)
RUN apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# handy script helpers
RUN apt-get update && \
    apt-get install -y --no-install-recommends rpl xmlstarlet && \
    rm -rf /var/lib/apt/lists/*

# doxygen and graphviz
RUN apt-get update && \
    apt-get install -y --no-install-recommends doxygen graphviz && \
    rm -rf /var/lib/apt/lists/*
