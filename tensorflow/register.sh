#!/bin/bash

set -x

REGISTRY_HOST=docker-registry.qualcomm.com
ORG=$USER
NAME=tensorflow
TAG=latest

docker build -t ${NAME}-${TAG} .
docker tag ${NAME}-${TAG} ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
docker push ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
