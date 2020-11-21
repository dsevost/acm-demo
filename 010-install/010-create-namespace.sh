#!/bin/bash

set -e

NS=${ACM_HUB_NS:-"open-cluster-management"}

oc get ns -o jsonpath="{ .items[?(@.metadata.name == '$NS')].metadata.name }"
    oc adm new-project $NS

oc label namespace ${NS} acm=operator
