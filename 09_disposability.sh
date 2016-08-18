#!/bin/bash
echo "Destroying two processes"
oc delete pod `oc get pods -l app=my12factorapp --no-headers=true| grep my12factorapp -m 2| awk '{ print $1 }'`
while true; do curl http://12factorappdemo.10.1.2.2.nip.io/api/hello/Rafael ; echo; sleep 1; done