# yii2-docker-ansible-cicd
Perals touch Task
# Yii2 Docker Swarm Deployment with Ansible and GitHub Actions

## Overview

This project demonstrates deploying a Yii2 PHP application using Docker Swarm on an AWS EC2 instance. It uses NGINX (host-based) as a reverse proxy, automates provisioning with Ansible, and includes CI/CD with GitHub Actions.

---

## 📦 Project Structure

```
├── ansible/
│   ├── install_docker.yml
│   ├── install_nginx.yml
│   └── deploy_app.yml
├── docker/
│   └── Dockerfile
├── docker-compose.yml
├── nginx/
│   └── yii2.conf
├── .github/
│   └── workflows/
│       └── deploy.yml
├── app/ (Yii2 App Directory)
├── README.md
```

---

## 🔧 Setup Instructions

### 1. Provision AWS EC2

* Launch a new Ubuntu EC2 instance
* Allow ports 22 (SSH), 80 (HTTP), and 443 (HTTPS)

### 2. Ansible Setup

Install Ansible on your local machine and run:

```bash
ansible-playbook -i <EC2-IP>, --private-key <path-to-key.pem> ansible/install_docker.yml
ansible-playbook -i <EC2-IP>, --private-key <path-to-key.pem> ansible/install_nginx.yml
ansible-playbook -i <EC2-IP>, --private-key <path-to-key.pem> ansible/deploy_app.yml
```

### 3. NGINX Configuration

Edit the reverse proxy in `nginx/yii2.conf` to forward to your app container port. Example:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:8080;  # app container exposed port
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Reload NGINX:

```bash
sudo ln -s /path/to/nginx/yii2.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

---

## 🚀 CI/CD via GitHub Actions

### `.github/workflows/deploy.yml`

On push to `main`, the pipeline will:

* Build Docker image
* Push to DockerHub
* SSH to EC2
* Pull new image and update Swarm service with rollback on failure

### Rollback Logic

```yaml
run: |
  docker service update \
    --image your-dockerhub-username/yii2-app:latest \
    --update-failure-action rollback \
    yii2-service
```

---

## 🔐 Secrets Required (GitHub)

* `EC2_HOST`: EC2 Public IP
* `EC2_USER`: ubuntu
* `EC2_SSH_KEY`: Base64-encoded private key
* `DOCKERHUB_USERNAME`
* `DOCKERHUB_TOKEN`

---

## 🧪 Testing

1. Push code to `main` branch
2. Wait for GitHub Action to complete
3. Visit `http://your-ec2-ip/` or configured domain
4. Confirm Yii2 app is running

---

## ✅ Assumptions

* Yii2 app is compatible with PHP 7.4/8.0
* DockerHub repo is public/private with correct credentials
* EC2 instance is reachable via SSH



