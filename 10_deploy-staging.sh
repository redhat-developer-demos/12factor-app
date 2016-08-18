#!/bin/bash
echo "Deploying to the staging area"
oc new-project 12factor-staging
oc policy add-role-to-user system:image-puller system:serviceaccount:12factor-staging:default -n 12fatorsdemo
oc tag 12fatorsdemo/my12factorapp:latest 12factor-staging/my12factorapp:latest
oc new-app my12factorapp
oc expose svc/my12factorapp --hostname 12factor-staging.10.1.2.2.nip.io
oc set probe dc/my12factorapp --readiness --get-url=http://:8080/api/health
open http://12factor-staging.10.1.2.2.nip.io/api/hello/Rafael
oc project 12fatorsdemo

