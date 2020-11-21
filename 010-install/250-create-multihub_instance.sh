#!/bin/bash

set -e

NS=${ACM_HUB_NS:-"open-cluster-management"}

ACM_MCH_NAME=${ACM_MCH_NAME:-"multiclusterhub"}
IMAGE_PULL_SECRET=${IMAGE_PULL_SECRET:-"ocp-pull-secret"}
ACM_CA_CM=${ACM_CA_CM:-"custom-ca"}

json_filter="{ .items[?(@.metadata.name == '$ACM_MCH_NAME')].metadata.name }"
mch_exists=$(oc -n $NS get mch --no-headers -o jsonpath="$json_filter")

[ -z "$mch_exists" ] || exit 1

oc -n $NS get cm $ACM_CA_CM -o jsonpath='{ .metadata.name } {"\n"}' | grep $ACM_CA_CM || { exit 1 ; } && { echo " CM presents" ; }
oc -n $NS get secret $IMAGE_PULL_SECRET -o jsonpath='{ .metadata.name } {"\n"}' | grep $IMAGE_PULL_SECRET || { exit 1 ; } && { echo " secret presents" ; }


cat << EOF | oc -n $NS create -f -
---
apiVersion: operator.open-cluster-management.io/v1
kind: MultiClusterHub
metadata:
  name: $ACM_MCH_NAME
  namespace: $NS
spec:
$([ -z "$IMAGE_PULL_SECRET" -a -z "$ACM_CA_CM" ] && echo " {}")
$([ -z "$IMAGE_PULL_SECRET" ] || echo "  imagePullSecret: $IMAGE_PULL_SECRET")
$([ -z "$ACM_CA_CM" ] || echo "  customCAConfigmap: $ACM_CA_CM")
EOF

echo -n 'Installing '
for i in $(seq 1 100) ; do 
    oc -n $NS get mch $ACM_MCH_NAME -o jsonpath='{ .status.phase } {"\n"}' | grep 'Running' && break
    echo -n '.'
    sleep 10
done
