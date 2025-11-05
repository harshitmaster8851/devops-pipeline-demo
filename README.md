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

## 🔁 Flow of Execution — CI/CD Pipeline Overview

🧑‍💻 Developer Pushes Code to GitHub
➜ A new commit is pushed to the main branch of your repository.

📩 GitHub Webhook Triggers Jenkins
➜ Jenkins receives the push event instantly and starts the CI/CD pipeline automatically.

⚙️ Jenkins Executes the Pipeline
➜ Pulls the latest code → Builds a new Docker image → Deploys it on AWS EC2 via SSH.

🐳 Docker Container Starts on EC2
➜ The web app runs inside a container on port 8081 with your latest changes.

🌐 Nginx Reverse Proxy Forwards Requests
➜ Nginx (on EC2) listens on port 80 and forwards traffic to 127.0.0.1:8081, serving your app to users.

🚀 Live Website Instantly Updated
➜ The new version of your web app goes live at http://<EC2_PUBLIC_IP>, automatically — no manual steps!

---

## 📂 Project Structure Diagram

<img width="1536" height="1024" alt="workflow image" src="https://github.com/user-attachments/assets/63d91789-4a1b-4dc4-b449-84bde2bd4f18" />

---

## 📸 Demo Clip
🎥  https://github.com/user-attachments/assets/b189fdc7-0b36-4c73-9c3a-11fc949e36d9



💬 This project demonstrates a real-world CI/CD setup integrating GitHub, Jenkins, Docker, Nginx, and AWS EC2 — a fully automated, production-grade DevOps pipeline. 🚀

--- 

🌍 User Accesses Site → http://<EC2_PUBLIC_IP>


---



## 🚀 Deployment Steps


  ### 🧩 Phase 1 — One-Time Infrastructure Setup

  🖥️ Step 1: Launch an AWS EC2 Instance

  Choose Ubuntu 20.04 (Free Tier eligible).

  Open these ports in your Security Group:

  | Port | Purpose        | Access       |
  | ---- | -------------- | ------------ |
  | 22   | SSH            | Your IP only |
  | 80   | HTTP (Website) | Open to all  |
  | 8080 | Jenkins        | Your IP only |
  | 8081 | App Container  | Your IP only |



  ⚙️ Step 2: Install Core Packages
  ```bash
  sudo apt update
  sudo apt install -y git docker.io nginx
  sudo systemctl enable --now docker nginx
  ```

  ⚙️ Step 3: Install Jenkins
  ```bash
  curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

  sudo apt update
  sudo apt install -y fontconfig openjdk-17-jre jenkins
  sudo systemctl enable --now jenkins
  ```


  🧭 Access Jenkins:
  👉 http://<EC2_PUBLIC_IP>:8080

  Unlock Jenkins:

  ```bash 
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
  ```


  Install suggested plugins and create your admin user.

### Phase 2 — Jenkins Setup via Web Interface

  🧩 Step 4: Install Required Plugins

  * Go to Manage Jenkins → Plugins → Available, then install:

    🔹 GitHub Integration

    🔹 GitHub Branch Source

    🔹 GitHub API

    🔹 Pipeline

    🔹 Credentials Binding

    🔹 SSH Agent

    🔹 Docker Pipeline

    ✅ These enable Jenkins to pull from GitHub, build with Docker, and deploy on EC2.


🔑 Step 5: Add Jenkins Credentials

Navigate to:
Manage Jenkins → Credentials → Global → Add Credentials

| ID                | Type                             | Description                              |
| ----------------- | -------------------------------- | ---------------------------------------- |
| `ec2-ssh`         | SSH Username with Private Key    | Used by Jenkins to connect to EC2        |
| `github-app`      | GitHub App Credential            | Used for GitHub integration              |


🌐 Step 6: Configure Nginx on EC2

* Create a reverse proxy config file so Nginx can route traffic from port 80 → 8081 (where Docker runs your app):
```bash 
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


### ⚙️ Phase 3 — GitHub Integration and Automation

🧱 Step 7: Set Up Your GitHub Repository

* On GitHub (web), create a new repository — e.g. devops-pipeline-demo

  * Add the following files in the repo:

    [Dockerfile](https://github.com/harshitmaster8851/devops-pipeline-demo/blob/1a2d5e6d240cab31b7d77e66a73eb33f45a7b71a/Dockerfile) 🐳

    [Jenkinsfile](https://github.com/harshitmaster8851/devops-pipeline-demo/blob/1a2d5e6d240cab31b7d77e66a73eb33f45a7b71a/Jenkinsfile)⚙️

    [website](https://github.com/harshitmaster8851/devops-pipeline-demo/tree/1a2d5e6d240cab31b7d77e66a73eb33f45a7b71a/website) (contains your static website like Tooplate template)


* Commit and push all files.

📩 Step 8: Connect GitHub → Jenkins (Webhook Method)

--> Go to GitHub → Repo → Settings → Webhooks → Add Webhook

* Enter Payload URL: http://<EC2_PUBLIC_IP>:8080/github-webhook/

* Content type: application/json

* Event: Just the Push event

* Click Add Webhook

✅ Now Jenkins will automatically trigger the build whenever you push code to GitHub!


| Stage | Action   | Description                                   |
| ----- | -------- | --------------------------------------------- |
| 1️⃣   | Checkout | Jenkins pulls the latest code from GitHub     |
| 2️⃣   | Build    | Jenkins builds a new Docker image             |
| 3️⃣   | Deploy   | Jenkins runs the container on EC2 (port 8081) |
| 4️⃣   | Serve    | Nginx forwards port 80 → 8081                 |
| ✅     | Result   | Website live at `http://<EC2_PUBLIC_IP>/`     |


## ⚠️ Important Notes

Public IP Changes After EC2 Restart → Update IP in Jenkinsfile & GitHub webhook.

502 Bad Gateway Error → Check if container and Nginx are running.

Secure Jenkins → Restrict port 8080 to your IP only.

Use Elastic IP → Prevent changing IPs on reboot.

Clean Docker Images → Free space using sudo docker system prune -af.

## 👩‍💻 Author
Harshit Rastogi
🎓 B.Tech 3rd Year @ USICT, Dwarka
🔗 GitHub Profile


## Badges

Add badges from somewhere like: [shields.io](https://shields.io/)

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)


****
