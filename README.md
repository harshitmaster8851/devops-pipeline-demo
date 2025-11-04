# 🚑 CI/CD Pipeline for a Web Application — DevOps Project

---

### 📋 **Project Summary**

• Designed and implemented an automated **CI/CD pipeline** using **Jenkins**, **Docker**, **Nginx**, and **AWS EC2**.  
• Integrated **Git-based automation** to trigger builds and deployments seamlessly on every code push.  
• Configured **Nginx as a reverse proxy** to serve containerized web applications efficiently.  
• Streamlined deployment workflows, ensuring consistent, reproducible releases.  
• Achieved an estimated **80% reduction in manual deployment efforts**, improving delivery speed and reliability.  

---

## 🔥 **Real-World Use Case: Continuous Deployment for Web Applications**

### 🏢 Scenario
A mid-sized software company is developing multiple customer-facing web applications — each with frequent UI updates, content changes, and security fixes.  
Manually deploying code to AWS every time slows the team down, introduces errors, and causes downtime.

---

### ⚙️ How This CI/CD Pipeline Solves It
By implementing the **Jenkins–Docker–Nginx–AWS EC2** pipeline:

1. Developers push code to GitHub → Jenkins automatically detects the change.  
2. Jenkins builds a new Docker image with the latest web app code.  
3. Docker container is deployed on AWS EC2, behind an Nginx reverse proxy.  
4. The live website updates automatically with zero manual steps and minimal downtime.  
5. Each build is consistent, isolated, and reproducible — thanks to Docker.

---

### 🧩 Real-World Examples
- 🛒 **E-commerce platforms (Flipkart, Amazon India):** Deploy UI updates daily without downtime.  
- 🎓 **EdTech companies (Byju’s, Coursera):** Automate front-end deployment pipelines.  
- 🚀 **Startups:** Automate deployments to AWS for MVPs and production apps, saving DevOps effort.

---

### 💼 Business Impact

| Benefit | Description |
|----------|-------------|
| 🚀 **Faster Releases** | Code changes go live within minutes of a push. |
| ⚙️ **Consistency** | Every environment runs the same Docker image — no “works on my machine” issue. |
| 🔁 **Automation** | No manual SSH or configuration needed — Jenkins handles everything. |
| 💰 **Cost Efficiency** | Reduces manual DevOps intervention, saving time and resources. |
| 🔒 **Reliability** | Rollback and version control through containerized builds. |

---

## 🔧 **Tech Stack**

| Category | Tools & Technologies | Description |
|-----------|----------------------|--------------|
| **Version Control** | **Git & GitHub** | Source code management with webhook-based Jenkins integration |
| **CI/CD Orchestration** | **Jenkins** | Automates build, test, and deployment |
| **Containerization** | **Docker** | Packages the web app into lightweight, portable containers |
| **Web Server / Reverse Proxy** | **Nginx** | Serves the web app and proxies traffic to containers |
| **Cloud Infrastructure** | **AWS EC2 (Ubuntu)** | Hosts Jenkins, Docker containers, and Nginx |
| **Scripting & Automation** | **Shell (Bash)** | Automates deployment and server setup |
| **Configuration Management** | **Ansible** *(optional)* | Automates configuration for multiple servers |
| **Operating System** | **Ubuntu Linux** | Lightweight, stable environment for Jenkins, Docker, Nginx |

---

## 🏗️ **Flow of Execution — CI/CD Pipeline**

### 1️⃣ Developer Pushes Code to GitHub
- Developer commits and pushes changes (e.g., updates `index.html`) to the **main** branch.  
- **GitHub Webhook** notifies **Jenkins** about the new push.

---

### 2️⃣ Jenkins Automatically Triggers the Pipeline

#### 🧱 Stage 1: Checkout
```bash
git clone https://github.com/harshitmaster8851/devops-pipeline-demo.git
```
Pulls the latest code from GitHub to ensure the build uses the newest version.

🐳 Stage 2: Build
```bash
Copy code
docker build -t devops-demo-app .
```

Builds a Docker image using the project’s Dockerfile.

🚀 Stage 3: Deploy to EC2

Jenkins connects to the EC2 instance via SSH using ec2-ssh credentials:

```bash
Copy code
docker stop devops-demo-container || true
docker rm devops-demo-container || true
docker run -d --name devops-demo-container -p 127.0.0.1:8081:8080 devops-demo-app
sudo nginx -t && sudo systemctl reload nginx
```

3️⃣ Nginx Reverse Proxy (on EC2)

Nginx listens on port 80 and forwards traffic to the Docker container running on 127.0.0.1:8081.

When users visit http://<EC2_PUBLIC_IP>, Nginx serves the web app from the container.

4️⃣ User Accesses the Live Website

Browser request flow:

EC2 → Nginx → Docker Container → index.html

The static website (Tooplate template) loads instantly.

5️⃣ Continuous Integration Loop

Every new Git push triggers Jenkins again → rebuilds the image → redeploys automatically.

6️⃣ Auto-Repo Discovery via GitHub App

Jenkins Organization Folder (linked via GitHub App) automatically:

Detects new repos containing a Jenkinsfile

Creates pipeline jobs dynamically

Builds and deploys automatically

📂 Project Structure Diagram
  

🌍 User Accesses Site → http://<EC2_PUBLIC_IP>



🚀 Deployment Steps

🧩 Phase 1 — One-Time Infrastructure Setup

🖥️ Step 1: Launch an EC2 Instance
Open ports: 22 (SSH), 80 (HTTP), 8080 (Jenkins), 8081 (App)

⚙️ Step 2: Install Required Packages
  ```bash
      Copy code
      sudo apt update
      sudo apt install -y git docker.io nginx
      sudo systemctl enable --now docker nginx
  ```

⚙️ Step 3: Install Jenkins

  ```bash
      Copy code
      curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
      sudo apt update
      sudo apt install -y fontconfig openjdk-17-jre jenkins
      sudo systemctl enable --now jenkins
  ```

        Access Jenkins:
        👉 http://<EC2_PUBLIC_IP>:8080

        Unlock Jenkins:

        ```bash
        Copy code
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
        ```

Step 4: Install Required Jenkins Plugins

Go to Manage Jenkins → Plugins → Available, and install the following essential plugins:

🔹 GitHub Integration — enables Jenkins to connect and interact with GitHub repositories.

🔹 GitHub Branch Source — allows Jenkins to discover branches and pull requests automatically.

🔹 GitHub API — provides API-level connectivity between Jenkins and GitHub.

🔹 Pipeline — supports defining and executing CI/CD pipelines using Jenkinsfile.

🔹 Credentials Binding — securely manages and injects credentials into build jobs.

🔹 SSH Agent — allows Jenkins to connect to remote servers (like EC2) via SSH for deployments.

🔹 Docker Pipeline — integrates Docker build, run, and push stages directly inside Jenkins pipelines.

🔑 Step 5: Add Jenkins Credentials

ID	Type	Description
ec2-ssh	SSH Username with Private Key	For Jenkins to connect to EC2

github-app	GitHub App Credential	For GitHub App integration

dockerhub-creds	Username + Password (optional)	For Docker Hub push


🌐 Step 6: Configure Nginx on EC2

```bash
Copy code
sudo tee /etc/nginx/conf.d/devops-proxy.conf > /dev/null <<'NGINX'
server {
    listen 80;
    server_name _;
    location / {
        proxy_pass http://127.0.0.1:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX

sudo nginx -t && sudo systemctl reload nginx
```


🧠 Phase 2 — Jenkins Pipeline Configuration

⚙️ Step 7: Create a Pipeline Job

Jenkins Dashboard → New Item → Pipeline

SCM: Git → Repo URL:
https://github.com/<your-username>/devops-pipeline-demo.git

Branch: main

Script Path: Jenkinsfile

Save → Build Now

⚙️ Step 8: Configure GitHub Webhook (Manual Method)

GitHub Repo → Settings → Webhooks → Add Webhook

Payload URL: http://<EC2_PUBLIC_IP>:8080/github-webhook/

Content type: application/json

Event: Push

🤖 Step 9: Configure GitHub App Integration

Create a GitHub App under

Settings → Developer Settings → GitHub Apps → New GitHub App

Set Webhook URL:

http://<EC2_PUBLIC_IP>:8080/github-webhook/

Permissions:

Contents → Read-only
Metadata → Read-only
Webhooks → Read & write
Subscribe to events:
Push
Repository
Pull request
Generate a Private Key (.pem) and note the App ID.
Convert the key to PKCS#8:

```bash
Copy code
openssl pkcs8 -topk8 -inform PEM -outform PEM \
-in github-app-key.pem -out github-app-key-pk8.pem -nocrypt
```

Add to Jenkins under Credentials → GitHub App.

Create a GitHub Organization Folder in Jenkins and select this credential.

✅ Jenkins will now automatically detect and build all repos containing a Jenkinsfile.

⚠️ Important Notes

Public IP Changes After EC2 Restart → Update IP in Jenkinsfile & GitHub webhook.

502 Bad Gateway Error → Check if container and Nginx are running.

Secure Jenkins → Restrict port 8080 to your IP only.

Use Elastic IP → Prevent changing IPs on reboot.

Clean Docker Images → Free space using sudo docker system prune -af.

👩‍💻 Author
Harshit Rastogi
🎓 B.Tech 3rd Year @ USICT, Dwarka
🔗 GitHub Profile

📸 Demo Clip
🎥 (Add your project demo GIF or video link here — e.g., build trigger + live site refresh)

💬 This project demonstrates a real-world CI/CD setup integrating GitHub, Jenkins, Docker, Nginx, and AWS EC2 — a fully automated, production-grade DevOps pipeline. 🚀
## Badges

Add badges from somewhere like: [shields.io](https://shields.io/)

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)


## Badges

Add badges from somewhere like: [shields.io](https://shields.io/)

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)

