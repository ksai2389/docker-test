FROM docker-registry.qualcomm.com/library/ubuntu:20.04

# curl unzip
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl unzip && \
    rm -rf /var/lib/apt/lists/*

# JRE 11
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-11-jre && \
    rm -rf /var/lib/apt/lists/*
ENV JRE_HOME=/usr/lib/jvm/java-11-openjdk-amd64
