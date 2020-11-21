#!/bin/bash

set -e

NS=${ACM_HUB_NS:-"open-cluster-management"}

ACM_CHANNEL=${ACM_CHANNEL:-"release-2.1"}
ACM_APPROVAL=${ACM_APPROVAL:-"Manual"}
ACM_SUBS_LOCAL_NAME=${ACM_SUBS_LOCAL_NAME:-"acm-demo"}

ACM_SUBS_ACTIVATION_COUNT=10
ACM_SUBS_ACTIVATION_WAIT=30

json_filter="{ .items[?(@.metadata.name == '$ACM_SUBS_LOCAL_NAME')].metadata.name }"
subs_exists=$(oc get subs --no-headers -o jsonpath="$json_filter")

[ -z "$subs_exists" ] || exit 1

cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: $ACM_SUBS_LOCAL_NAME
  namespace: $NS
spec:
  sourceNamespace: openshift-marketplace
  source: redhat-operators
  channel: $ACM_CHANNEL
  installPlanApproval: $ACM_APPROVAL
  name: advanced-cluster-management
EOF

echo -n "Wait for subscription activation "
for i in $(seq 1 $ACM_SUBS_ACTIVATION_COUNT) ; do
    oc -n $NS get csv -o jsonpath="{ .items[?(@.metadata.name contains '$ACM_SUBS_LOCAL_NAME')].status.phase }" | grep 'Succeeded' && break
    echo -n "."
    sleep $ACM_SUBS_ACTIVATION_WAIT
done

if [ "$i" = "$ACM_SUBS_ACTIVATION_COUNT" ] ; then
    echo "Subscription status sill not 'Succeeded', aborting."
    exit 1
fi
