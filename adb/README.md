# Docker adb image
Image is built on top of [Ubuntu Xenial image from Canonical](https://hub.docker.com/_/ubuntu/),
adding crad-docker and sudo support

## Usage instructions
Add adb.conf to your *~/.crad-docker.conf.d* folder

    crad-docker adb -- adb shell

## Modification instructions

    vim Dockerfile
    ./register.sh # you'll need an account on docker-registry, see below

### References
See [Docker](https://confluence.qualcomm.com/confluence/display/AT/Docker)
and [Workflow](https://confluence.qualcomm.com/confluence/display/AT/Workflow)
for more info on Docker and crad-docker.

Visit [docker-registry](https://docker-registry.qualcomm.com) to browse docker images, make an account, etc.
