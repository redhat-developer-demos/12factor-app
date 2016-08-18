#!/bin/bash
oc scale dc/my12factorapp --replicas=1
oc patch svc/mysql -p '{"spec":{"ports":[{"name": "5000-tcp", "port": 5000, "targetPort": 3306}]}}'
oc env dc/my12factorapp port=5000
open http://12factorappdemo.10.1.2.2.nip.io/api/db
echo "Database port 3306 was bound to port 5000"