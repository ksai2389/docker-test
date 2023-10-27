#!/bin/bash

# chdir to prevent apt-get root-squash errors
cd /tmp

# verbose
set -x
# exit immediately on any error
set -e

function docker_setup () {

# this variable is sometimes set by the GUI login manager
# causing post-install 'start' and 'stop' commands to fail
# so we unset it here
unset UPSTART_SESSION

# install docker
# latest instructions at:
# https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository
sudo apt-get update

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -sc) stable" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo dpkg -P docker-engine
sudo apt-get install -y docker-ce docker-compose-plugin

# stop docker if it is running
# sleep first so post-install 'start' completes
sleep 10
which systemd || sudo stop docker
which systemd && sudo systemctl stop docker

# change default docker group to 'users'
which systemd || echo 'DOCKER_OPTS="--bip=169.254.0.1/17 --group=200"'| sudo tee --append /etc/default/docker 1>/dev/null
which systemd && [ ! -d /etc/systemd/system/docker.service.d ] && sudo mkdir -p /etc/systemd/system/docker.service.d
which systemd && echo -e '[Service]\nExecStart=\nExecStart=/usr/bin/dockerd --bip=169.254.0.1/17 --group=200' | sudo tee /etc/systemd/system/docker.service.d/override.conf 1>/dev/null

# relocate docker 'home'
[ ! -h /var/lib/docker ] && sudo mv /var/lib/docker /local/mnt/
[ ! -h /var/lib/docker ] && sudo ln -sf /local/mnt/docker /var/lib/
sudo mkdir -p /local/mnt/docker

# start docker
which systemd || sudo start docker
which systemd && sudo systemctl daemon-reload
which systemd && sudo systemctl start docker

}

docker_setup
