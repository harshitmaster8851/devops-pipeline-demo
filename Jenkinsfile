// Jenkinsfile (Declarative - place at repo root)
pipeline {
  agent any

  environment {
    IMAGE_NAME = "devops-demo-app"
    CONTAINER_NAME = "devops-demo-container"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM',
          branches: [[name: '*/main']],
          userRemoteConfigs: [[url: 'https://github.com/harshitmaster8851/devops-pipeline-demo.git']]])
      }
    }

    stage('Build Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Deploy') {
      steps {
        script {
          // stop & remove existing container if present (safe)
          sh 'docker ps -q --filter "name=$CONTAINER_NAME" | grep -q . && docker stop $CONTAINER_NAME || true'
          sh 'docker ps -a -q --filter "name=$CONTAINER_NAME" | grep -q . && docker rm $CONTAINER_NAME || true'
          // run new container mapping host 8080->container 8080
          sh 'docker run -d -p 8080:8080 --name $CONTAINER_NAME $IMAGE_NAME'
        }
      }
    }
  }

  post {
    success { echo '✅ Build and Deployment successful!' }
    failure { echo '❌ Build failed. Check logs.' }
  }
}
