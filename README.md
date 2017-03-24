# Helloworld

The slides of this presentation are available at <http://bit.ly/12factors-app>

To use the scripts, specify the OPENSHIFT_IP environment variable.

Example: export OPENSHIFT_IP=35.185.41.87;

Build and Deploy helloworld-service locally
------------------------------------------

1. Open a command prompt and navigate to the root directory of this microservice.
2. Type this command to build and execute the service:

        mvn clean compile exec:java

3. The application will be running at the following URL: <http://localhost:8080/api/hello/AnyName>