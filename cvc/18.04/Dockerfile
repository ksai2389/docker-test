FROM docker-registry.qualcomm.com/library/ubuntu:18.04

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
    apt-get install -y --no-install-recommends make ninja-build clang-9 clang++-9 llvm-9 clang-tidy-9 clang-format-9 libc++-dev libc++abi-dev libbsd-dev && \
    rm -rf /var/lib/apt/lists/*

# configure default compiler (similar to precise/trusty) to help cmake auto discover compiler
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang-9 10 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-9 10

# add clang symlinks to help qtcreator auto discover compiler
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 10 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-9 10

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
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all

# debug dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gdb unzip patchelf libc6-dbg && \
    rm -rf /var/lib/apt/lists/*
RUN cd /tmp && \
    wget -q https://sourceware.org/pub/valgrind/valgrind-3.20.0.tar.bz2 && \
    tar xvf valgrind-3.20.0.tar.bz2 && \
    cd valgrind-3.20.0 && \
    ./configure --prefix=/usr/ && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf valgrind-3.20.0.tar.bz2 valgrind-3.20.0
ENV VALGRIND_LIB=/usr/libexec/valgrind

RUN cd /tmp && \
    wget -q https://github.com/danmar/cppcheck/archive/refs/tags/2.10.zip && \
    unzip 2.10.zip && \
    cd cppcheck-2.10 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf 2.10.zip cppcheck-2.10

# GNU parallel
RUN apt-get update && \
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

# symlink ftw
ADD libstdc++.so.6.0.28 /usr/lib/x86_64-linux-gnu
RUN chmod +x /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.28 && \
    ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.28 /usr/lib/x86_64-linux-gnu/libstdc++.so.6
