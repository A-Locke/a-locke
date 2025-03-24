# IAM User Setup

This guide provides instructions for creating an IAM User for use with **Lambda** and **S3** in [n8n](https://n8n.io). Unlike IAM roles, IAM users provide long-lived access credentials (access key ID and secret access key), which can be used for automation workflows or integrations that require persistent credentials.

> ⚠️ **Note:** Use IAM roles with short-lived credentials where possible. IAM users with access keys should be carefully secured and rotated regularly.


---

## 🧭 Steps

### 1. Navigate to IAM in AWS Console

Go to [IAM Console](https://console.aws.amazon.com/iam/).

---

### 2. Create IAM User

- Click **Users** from the left sidebar.
- Click **Add users**.
- Set a **User name**, e.g., `n8n-lambda-s3-user`.
- Select **Access key - Programmatic access** as the access type.
- Click **Next: Permissions**.

---

### 3. Attach Permissions Policies

Choose **Attach policies directly**, and search for the following:

- `AmazonS3FullAccess` *(or a custom S3 policy with limited permissions)*
- `AWSLambdaFullAccess` *(or a more restrictive Lambda policy if needed)*

Check both and click **Next: Tags**.

> ✅ **Tip:** For better security, consider creating a custom policy with only the permissions required for your use case.

---

### 4. (Optional) Add Tags

Add any metadata tags you'd like, e.g.:

| Key | Value |
|-----|-------|
| Name | n8n Lambda S3 User |

Click **Next: Review**.

---

### 5. Review and Create

- Confirm the user name and permissions.
- Click **Create user**.

---

### 6. Save Access Keys

- You will see an **Access key ID** and **Secret access key**.
- Click **Download .csv** or copy the credentials **securely**.
- **Do not lose** the secret access key – you won’t be able to retrieve it again.

> 🔐 **Security Warning:** Never share or commit these keys to version control (e.g., GitHub). Store them securely using secrets managers or encrypted environment variables.

---

## ✅ Using in n8n

1. In n8n, go to **Credentials** > **AWS**.
2. Choose **Authentication Method**: `Access Key ID and Secret Access Key`.
3. Fill in:
   - **Access Key ID**: `AKIA...`
   - **Secret Access Key**: `wJalrXUtnFEMI/K7MDENG/bPxRfiCY...`
   - **Region**: e.g., `us-east-1`
4. Test and save the credential.

---

## 🔒 Security Best Practices

- Rotate access keys regularly.
- Restrict IAM policies to only necessary actions.
- Monitor usage with AWS CloudTrail.
- Prefer IAM roles where possible for ephemeral and scoped access.

---
