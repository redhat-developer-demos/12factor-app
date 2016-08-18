#!/bin/bash
# JBoss, Home of Professional Open Source
# Copyright 2016, Red Hat, Inc. and/or its affiliates, and individual
# contributors by the @authors tag. See the copyright.txt in the 
# distribution for a full listing of individual contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,  
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
echo "Deploying to the staging area"
oc new-project 12factor-staging
oc policy add-role-to-user system:image-puller system:serviceaccount:12factor-staging:default -n 12fatorsdemo
oc tag 12fatorsdemo/my12factorapp:latest 12factor-staging/my12factorapp:latest
oc new-app my12factorapp
oc expose svc/my12factorapp --hostname 12factor-staging.10.1.2.2.nip.io
oc set probe dc/my12factorapp --readiness --get-url=http://:8080/api/health
open http://12factor-staging.10.1.2.2.nip.io/api/hello/Rafael
oc project 12fatorsdemo

