#!/bin/bash
echo "Openning a new bash process in the exising application container"
oc rsh `oc get pods -l app=my12factorapp --no-headers=true|grep my12factorapp -m 1|awk '{print $1}'`
