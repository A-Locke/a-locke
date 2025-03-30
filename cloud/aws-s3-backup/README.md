# ☁️ Backup n8n Workflows to S3

This project outlines two reliable methods to back up your n8n workflows and data to AWS S3:

---

## ✅ Options

| Method                        | Description                                                             |
|-------------------------------|-------------------------------------------------------------------------|
| [Cron Script](./cron.md)      | Runs on the EC2 instance using bash + crontab, backs up `.n8n` to S3    |
| [GitHub Actions](./github-actions.md) | GitHub remotely triggers a backup script via SSH + uploads to S3        |

Both methods can be used together, with scheduled times offset slightly to avoid overlap. Backups are stored as timestamped `.tar.gz` archives and include your workflows, database, and encryption key.

---

## 🧹 Bonus Tip: Add Lifecycle Rules to Clean Old Backups

If you're using timestamped backups (like `n8n-backup-2025-03-29-0300.tar.gz`), they will accumulate in S3. To automatically remove older backups and save storage costs, you can use **S3 Lifecycle Rules**.

### ✅ Create a Lifecycle Rule (via Console)

1. Go to **S3 → Your Bucket**
2. Click the **Management** tab
3. Scroll to **"Lifecycle rules"**
4. Click **"Create lifecycle rule"**
5. Name it: `expire-old-backups`
6. Choose **prefix** (e.g. `n8n-backups/`)
7. Enable **"Expire current versions" after 30 days**
8. Save the rule

### 🔐 Required IAM Permissions

To manage lifecycle rules via CLI or programmatically, ensure this policy is attached to your user or role:

```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetLifecycleConfiguration",
    "s3:PutLifecycleConfiguration"
  ],
  "Resource": "arn:aws:s3:::your-bucket-name"
}

---

## 🔁 Restore Process

To restore a backup:

1. Download the `.tar.gz` from S3
2. Stop Docker: `docker compose down`
3. Remove existing `.n8n` contents (optional): `rm -rf ~/.n8n/*`
4. Extract the backup: `tar -xzf <backup-file>.tar.gz -C ~/.n8n`
5. Restart: `docker compose up -d`

Make sure to restore the correct `encryptionKey` or credentials will not decrypt.

## 🎯 Certification Relevance

Understanding and implementing EC2 → S3 backup strategies is directly aligned with key topics in AWS certifications:

### 🧠 AWS Certified Solutions Architect – Associate / Professional
- ✅ Data durability & backup solutions using S3
- ✅ EC2 storage considerations and disaster recovery patterns

### 🛠 AWS Certified SysOps Administrator – Associate
- ✅ Scheduled automation via cron or Lambda
- ✅ IAM policies, lifecycle rules, and secure access to S3

### 🔁 AWS Certified DevOps Engineer – Professional
- ✅ CI/CD backup and recovery integration
- ✅ Hybrid workflows combining GitHub Actions and AWS native tools

---

Implementing automated backups with proper retention aligns with **real-world AWS best practices** and **domain objectives** you'll encounter on the exam — and in production.
