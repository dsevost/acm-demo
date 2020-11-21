#!/bin/bash

set -e

NS=${MANAGED_CLUSTERNAME:-"acm-mont-main"}

cat << EOF | oc --as system:admin apply -f -
apiVersion: cluster.open-cluster-management.io/v1
kind: ManagedCluster
metadata:
  name: $NS
  labels:
    cloud: auto-detect
    vendor: auto-detect
spec:
  hubAcceptsClient: true
EOF
