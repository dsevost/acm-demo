#!/bin/bash

set -e

NS=${ACM_HUB_NS:-"open-cluster-management"}

ACM_CA_NAME=${ACM_CA_NAME:-"custom-ca"}

[ -r "$1" ] || { echo "Custom CA bundle not specified, aborting."; exit 1; }

oc -n $NS \
    create cm ${ACM_CA_NAME} \
     --from-file=ca-bundle.crt=$1
