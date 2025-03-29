# 🚀 Automated Deployment of n8n Docker via GitHub Actions + AWS EC2 (SSH)

This project builds upon a secure Docker + AWS EC2 + Secrets Manager setup by adding a **GitHub-hosted CI/CD pipeline** to automate deployment via **SSH**.

---

## ✅ Project Goals

- Store n8n Docker configuration in GitHub
- Automatically deploy to EC2 using GitHub Actions
- Secure deployment using SSH authentication (no exposed credentials)
- Keep secrets managed securely via AWS Secrets Manager
- Simplify deployment with a single push to `main`

---

## 🔐 Step 1: Set Up SSH Key Authentication from GitHub to EC2

To allow GitHub Actions to connect securely to your EC2 instance via SSH:

### 🛠 1. Generate a new SSH key pair (on your local machine)

```bash
ssh-keygen -t ed25519 -C "github-actions@n8n-project"
```

You now have:
- Private key: `~/.ssh/id_ed25519`
- Public key: `~/.ssh/id_ed25519.pub`

### 🔗 2. Add the public key to your EC2 instance

SSH into your EC2 and append the public key to:

```bash
~/.ssh/authorized_keys
```

To append it directly:
```bash
cat ~/path/to/id_ed25519.pub >> ~/.ssh/authorized_keys
```

### 🧠 3. Add the private key to GitHub Secrets

In your GitHub repo:
- `EC2_SSH_KEY`: private key content
- `EC2_HOST`: your EC2 public IP or domain. Make sure your EC2 instance uses Elastic IP address
- `EC2_USER`: EC2 login username (e.g., `ubuntu`)

---

## 📦 Step 2: Create a GitHub Private Repository and Upload EC2 Docker Setup

1. Go to GitHub and create a **private repo** named `n8n-docker`
2. On your EC2 instance:

```bash
cd ~/n8n-docker
git init
git remote add origin git@github.com:your-username/n8n-docker.git
git add .
git commit -m "Initial commit: n8n Docker + Secrets Manager deployment"
git branch -M main
git push -u origin main
```

3. Add a `.gitignore` to exclude secrets:

```gitignore
.env
.env.json
*.log
```

---

## ⚙️ Step 3: Set Up GitHub Actions to Auto-Deploy to EC2 via SSH

Create `.github/workflows/deploy.yml`:

```yaml
name: 🚀 Deploy n8n to EC2

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v3

      - name: 🔐 SSH and Deploy to EC2
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ${{ secrets.EC2_USER }}
          key: ${{ secrets.EC2_SSH_KEY }}
          script: |
            cd ~/n8n-docker
            git pull origin main
            chmod +x start-n8n.sh
            ./start-n8n.sh
```

Push to `main` to trigger deployment!

---

## 🔁 Step 4: Auto-Restart n8n on EC2 Reboot using systemd

Create the service file:

```bash
sudo nano /etc/systemd/system/n8n.service
```

Paste:

```ini
[Unit]
Description=n8n startup service
After=network.target docker.service
Requires=docker.service

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/n8n-docker

ExecStartPre=/home/ubuntu/n8n-docker/start-n8n.sh
ExecStart=/usr/bin/docker start -a n8n-docker-n8n-1
ExecStop=/usr/bin/docker stop n8n-docker-n8n-1
Restart=always

[Install]
WantedBy=multi-user.target
```

Then:

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable n8n.service
sudo systemctl start n8n.service
```

Check logs:

```bash
sudo journalctl -u n8n.service -f
```

---

With this setup, your deployment is:
- Secure (via Secrets Manager + IAM)
- Automated (via GitHub Actions)
- Resilient (via systemd on EC2 reboot)
