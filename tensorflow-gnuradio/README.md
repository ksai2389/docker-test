# Docker tensorflow/gnuradio image
Image is built on top of [Google's Tensorflow GPU image](https://hub.docker.com/r/tensorflow/tensorflow/),
adding crad-docker and sudo support, and GNU Radio

## Usage instructions
Add tensorflow-gnuradio.conf to your *~/.crad-docker.conf.d* folder

    crad-docker tensorflow-gnuradio -- /run_jupyter.sh --ip='*'

## Modification instructions

    vim Dockerfile
    ./register.sh # you'll need an account on docker-registry, see below

### References
See [Docker](https://confluence.qualcomm.com/confluence/display/AT/Docker)
and [Workflow](https://confluence.qualcomm.com/confluence/display/AT/Workflow)
for more info on Docker and crad-docker.

In addition to docker and crad-docker, you will need to install nvidia-docker.
See [nvidia blog](https://devblogs.nvidia.com/parallelforall/nvidia-docker-gpu-server-application-deployment-made-easy/) for more info
and [QC github](https://github.qualcomm.com/bardia/nvidia-docker/releases) to download QC-friendly Ubuntu releases.

Visit [docker-registry](https://docker-registry.qualcomm.com) to browse docker images, make an account, etc.
