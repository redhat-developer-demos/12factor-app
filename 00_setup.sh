#!/bin/bash
oc login --insecure-skip-tls-verify=true -u openshift-dev -p devel
oc new-project 12fatorsdemo
oc new-build --binary --name=my12factorapp
echo "Project setup"