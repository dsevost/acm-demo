#!/bin/bash

#
# The scriptset to finf and remove stucked resources
# https://access.redhat.com/solutions/5550931
#

set -e

NS=$1

[ -z "$NS" ] && exit 1

oc get ns $NS -o jsonpath='{ .status.phase }' | grep -q 'Terminating' || exit 1 && { echo "NS $NS is in Terminating phase, continuing..." >&2 ; }

RR=$(\
    oc get ns $NS -o jsonpath='{.status.conditions[?(@.type == "NamespaceContentRemaining")].message } {"\n"}' | \
	sed 's/^[^:]\+: // ; s/has [0-9]\+ resource instances//g ; s/[, ]\+/,/g ; s/,$//'
)

echo "Remaing resources are: $RR" >&2

CMD=$(oc -n $NS get $RR -o custom-columns=':.kind,:.metadata.name' --no-headers | \
    sed 's|\W\+|/|' | xargs echo "oc -n $NS patch -p '{\"metadata\":{\"finalizers\":[]}}' --type=merge")

echo "CAREFULLY CHECK and run manually following command: " >&2
echo $CMD