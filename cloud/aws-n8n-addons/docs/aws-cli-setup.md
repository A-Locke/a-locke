# AWS CLI Setup Guide

This guide walks you through setting up the AWS CLI for use with this project.

---

## 🔧 Install AWS CLI

Follow instructions from [AWS CLI official docs](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) or run:

### macOS

```bash
brew install awscli
```

### Ubuntu/Debian

```bash
sudo apt update && sudo apt install awscli -y
```

### Windows

Download the MSI installer from [AWS CLI for Windows](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html)

---

## 🔐 Configure Credentials

```bash
aws configure
```

You'll be prompted for:

- **AWS Access Key ID**
- **AWS Secret Access Key**
- **Default region name** (e.g., `us-east-1`)
- **Default output format** (e.g., `json`)

---

## ✅ Verify Setup

```bash
aws sts get-caller-identity
```

This should return your AWS account details.
