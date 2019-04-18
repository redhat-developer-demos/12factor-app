podTemplate(
    inheritFrom: "maven", 
    label: "myJenkins", 
    cloud: "openshift", 
    volumes: [
        persistentVolumeClaim(claimName: "m2repo", mountPath: "/home/jenkins/.m2/")
    ]) {

    node("myJenkins") {
    
        stage("Git Checkout") {
            echo "Checking out git repository"
            checkout scm
        }

        stage("Build") {
            echo 'Building project'
            sh "mvn package"
        }

        stage("DEV - Image Release") {
            echo 'Building docker image and deploying to Dev'
            sh "oc new-project 12factor-dev || echo 'Project exists'"
            sh "oc policy add-role-to-user admin developer -n 12factor-dev"
            sh "oc project 12factor-dev"
            sh "oc new-build -n 12factor-dev --binary --name=my12factorapp || echo 'Build exists'"
            sh "oc start-build my12factorapp -n 12factor-dev --from-dir=. --follow"
        }
        
        stage ("DEV - App RUN"){
            sh "oc new-app my12factorapp -n 12factor-dev  || echo 'Aplication already Exists'"
            sh "oc expose service my12factorapp -n 12factor-dev || echo 'Service already exposed'"
            sh "oc set probe dc/my12factorapp -n 12factor-dev --readiness --get-url=http://:8080/api/health"
        }

        stage("Automated tests") {
            echo 'This stage simulates automated tests'
            sh "mvn -B -Dmaven.test.failure.ignore verify"
        }

        stage("QA - App RUN") {
            echo 'Deploying to QA'
            sh "oc new-project 12factor-staging || echo 'Project exists'"
            sh "oc policy add-role-to-user admin developer -n 12factor-staging"
            sh "oc project 12factor-staging"
            sh "oc policy add-role-to-user system:image-puller system:serviceaccount:12factor-staging:default -n 12factor-dev"
            sh "oc tag 12factor-dev/my12factorapp:latest 12factor-staging/my12factorapp:latest"
            sh "oc new-app my12factorapp -n 12factor-staging  || echo 'Aplication already Exists'"
            sh "oc expose service my12factorapp -n 12factor-staging || echo 'Service already exposed'"
            sh "oc set probe dc/my12factorapp -n 12factor-staging  --readiness --get-url=http://:8080/api/health"
        }

        stage("Approve to PROD") {
            input 'Approve to production?'
        }

        stage("PROD - App RUN") {
            echo 'Deploying to production'
            sh "oc new-project 12factor || echo 'Project exists'"
            sh "oc policy add-role-to-user admin developer -n 12factor"
            sh "oc project 12factor"
            sh "oc policy add-role-to-user system:image-puller system:serviceaccount:12factor:default -n 12factor-staging"
            sh "oc tag 12factor-staging/my12factorapp:latest 12factor/my12factorapp:latest"
            sh "oc new-app -n 12factor --name my12factorapp my12factorapp || echo 'Aplication already Exists'" 
            sh "oc expose service my12factorapp -n 12factor || echo 'Service already exposed'"
            sh "oc set probe dc/my12factorapp -n 12factor  --readiness --get-url=http://:8080/api/health"
        }

    }
}    
