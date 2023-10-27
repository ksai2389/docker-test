# Docker images for running apps alongside vnc server
Image is built on top of [Ubuntu LTS Xenial image from Canonical](https://hub.docker.com/_/ubuntu/),
adding crad-docker and sudo support, and additional packages needed for vnc-based services

## Usage instructions
Add vnc.conf to your *~/.crad-docker.conf.d* folder

    crad-docker -c vnc.conf vncbase
    vncserver :0

## Modification instructions

    vim {base,xdu}/Dockerfile
    ./register.sh # pushes images to registry, you'll need an account on docker-registry, see below

### References
See [Docker](https://confluence.qualcomm.com/confluence/display/OMNI/Docker)
for more info on Docker and crad-docker.

Visit [docker-registry](https://docker-registry.qualcomm.com) to browse docker images, make an account, etc.
