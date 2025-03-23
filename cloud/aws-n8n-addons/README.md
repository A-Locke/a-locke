# AWS n8n Add-Ons Project

This project builds on top of the [`cloud/aws-n8n`](../aws-n8n/README.md) EC2 setup to expand functionality using AWS services like IAM, S3, and Lambda.

---

## ✅ Prerequisites

Before starting, make sure:

- You've deployed the EC2-based n8n instance from [`cloud/aws-n8n`](../aws-n8n/README.md)
- [AWS CLI is installed and configured](./docs/aws-cli-setup.md)
- You have appropriate IAM permissions to create IAM roles, S3 buckets, and Lambda functions

---

## 📌 Project Overview

This add-on project introduces AWS integrations that extend n8n's capabilities, including:

- **IAM**: Roles and policies for secure AWS interactions
- **S3**: Storage for workflows, assets, and backups
- **Lambda**: Event-driven functions for automation and integration

---

## 🛠️ Tech Stack & Tools

- **AWS CLI**
- **Bash scripting**
- **Python (Lambda functions)**
- **Amazon S3, IAM, Lambda**

---

## 🚀 Key Skills Demonstrated

- AWS Identity and Access Management (IAM)
- Secure S3 bucket configuration and lifecycle management
- Deploying and testing AWS Lambda functions via CLI
- Automating resource creation with shell scripts
- Using Lambda in conjunction with n8n workflows

---

## 📦 Deployment Guide

### 1. [Set Up AWS CLI](./docs/aws-cli-setup.md)

Ensure your credentials and region are configured.

---

### 2. [Create IAM Role](./docs/iam-role-setup.md)

Create a Lambda-compatible role with S3 and logging permissions.

---

### 3. [Create S3 Bucket](./docs/s3-bucket-setup.md)

Provision a secure, versioned bucket to store assets and workflow data.

---

### 4. [Integrate AWS Lambda with n8n](./docs/lambda-setup-guide.md)

Learn how to call Lambda from n8n or trigger workflows from Lambda using webhooks.

---

## 🎓 Certification Relevance

This project helps reinforce topics from **AWS Certified Cloud Practitioner** and **AWS Certified Solutions Architect – Associate**, such as:

- IAM roles and policies
- Serverless design with Lambda
- S3 bucket management
- Using AWS CLI and serverless resources for automation

---

## 🔭 Future Enhancements

- Automate all setup via AWS CDK or Terraform
- Add EventBridge triggers for Lambda automation
- Build n8n nodes to directly read/write from S3
- Scheduled Lambda functions to back up workflows
- Integrate CloudWatch logs and alarms
