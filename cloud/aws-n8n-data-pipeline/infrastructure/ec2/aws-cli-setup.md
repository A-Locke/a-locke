# 🛠️ AWS CLI Setup Guide

This guide walks you through installing and configuring the AWS Command Line Interface (CLI) on your EC2 instance or local machine. AWS CLI allows `n8n` to interact with AWS services such as S3 and Lambda.

---

## ✅ Prerequisites

- AWS account with programmatic access enabled
- Access to terminal/SSH on your EC2 instance or local system

---

## 📦 Step 1: Install AWS CLI

### On Ubuntu/Debian (including EC2 Ubuntu instances):

```bash
sudo apt update
sudo apt install awscli -y
```

### On macOS (using Homebrew):

```bash
brew install awscli
```

### On Windows:

- Download the installer from: https://aws.amazon.com/cli/
- Follow the installation instructions in the wizard

---

## ⚙️ Step 2: Configure the AWS CLI

Run:

```bash
aws configure
```

Enter your credentials:

- **AWS Access Key ID**: `YOUR_ACCESS_KEY`
- **AWS Secret Access Key**: `YOUR_SECRET_KEY`
- **Default region name**: e.g. `us-east-1`
- **Default output format**: `json` (recommended)

These will be stored in `~/.aws/credentials` and `~/.aws/config`.

> 💡 You can create a dedicated IAM user for n8n-related automation and assign only the permissions it needs (e.g., Lambda invoke, S3 access).

---

## 🧪 Step 3: Test AWS CLI Access

List your S3 buckets to verify access:

```bash
aws s3 ls
```

Get your account identity:

```bash
aws sts get-caller-identity
```

---

## 🔐 Security Best Practices

- Avoid hardcoding keys in scripts — use environment variables or AWS profiles
- Use IAM roles if running on EC2 to avoid key leakage
- Rotate credentials regularly
- Use `aws configure --profile <name>` for multiple account profiles

---

## 📚 Resources

- AWS CLI Docs: https://docs.aws.amazon.com/cli/latest/userguide/
- Create IAM User: https://console.aws.amazon.com/iam/home#/users
