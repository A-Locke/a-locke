
# 🔐 Securing n8n on EC2 with IAM Roles and AWS Best Practices

This guide explains how to configure **IAM roles for EC2** to allow an `n8n` instance (running in Docker) to securely access AWS **Lambda** and **S3**, following the **principle of least privilege**.

---

## 🧭 Step-by-Step: Use IAM Role for EC2

### ✅ Step 1: Create the IAM Role

1. Go to the AWS Console → **IAM** → **Roles**
2. Click **Create role**
3. **Trusted Entity**: Choose **AWS service**
4. Use case: Select **EC2**
5. Click **Next**

---

### 🔐 Step 2: Attach Permissions Policies

Choose what your `n8n` instance can do.

#### Option A: Use AWS Managed Policies (Broader Access)
- `AWSLambdaFullAccess`
- `AmazonS3FullAccess` *(or `AmazonS3ReadOnlyAccess`)*

> ⚠️ These are very broad — fine for testing, not best for production.

#### Option B: Create Custom Policies (Recommended)

##### 📄 Example: `n8n-lambda-policy`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:YourFunctionName"
    }
  ]
}
```

##### 📄 Example: `n8n-s3-policy`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}
```

Replace `REGION`, `ACCOUNT_ID`, function name, and bucket name accordingly.

Once selected, click **Next**, name your role (`n8n-ec2-role`), and **create** it.

---

### ⚙️ Step 3: Attach the Role to Your EC2 Instance

1. Go to **EC2 → Instances**
2. Select your `n8n` instance
3. Click **Actions** → **Security** → **Modify IAM Role**
4. Select your role (`n8n-ec2-role`)
5. Save

No reboot is required.

---

## 🧪 Step 4: Verify in n8n

- Inside the Docker container, n8n uses the IAM role automatically.
- Use **“Default Credential”** in Lambda/S3 nodes.
- Test with a simple Lambda call or S3 upload.

---

## 🧼 Step 5: Remove Old Access Keys

If you previously used access keys in n8n:
- Go to **Credentials** and delete them to prevent accidental use.

---

## ✅ Benefits of IAM Roles for EC2

| Feature | Benefit |
|--------|---------|
| 🔒 No stored secrets | Uses temporary credentials from metadata |
| ⏳ Auto-rotating | AWS manages rotation and expiration |
| 🧭 Least privilege | Role can be scoped tightly |
| 🚫 No manual keys | Less risk of exposure |

---

## 📌 Tip: Use Webhook Security Best Practices

- Use **authentication headers** or **HMAC** validation.
- Place API Gateway in front of Lambda if needed.
- Prefer **unique webhook URLs** in n8n (`/webhook/secure-abcd1234`).
- Avoid generic public webhooks for sensitive workflows.

---
