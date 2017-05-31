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
oc login --insecure-skip-tls-verify=true -u developer -p developer https://$OPENSHIFT_IP:8443
oc new-project 12factor-dev
oc new-build --binary --name=my12factorapp
oc new-project ci
oc create -f pipeline.yml -n ci
#Setup Jenkins credentials
oc login -u system:admin
echo "Giving Jenkins SA a cluster-admin permission"
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:ci:jenkins -n ci
oc login --insecure-skip-tls-verify=true -u developer -p developer https://$OPENSHIFT_IP:8443
echo "Project setup"
oc project 12factor-dev
