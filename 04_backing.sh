#!/bin/bash
echo "Deploying a database"
oc new-app --name mysql -e MYSQL_USER=myuser -e MYSQL_PASSWORD=mypassword -e MYSQL_DATABASE=mydatabase openshift/mysql-56-centos7 
echo "Attach it to the app"
oc env dc/my12factorapp host=mysql username=myuser password=mypassword database=mydatabase GREETING-
echo "Open the URL: http://12factorappdemo.10.1.2.2.nip.io/api/db"
