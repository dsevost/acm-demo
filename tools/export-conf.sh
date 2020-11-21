#!/bin/bash

#set -xe

dir=$(realpath -e $(dirname $BASH_SOURCE))

for p in . .. ../.. ../../.. ; do
    [ -d $dir/$p/.git ] && { export KUBECONFIG=$dir/$p/kubeconfig-hub ; touch $KUBECONFIG ; return ; }
done

echo "KUBECONFIG must reside current Git repo"

return
