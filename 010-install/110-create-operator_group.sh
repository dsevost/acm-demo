#!/bin/bash

set -e

NS=${ACM_HUB_NS:-"open-cluster-management"}

ACM_OPERATOR_GROUP=${ACM_OPERATOR_GROUP:-"open-cluster-management"}

og_exists=$(oc get operatorgroups --no-headers -o jsonpath='{ .items[*].metadata.name }')

[ -z "$og_exists" ] || exit 1

cat << EOF | oc --as system:admin create -f -
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: $ACM_OPERATOR_GROUP
  namespace: $NS
spec:
  targetNamespaces:
  - $NS
EOF
