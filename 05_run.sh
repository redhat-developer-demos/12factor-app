#!/bin/bash
oc new-app my12factorapp
oc expose svc/my12factorapp --hostname 12factorappdemo.10.1.2.2.nip.io
oc set probe dc/my12factorapp --readiness --get-url=http://:8080/api/health
echo "Application executed. Check the URL: http://12factorappdemo.10.1.2.2.nip.io/api/hello/Rafael"