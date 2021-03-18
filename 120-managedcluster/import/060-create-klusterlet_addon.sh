#!/bin/bash

set -e

NS=${MANAGED_CLUSTERNAME:-"acm-mont-main"}

KLUSTERLET_VERSION="2.2.0"

ENABLE_ALL_COMPONENTS=${ENABLE_ALL_COMPONENTS:-"true"}
ENABLE_IAMPC=${ENABLE_IAMPC:-$ENABLE_ALL_COMPONENTS}
ENABLE_PC=${ENABLE_PC:-$ENABLE_ALL_COMPONENTS}
ENABLE_SC=${ENABLE_SC:-$ENABLE_ALL_COMPONENTS}

cat << EOF | oc --as system:admin apply -f -
apiVersion: agent.open-cluster-management.io/v1
kind: KlusterletAddonConfig
metadata:
  name: $NS
  namespace: $NS
spec:
  clusterName: $NS
  clusterNamespace: $NS
  applicationManager:
    enabled: true
  certPolicyController:
    enabled: true
  clusterLabels:
    cloud: auto-detect
    vendor: auto-detect
  iamPolicyController:
    enabled: $ENABLE_IAMPC
  policyController:
    enabled: $ENABLE_PC
  searchCollector:
    enabled: $ENABLE_SC
  version: $KLUSTERLET_VERSION
EOF
