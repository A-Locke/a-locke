# Create IAM Role for Lambda (n8n)

This guide creates an IAM role for use with AWS Lambda that has permissions to log and interact with S3.

---

## 📌 Steps

### 1. Create Trust Policy

Save this as `trust-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }]
}
```

### 2. Create Role

```bash
aws iam create-role --role-name n8n-lambda-role --assume-role-policy-document file://trust-policy.json
```

### 3. Attach Inline Policy

```bash
aws iam put-role-policy --role-name n8n-lambda-role --policy-name n8n-lambda-policy --policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["logs:*", "s3:*"],
      "Resource": "*"
    }
  ]
}'
```

---

This role can now be used when creating Lambda functions
