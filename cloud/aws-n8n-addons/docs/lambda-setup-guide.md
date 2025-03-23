# AWS Lambda Integration with n8n

This guide outlines how to integrate AWS Lambda with your n8n workflows without using Docker.

---

## ✅ Use Cases

- Extend n8n workflows with serverless compute
- Trigger Lambda functions from n8n
- Send data from Lambda to n8n webhooks

---

## 🔁 Calling Lambda from n8n

You can invoke Lambda functions from within n8n using two main methods:

### 1. AWS Lambda Node (Built-In)

- Drag the AWS Lambda node into your workflow
- Choose or configure AWS credentials
- Enter the function name and payload
- Supports direct invocation of Lambda functions

### 2. HTTP Request Node (via API Gateway)

- Create an API Gateway to expose your Lambda function
- Use the HTTP Request node in n8n to make a POST/GET request
- Useful when you want to trigger Lambda via REST

---

## 🔁 Triggering n8n from Lambda

Use a Webhook node in n8n to allow Lambda to call back into your workflow.

### Example Python Code (Lambda):

```python
import requests

def lambda_handler(event, context):
    webhook_url = "https://<your-n8n-domain-or-ip>/webhook/my-lambda-trigger"
    payload = {"event": "lambda_called", "data": event}

    response = requests.post(webhook_url, json=payload)
    return {
        "statusCode": 200,
        "body": "n8n triggered successfully!"
    }
```

---

## 🔐 Authentication Options

- Protect your n8n Webhook URLs with a secret path or header token
- Use IAM roles on your EC2 instance to allow n8n to invoke Lambda without storing credentials

---

## 📚 Related AWS Services

- **API Gateway**: To expose Lambda via REST endpoints
- **IAM**: To manage roles/permissions for Lambda and EC2
- **CloudWatch**: To log and monitor function activity

---

This setup is ideal for lightweight integrations and workflows where you want to keep infrastructure simple while expanding automation power using AWS Lambda.
