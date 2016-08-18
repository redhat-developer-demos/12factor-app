#!/bin/bash
oc scale dc/my12factorapp --replicas=3
oc scale dc/my12factorapp --replicas=3
echo "App Scaled to three instances"
while true; do curl -m 1 http://12factorappdemo.10.1.2.2.nip.io/api/hello/Rafael ; echo; sleep 1; done