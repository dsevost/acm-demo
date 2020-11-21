#!/bin/bash

set -e

NS=${ACM_HUB_NS:-"open-cluster-management"}
IMAGE_PULL_SECRET=${IMAGE_PULL_SECRET:-"ocp-pull-secret"}

IMAGE_PULL_SECRET_FILE=$1

[ -r "$IMAGE_PULL_SECRET_FILE" ] || { echo "Pull secret not specified, aborting."; exit 1; }

oc create secret generic $IMAGE_PULL_SECRET \
    -n $NS \
    --type=kubernetes.io/dockerconfigjson \
    --from-file=.dockerconfigjson=$IMAGE_PULL_SECRET_FILE
