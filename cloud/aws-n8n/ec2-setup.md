# 🚀 Launching a Free Tier EC2 Instance to Run n8n

This guide walks you through creating a **Free Tier-eligible EC2 instance** on AWS to deploy [n8n](https://n8n.io) using Docker and Docker Compose.

---

## ✅ Requirements

- AWS account (Free Tier eligible)
- Basic understanding of SSH and cloud instances
- A registered domain name (optional, but recommended for custom domain setup)

---

## 📦 Instance Specifications (Free Tier)

| Item          | Details                         |
|---------------|----------------------------------|
| Instance Type | `t2.micro` or `t3.micro`         |
| vCPUs         | 1                                |
| RAM           | 1 GiB                            |
| Storage       | Up to 30 GB EBS (Free Tier)      |
| OS            | Ubuntu Server 24.04 LTS          |

---

## 🧭 Steps to Launch an EC2 Instance

### 1. Open the AWS Console

Go to: [https://console.aws.amazon.com/ec2](https://console.aws.amazon.com/ec2)

---

### 2. Launch a New Instance

- Click **"Launch Instance"**
- Name the instance: `n8n-server` (or your preferred name)

#### Choose AMI

- Select **Ubuntu Server 24.04 LTS (Free Tier eligible)**

#### Choose Instance Type

- Select **t3.micro** *(Free Tier eligible)*

---

### 3. Configure Key Pair (SSH Access)

- If you don’t already have one, create a new key pair
- Download and save the `.pem` or `.ppk` file securely
- This is your private key for SSH access

---

### 4. Configure Storage

- Set root volume to **30 GB**
- Volume type: **gp3** (or **gp2**)

---

### 5. Configure Security Group

Create or modify a security group to allow:

| Type    | Protocol | Port Range | Source      |
|---------|----------|------------|-------------|
| SSH     | TCP      | 22         | Your IP     |
| HTTP    | TCP      | 80         | 0.0.0.0/0   |
| HTTPS   | TCP      | 443        | 0.0.0.0/0   |

> Optionally open **port 5678** if you want direct access to n8n (not behind NGINX).

---

### 6. Launch the Instance

- Click **"Launch Instance"**
- Wait for initialization to complete

![EC2 Launch Screenshot](https://github.com/user-attachments/assets/6863383e-6d74-4ad0-b514-90b10e030deb)

---

## 🔗 Connect to Your EC2 Instance

### Option 1: Using PuTTY (Windows)

1. Copy your instance’s public IP from the EC2 dashboard  
2. Paste it into PuTTY under **Host Name**
3. In the left sidebar: go to `Connection > SSH > Auth > Credentials`
4. Select your private key file (`.ppk`)
5. Return to **Session** and click **Open**

![PuTTY Screenshot](https://github.com/user-attachments/assets/2e56e58e-2023-4397-ad03-77f427678b6b)

---

### Option 2: Using Bash (Linux/macOS)

```bash
chmod 400 your-key.pem
ssh -i "your-key.pem" ubuntu@your-ec2-public-ip
```
