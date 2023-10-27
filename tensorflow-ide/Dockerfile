FROM tensorflow/tensorflow:0.11.0-gpu

# crad-docker assumes python is installed in image
RUN apt-get update && \
    apt-get install -y --no-install-recommends python && \
    rm -rf /var/lib/apt/lists/*

# grant sudo capability to "users" group
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/*
RUN echo "%users ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# install pycharm
ADD pycharm /pycharm

# install pycharm dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libxi6 libxtst6 libxrender1 libxext6 libx11-6 libfontconfig1 && \
    rm -rf /var/lib/apt/lists/*
