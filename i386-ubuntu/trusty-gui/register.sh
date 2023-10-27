#!/bin/bash

set -x

REGISTRY_HOST=docker-registry.qualcomm.com
ORG=$USER
NAME=ubuntu
TAG=trusty-32bit-gui

docker build -t ${NAME}-${TAG} .
docker tag ${NAME}-${TAG} ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
docker push ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
