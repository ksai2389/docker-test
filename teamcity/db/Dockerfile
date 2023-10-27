FROM mysql:5

# crad-docker assumes python is installed in image
RUN apt-get update && \
    apt-get install -y --no-install-recommends python && \
    rm -rf /var/lib/apt/lists/*
