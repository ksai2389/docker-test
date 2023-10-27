FROM docker-registry.qualcomm.com/library/ubuntu:22.04

# crad-docker assumes python is installed in image
# crad-docker 2.X user.py bootstrap script looks for /usr/bin/env python
# crad-docker 1.X user.py bootstrap script looks for /usr/bin/env python2
# our own python scripts look for /usr/bin/env python3
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python-is-python3 && \
    rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/python2 python2 /usr/bin/python3.10 10

# grant sudo capability to "users" group
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/*
RUN echo "%users ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends make ninja-build clang-14 clang++-14 llvm-14 clang-tidy-14 clang-format-14 libc++-14-dev libc++abi-14-dev libbsd-dev && \
    rm -rf /var/lib/apt/lists/*

# configure default compiler (similar to precise/trusty) to help cmake auto discover compiler
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang-14 10 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-14 10

# add clang symlinks to help qtcreator auto discover compiler
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-14 10 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-14 10

# newer cmake
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*
RUN cd /tmp && \
    wget -q https://cmake.org/files/v3.25/cmake-3.25.1-linux-x86_64.sh && \
    chmod +x cmake*.sh && \
    ./cmake*.sh --skip-license --prefix=/usr/local/ && \
    rm cmake*.sh

# install Qt (in /prj/xrresearch) dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libgl1-mesa-dev libgles2-mesa-dev libglu1-mesa-dev libdbus-1-3 \
                                               libxext-dev libegl1-mesa-dev libglib2.0-0 mesa-utils-extra \
                                               libpulse0 libpulse-mainloop-glib0 libxkbcommon-x11-0 \
                                               libgssapi-krb5-2 && \
    rm -rf /var/lib/apt/lists/*
ENV QTDIR=/prj/xrresearch/tools/Qt5.15.1/gcc_64
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
    apt-get install -y --no-install-recommends gdb valgrind unzip && \
    rm -rf /var/lib/apt/lists/*
RUN cd /tmp && \
    wget -q https://github.com/danmar/cppcheck/archive/refs/tags/2.9.zip && \
    unzip 2.9.zip && \
    cd cppcheck-2.9 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf 2.9.zip cppcheck-2.9

# GNU parallel
RUN apt-get update && \
    apt-get install -y --no-install-recommends parallel && \
    rm -rf /var/lib/apt/lists/*

# android dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libc6-i386 lib32stdc++6 lib32gcc-s1 lib32ncurses6 lib32z1 file && \
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
    apt-get install -y --no-install-recommends rpl xmlstarlet rename && \
    rm -rf /var/lib/apt/lists/*

# doxygen and graphviz
RUN apt-get update && \
    apt-get install -y --no-install-recommends doxygen graphviz && \
    rm -rf /var/lib/apt/lists/*

# perl module for VP Sim
RUN apt-get update && \
    apt-get install -y --no-install-recommends libfile-finder-perl && \
    rm -rf /var/lib/apt/lists/*

# explore compile time improvements
RUN apt-get update && \
    apt-get install -y --no-install-recommends distcc-pump ccache && \
    rm -rf /var/lib/apt/lists/*
