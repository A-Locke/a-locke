# 🤖 n8n AWS LLM Data Pipeline

This project sets up a full cloud-based foundation to support AI-powered workflow automation using [n8n](https://n8n.io). It prepares an AWS-backed environment where you can:

- Pull data from APIs or S3
- Process data using an LLM (via AWS Lambda or OpenAI)
- Output structured results to **Google Sheets**
- Pull text templates from **Google Docs**
- Send formatted reports via **email**

This repo focuses on setting up the **infrastructure and service integrations**. Workflow automation using n8n nodes will come in future stages.

---

## ✅ Prerequisites

Before starting, make sure you have:

- An EC2 instance with **n8n running in Docker**
  - (See: [Deploy n8n to EC2 Guide](../aws-n8n/README.md))
- AWS CLI installed (locally or on the EC2 instance)
- An [AWS account](https://aws.amazon.com/)
- A [Google Cloud Platform (GCP)](https://console.cloud.google.com/) project

---

## 📦 Features & Integrations

| Service      | Purpose                                      |
|--------------|----------------------------------------------|
| AWS EC2      | Hosts the running instance of n8n            |
| AWS S3       | Optional data storage                        |
| AWS Lambda   | Hosts a lightweight LLM processor            |
| IAM Roles    | Securely connect EC2 to AWS services         |
| Google Sheets| Store and structure output                   |
| Google Docs  | Provide narrative/templated input            |
| Email (SMTP/Gmail) | Deliver results in report form         |

---

## 🛠️ Setup Instructions

### 1. 🔐 Configure AWS CLI

Follow [`infrastructure/ec2/aws-cli-setup.md`](infrastructure/ec2/aws-cli-setup.md) to:
- Install and configure the AWS CLI
- Verify access with `aws sts get-caller-identity`

---

### 2. 📜 Set Up IAM Roles & Policies

Define and attach policies to enable n8n to:
- Read/write from S3
- Invoke Lambda functions

See:
- [`s3-access-policy.json`](infrastructure/iam/s3-access-policy.json)
- [`lambda-invoke-policy.json`](infrastructure/iam/lambda-invoke-policy.json)
- [`attach-policies.md`](infrastructure/iam/attach-policies.md)

---

### 3. ⚙️ Deploy the LLM Lambda Function

Use the sample Node.js Lambda function:
- Source: [`index.js`](infrastructure/lambda/llm_processor/index.js)
- Deployment instructions: [`deploy-lambda.md`](infrastructure/lambda/llm_processor/deploy-lambda.md)

This function simulates LLM processing and returns a summary string.

---

### 4. 🧾 Set Up Google Service Account

1. Enable **Google Sheets** and **Docs** APIs
2. Create and download a service account JSON key
3. Share your Sheet and Doc with the service account email

Guides:
- [`service-account-setup.md`](google/service-account-setup.md)
- [`google-sheets-api-guide.md`](google/google-sheets-api-guide.md)
- [`google-docs-api-guide.md`](google/google-docs-api-guide.md)

---

### 5. 🔑 Environment Variables

Create a `.env` file using:
```env
# AWS
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=

# Google
GOOGLE_SERVICE_ACCOUNT_CREDENTIALS=./google/credentials.json

# Optional
N8N_WEBHOOK_URL=https://your-n8n-url/webhook
```

---

### 6. 🧪 Test Setup

- Run `aws s3 ls` to confirm S3 access
- Run `aws lambda invoke` to test the LLM function
- Use the n8n credentials UI to create:
  - AWS credentials
  - Google credentials (OAuth2 or service account)

---

## 📐 Architecture Overview

```
[External API / S3] 
        ↓
      [n8n]
        ↓
[Lambda (LLM Processor)]
        ↓
[Google Sheets] ←→ [Google Docs]
        ↓
      [Email]
```

All processing is orchestrated by n8n, with serverless functions and cloud APIs supporting scalable automation.

---

## 📂 Project Structure

```
n8n-aws-llm-data-pipeline/
├── README.md
├── env/
│   ├── .env.example
│   └── n8n-credentials-notes.md
├── google/
│   ├── service-account-setup.md
│   ├── google-sheets-api-guide.md
│   ├── google-docs-api-guide.md
│   └── oauth2-scopes.md
├── infrastructure/
│   ├── ec2/aws-cli-setup.md
│   ├── iam/
│   │   ├── s3-access-policy.json
│   │   ├── lambda-invoke-policy.json
│   │   └── attach-policies.md
│   └── lambda/llm_processor/
│       ├── index.js
│       ├── package.json
│       └── deploy-lambda.md
├── diagrams/
│   └── architecture.txt
└── workflows/
    └── .gitkeep
```

---

## 🔮 Future Enhancements

- 🧠 Integrate OpenAI or AWS Bedrock in the LLM Lambda
- 📊 Auto-generate charts and embed in email
- ☁️ Add support for Google Drive uploads or Discord notifications
- 🔐 Harden infrastructure with API Gateway or AWS WAF

---

## 🧠 License

This project uses the [MIT License](LICENSE).

---
