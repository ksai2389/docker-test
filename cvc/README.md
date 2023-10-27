# Docker images for building Omnicast CVC tree
Image is built on top of [Ubuntu LTS images from Canonical](https://hub.docker.com/_/ubuntu/),
adding crad-docker and sudo support, and additional packages needed to build CVC tree

## Usage instructions
Add cvc.conf to your *~/.crad-docker.conf.d* folder

    crad-docker cvc -- cmake ../CVC
    crad-docker cvc -- make -j $(nproc) install
    crad-docker cvc -- ctest -j $(nproc)

## Modification instructions

    vim 1[246].04/Dockerfile
    make # performs docker build on all images
    ./register.sh # pushes images to registry, you'll need an account on docker-registry, see below

### References
See [Docker](https://confluence.qualcomm.com/confluence/display/AT/Docker)
and [Workflow](https://confluence.qualcomm.com/confluence/display/AT/Workflow)
for more info on Docker and crad-docker.

Visit [docker-registry](https://docker-registry.qualcomm.com) to browse docker images, make an account, etc.
