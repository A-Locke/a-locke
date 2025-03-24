
# 🪣 Creating and Securing an S3 Bucket for n8n (EC2 IAM Role)

This guide walks you through creating an S3 bucket using the AWS web interface and configuring it for use with `n8n` running on EC2 using an IAM role.

---

## ✅ Step 1: Create the S3 Bucket

1. Go to the AWS Console → **S3**
2. Click **“Create bucket”**
3. **Bucket name**: Choose a globally unique name (e.g., `n8n-data-uploads`)
4. **Region**: Choose the same region as your EC2 instance
5. Leave default settings unless you have specific requirements
6. Click **Create bucket**

---

## 🔒 Step 2: Block Public Access

1. After creating the bucket, go to the **Permissions** tab
2. Ensure **“Block all public access”** is **enabled** (default)
3. Confirm by saving changes if you modified anything

> ✅ n8n should not need public access — all access should go through the IAM role attached to EC2.

---

## 🔐 Step 3: Add a Bucket Policy (Optional, Fine-Grained Control)

This step is optional but recommended if you want to **limit access to a specific IAM role**.

Go to the **Permissions** tab → **Bucket policy**, then add a policy like:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowEC2IAMRoleAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::ACCOUNT_ID:role/n8n-ec2-role"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::n8n-data-uploads/*"
    }
  ]
}
```

Replace:
- `ACCOUNT_ID` with your AWS account ID
- `n8n-ec2-role` with your actual IAM role name
- `n8n-data-uploads` with your actual bucket name

---

## 🧪 Step 4: Test with n8n S3 Node

In `n8n`:
1. Add an **Amazon S3** node
2. Set credential type to **"Default Credential"** (it uses the EC2 IAM role)
3. Try uploading or downloading a test file

---

## 🛡️ Best Practices

| Practice | Recommendation |
|----------|----------------|
| ❌ No public access | Keep the bucket private (block all public access) |
| 🔐 IAM role only | Use the EC2 instance role to access the bucket |
| 📂 Prefix access | Limit permissions to only required prefixes (e.g., `uploads/*`) |
| 🔒 Encryption | Enable server-side encryption (SSE-S3 or SSE-KMS) |
| 🕵️ Audit logs | Enable S3 server access logging or use CloudTrail |

---
