# Create S3 Bucket for n8n

This guide helps you create an S3 bucket with encryption and versioning enabled.

---

## 🪣 Steps

### 1. Create Bucket

```bash
aws s3api create-bucket --bucket <your-bucket-name> --create-bucket-configuration LocationConstraint=$(aws configure get region)
```

### 2. Enable Versioning

```bash
aws s3api put-bucket-versioning --bucket <your-bucket-name> --versioning-configuration Status=Enabled
```

### 3. Enable Encryption

```bash
aws s3api put-bucket-encryption --bucket <your-bucket-name> --server-side-encryption-configuration '{
  "Rules": [{
    "ApplyServerSideEncryptionByDefault": {
      "SSEAlgorithm": "AES256"
    }
  }]
}'
```

---

Now your bucket is ready to store n8n workflows, backups, or Lambda input/output data securely.
