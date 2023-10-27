#!/bin/bash

set -x

REGISTRY_HOST=docker-registry.qualcomm.com
ORG=bardia
NAME=vnc
TAGS="base xdu"

# ensure make is run
make

for TAG in $TAGS; do
    echo $TAG
    docker tag ${NAME}:${TAG} ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
    docker push ${REGISTRY_HOST}/${ORG}/${NAME}:${TAG}
done
