# Docker image for Hexagon SDK
Image is built on top of [Ubuntu Xenial image from Canonical](https://hub.docker.com/_/ubuntu/),
adding crad-docker and sudo support, and additional packages needed to build Hexagon examples

## Usage instructions
For crad-docker, add hexagon.conf to your *~/.crad-docker.conf.d* folder

    crad-docker hexagon
    cd /Qualcomm/Hexagon_SDK/3.1/examples/common/downscaleBy2
    sudo -E make tree V=android_Release VERBOSE=1
    sudo -E make tree V=hexagon_ReleaseG_toolv80_v60 VERBOSE=1
    sudo -E make tree V=hexagon_ReleaseG_dynamic_toolv80_v60 VERBOSE=1

Without crad-docker, directly using docker run

    docker pull docker-registry.qualcomm.com/omnicast/hexagon
    docker run --rm --privileged -it docker-registry.qualcomm.com/omnicast/hexagon
    cd /Qualcomm/Hexagon_SDK/3.1/examples/common/downscaleBy2
    make tree V=android_Release VERBOSE=1
    make tree V=hexagon_ReleaseG_toolv80_v60 VERBOSE=1
    make tree V=hexagon_ReleaseG_dynamic_toolv80_v60 VERBOSE=1
    
## Modification instructions

    vim Dockerfile
    ./register.sh # you'll need an account on docker-registry, see below

### References
See [Docker](https://confluence.qualcomm.com/confluence/display/AT/Docker)
and [Workflow](https://confluence.qualcomm.com/confluence/display/AT/Workflow)
for more info on Docker and crad-docker.

Visit [docker-registry](https://docker-registry.qualcomm.com) to browse docker images, make an account, etc.
