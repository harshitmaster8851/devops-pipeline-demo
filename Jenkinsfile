pipeline {
  agent any

  environment {
    DOCKER_CREDS = credentials('dockerhub-creds')   // Jenkins credentials id
    SSH_CRED_ID = 'ec2-ssh'                         // Jenkins SSH credential id
    DOCKERHUB_USER = "98.81.210.75"        // replace
    IMAGE = "${DOCKERHUB_USER}/tooplate-website"
    TAG = "${env.BUILD_NUMBER ?: 'latest'}"
    EC2_HOST = "ubuntu@98.81.210.75"             // replace
    CONTAINER_NAME = "tooplate-site"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Image') {
      steps {
        sh 'docker build -t $IMAGE:$TAG .'
      }
    }

    stage('Push Image') {
      steps {
        sh '''
          echo "$DOCKER_CREDS_PSW" | docker login -u "$DOCKER_CREDS_USR" --password-stdin
          docker push $IMAGE:$TAG
        '''
      }
    }

    stage('Deploy to EC2') {
      steps {
        sshagent (credentials: [env.SSH_CRED_ID]) {
          sh '''
            ssh -o StrictHostKeyChecking=no ${EC2_HOST} "bash -s" <<'REMOTE'
# Stop and remove existing container
sudo docker stop ${CONTAINER_NAME} || true
sudo docker rm ${CONTAINER_NAME} || true

# Pull latest image
sudo docker pull ${IMAGE}:${TAG} || true

# Run container bound to localhost for security (host 127.0.0.1:8081 -> container 8080)
sudo docker run -d --name ${CONTAINER_NAME} --restart=always -p 127.0.0.1:8081:8080 ${IMAGE}:${TAG}

# Ensure host Nginx config proxies 127.0.0.1:8081 (we'll check below)
sudo systemctl restart nginx || true

echo "Deployed ${IMAGE}:${TAG}"
REMOTE
          '''
        }
      }
    }
  }

  post {
    success { echo "✅ Deploy finished: http://${EC2_HOST.split('@')[-1]}/" }
    failure { echo "❌ Pipeline failed — check logs" }
  }
}
