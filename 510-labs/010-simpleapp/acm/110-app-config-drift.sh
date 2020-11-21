#!/bin/bash

oc -n acm-simple-app describe deploy httpd

read -p "Hit 'Enter' to continue... "

oc -n acm-simple-app get deploy httpd

echo
echo

oc -n acm-simple-app scale deploy httpd --replicas=3

echo
echo

for i in $(seq 0 99) ; do
    oc -n acm-simple-app get deploy httpd
    sleep 1
done
