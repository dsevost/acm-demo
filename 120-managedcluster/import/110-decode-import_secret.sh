#!/bin/bash

set -e

NS=${MANAGED_CLUSTERNAME:-"acm-mont-main"}

GEN_DIR="mgmt"

CLUSTER_NAME=$NS

[ -d "$GEN_DIR" ] || mkdir -p $GEN_DIR

oc -n ${NS} get secret ${CLUSTER_NAME}-import \
    -o jsonpath='{.data.crds\.yaml}' | base64 -d \
    > $GEN_DIR/klusterlet-crd-${CLUSTER_NAME}.yaml

oc -n ${NS} get secret ${CLUSTER_NAME}-import \
    -o jsonpath='{.data.import\.yaml}' | base64 -d \
    > $GEN_DIR/import-${CLUSTER_NAME}.yaml
