
# 🚀 n8n + AWS Integration: IAM Role, Lambda, and S3 Workflow

This project demonstrates how to securely integrate `n8n` (running in Docker on EC2) with AWS services using IAM roles — specifically to invoke a Lambda function and upload data to S3, optionally triggered via a secure webhook.

---

## 🧾 Project Overview

This module guides you through:
- Setting up IAM roles for EC2 to securely interact with AWS
- Setting up IAM user in case of experiencing issues with roles
- Creating a test Lambda function
- Setting up a secure S3 bucket
- Building an `n8n` workflow to tie everything together

The goal is to securely execute AWS workflows from within `n8n` without storing any access keys, following AWS best practices.

---

## 🧰 Tech Stack & Tools

- **n8n** (Workflow automation)
- **AWS Lambda**
- **Amazon S3**
- **EC2 (Ubuntu + Docker)**
- **IAM Roles (for EC2)**
- **AWS Web Console**

---

## 🧠 Key Skills Demonstrated

- IAM role-based access control
- Secure integration of AWS services with external tools
- Serverless function creation (Lambda)
- S3 bucket setup and access control
- Webhook security best practices
- Workflow automation using n8n

---

## 📌 Deployment Guide

Follow the guides in the folders listed below to recreate the full setup:

1. 🔐 **Configure IAM Role for EC2 or IAM User**
   - 📄 [`IAM/iam-role-setup.md`](IAM/iam-role-setup.md)
   - 📄 [`IAM/iam-user-setup.md`](IAM/iam-user-setup.md)

2. 🧪 **Create a Lambda Test Function**
   - 📄 [`lambda/lambda-function-guide.md`](lambda/lambda-function-guide.md)

3. 🪣 **Create and Secure an S3 Bucket**
   - 📄 [`s3/s3-setup.md`](s3/s3-setup.md)

4. 🔄 **Build the n8n Workflow (Lambda + S3)**
   - 📄 [`n8n/workflow-setup.md`](n8n/workflow-setup.md)

---

## 🎯 Certification Relevance

These steps align well with foundational and associate-level AWS certifications:

### ☁️ AWS Certified Cloud Practitioner:
- Understands IAM roles, permissions, and AWS security best practices
- Demonstrates practical usage of AWS services (Lambda, S3)

### 🛠 AWS Certified Developer – Associate:
- Applies serverless compute concepts (Lambda)
- Manages secure app integration with S3 and IAM
- Uses event-driven workflows with webhooks and automation tools

---

## ✅ Future Enhancements

- 🔄 Add error handling and retries in the n8n workflow
- 🔐 Add HMAC signature validation for webhook security
- 📊 Enable CloudWatch dashboards and CloudTrail logging
- 🧪 Expand Lambda logic for more complex operations
- 📦 Use Terraform or CloudFormation for infrastructure-as-code

---
