#!/bin/bash

set -e

NS=${MANAGED_CLUSTERNAME:-"acm-mont-main"}

oc get ns -o jsonpath="{ .items[?(@.metadata.name == '$NS')].metadata.name }"
    oc adm new-project $NS > /dev/null

oc label namespace ${NS} cluster.open-cluster-management.io/managedCluster=${NS} acm=managed-cluster
#oc label namespace ${NS} acm=managed-cluster
