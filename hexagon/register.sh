#!/bin/bash

echo "carefully comment out this line" && exit 1

set -x

cd $(readlink -f .)

# grab HEXAGON SDK installer for insertion into image
HEXAGONSDK=/prj/adsp-platform/sdk/3.1_candidate/latest/Linux/qualcomm_hexagon_sdk_3_1_eval.bin
cp -a ${HEXAGONSDK} qualcomm_hexagon_sdk.bin

REGISTRY_HOST=docker-registry.qualcomm.com
ORG=omnicast
NAME=hexagon
TAG=latest

docker build -t ${NAME}:${TAG} .
docker tag ${NAME}:${TAG} ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
docker push ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
