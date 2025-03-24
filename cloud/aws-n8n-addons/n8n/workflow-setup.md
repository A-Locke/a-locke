
# 🔄 Setting Up an n8n Workflow with EC2 IAM Role, Lambda, and S3

This guide walks you through creating a simple `n8n` workflow that runs on an EC2 instance using an IAM role. The workflow will:
1. Optionally trigger via a **webhook**
2. Call a **Lambda function**
3. Save a file to **S3**

---

## ✅ Prerequisites

- n8n is running in Docker on an **EC2 instance**
- IAM **role is attached** to EC2 with access to:
  - `lambda:InvokeFunction`
  - `s3:PutObject` for your target bucket
- Lambda test function already exists (`n8nTestFunction`)
- S3 bucket is created (e.g., `n8n-data-uploads`)

---

## 🧰 Step 1: Create a New Workflow in n8n

1. Open your n8n web interface.
2. Click **“New Workflow”** and name it: `LambdaToS3Test`.

---

## 🌐 Step 2: Add a Webhook Node (Optional)

If you want to trigger the workflow via an external call:

1. Add a **Webhook** node
2. Method: `POST`
3. Path: `/lambda-s3-test`
4. Response Mode: `On Received`
5. Add a response:
   - Status Code: `200`
   - Body: `"Webhook received successfully"`

---

## 🔐 Webhook Security Best Practices

| Practice | How |
|---------|-----|
| Unique URL | Use a non-guessable path like `/webhook/secure-abc123` |
| Auth Header | Require a custom header (e.g., `x-api-key`) and check it |
| Signature | Use HMAC to sign and verify incoming payloads |
| IP Whitelist | Restrict to trusted IPs (e.g., Cloudflare, your APIs) |
| Use HTTPS | Always secure the endpoint with SSL |

You can use an **IF node** in n8n to validate headers or IPs.

---

## 🧪 Step 3: Add AWS Lambda Node

1. Add a **Lambda** node
2. Operation: `Invoke`
3. Credential: **Use “Default Credential”** (IAM EC2 Role)
4. Function Name: `n8nTestFunction`
5. Payload:
```json
{
  "message": "Test call from n8n"
}
```

---

## 🪣 Step 4: Add an S3 Node

1. Add an **Amazon S3** node
2. Operation: `Upload`
3. Credential: **Use “Default Credential”**
4. Bucket Name: `n8n-data-uploads`
5. File Name: `n8n-test-file.txt`
6. File Content:
```plaintext
This file was created by n8n via Lambda integration.
```

---

## 🔗 Step 5: Connect the Nodes

1. If using a webhook:
   - Connect: **Webhook → Lambda → S3**
2. If manually triggering:
   - Use a **Manual Trigger** node → Lambda → S3

---

## 🚀 Step 6: Activate and Test

- **Webhook:** Call the webhook URL with a tool like Postman or `curl`
- **Manual:** Click "Execute Workflow" in n8n

✅ You should see:
- Lambda invoked and logged in CloudWatch
- A file appear in your S3 bucket

---

## 🔒 Security Checklist

| Checklist | Done? |
|----------|--------|
| IAM role scoped to just needed Lambda/S3 resources | ✅ |
| Webhook has secret path or header validation | ✅ |
| Bucket blocks public access | ✅ |
| Default encryption is enabled on S3 | ✅ |
| Old access keys removed from n8n | ✅ |

---
