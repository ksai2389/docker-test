FROM tensorflow/tensorflow:latest-devel-gpu

# crad-docker assumes python is installed in image
RUN apt-get update && \
    apt-get install -y --no-install-recommends python && \
    rm -rf /var/lib/apt/lists/*

# grant sudo capability to "users" group
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/*
RUN echo "%users ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# install other dependencies
#RUN apt-get update && \
#    apt-get install -y --no-install-recommends foo bar pip && \
#    rm -rf /var/lib/apt/lists/*
