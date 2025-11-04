stage('Deploy') {
    steps {
        script {
            // stop & remove old container if it exists
            sh 'docker ps -q --filter "name=devops-demo-container" | grep -q . && docker stop devops-demo-container || true'
            sh 'docker ps -a -q --filter "name=devops-demo-container" | grep -q . && docker rm devops-demo-container || true'

            // run new container mapping EC2 port 8080 to container 8080
            sh 'docker run -d -p 8080:8080 --name devops-demo-container devops-demo-app'
        }
    }
}
