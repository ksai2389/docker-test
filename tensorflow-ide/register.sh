#!/bin/bash

set -x

REGISTRY_HOST=docker-registry.qualcomm.com
ORG=$USER
NAME=tensorflow
TAG=ide

PYCHARMURL=https://download.jetbrains.com/python/pycharm-community-2016.3.tar.gz
rm -r pycharm
wget -c -O pycharm.tar.gz ${PYCHARMURL}
tar xf pycharm.tar.gz
mv pycharm-community* pycharm
find pycharm -perm 640 -exec chmod 644 {} \;
find pycharm -perm 750 -exec chmod 755 {} \;

docker build -t ${NAME}-${TAG} .
docker tag ${NAME}-${TAG} ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
docker push ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
