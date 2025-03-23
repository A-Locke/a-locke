# 🌐 Deploying n8n on AWS EC2 with Docker, NGINX, Custom Domain, and SSL

## 🧾 Project Overview

This project demonstrates how to deploy [n8n](https://n8n.io), an open-source workflow automation tool, on an **AWS EC2 instance** using **Docker Compose**. The deployment includes:

- Containerizing n8n with Docker
- Configuring **NGINX** as a reverse proxy
- Connecting a **custom domain** to the EC2 instance
- Securing access with **Let's Encrypt SSL certificates**

---

## 🧰 Tech Stack & Tools

- **AWS EC2** (24.04)
- **Docker & Docker Compose**
- **n8n** (official Docker image)
- **NGINX** (as reverse proxy)
- **Certbot / Let’s Encrypt** (for SSL)
- **DNS Provider** (e.g., Active24)

---

## 🧠 Key Skills Demonstrated

- Provisioning and configuring cloud infrastructure
- Docker-based application deployment
- Reverse proxy setup using NGINX
- Domain linking and DNS configuration
- HTTPS setup and SSL certificate management

---

## 📌 Deployment Guide

### 1. Provision EC2 Instance
📘 [EC2 Setup Guide](ec2-setup.md)

- Launch an Ubuntu EC2 instance (e.g., t3.micro – free tier)
- Configure the security group to allow:
  - TCP 22 (SSH)
  - TCP 80 (HTTP)
  - TCP 443 (HTTPS)

---

### 2. Install Docker & Docker Compose

```bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
```

---

### 3. Configure Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  n8n:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=youruser
      - N8N_BASIC_AUTH_PASSWORD=yourpassword
      - N8N_HOST=n8n.yourdomain.com
      - N8N_PORT=5678
    volumes:
      - ./n8n_data:/home/node/.n8n
    restart: always
```

Start the container:

```bash
docker-compose up -d
```

---

### 4. Configure NGINX as Reverse Proxy

Install NGINX:

```bash
sudo apt install nginx -y
```

Create a new NGINX config file at `/etc/nginx/sites-available/n8n`:

```nginx
server {
    listen 80;
    server_name n8n.yourdomain.com;

    location / {
        proxy_pass http://localhost:5678;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable the configuration and restart NGINX:

```bash
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

### 5. Point Domain to EC2 Instance
📘 [DNS Guide](dns-config.md)

- In your DNS manager (e.g., Active24), create an **A record** for `n8n.yourdomain.com` pointing to your EC2 instance’s public IP.

---

### 6. Secure with SSL Using Certbot
📘 [SSL Setup Guide](ssl-setup.md)

Install Certbot:

```bash
sudo apt install certbot python3-certbot-nginx -y
```

Request the SSL certificate:

```bash
sudo certbot --nginx -d n8n.yourdomain.com
```

Auto-renewal is handled by `systemd` timers (installed with Certbot).

---

## 🔒 Security Highlights

- SSH key authentication (password login disabled)
- HTTPS enforced with auto-renewing certificates
- HTTP redirected to HTTPS via NGINX
- Docker container isolation
- Secure cookies enabled in n8n config

---

## 🎯 Certification Relevance

This project supports skills relevant to:

- **EC2 provisioning & network access**
- **Docker-based application deployment**
- **DNS & domain routing**
- **Application-level security & SSL management**

---

## ✅ Future Enhancements

- Configure AWS CLI 
- Add persistent storage using AWS S3
- Set up AWS IAM 
