# 🕒 Option 1: Backup n8n via Cron Script

This method uses a local shell script + cron job to upload n8n's `.n8n` directory to S3 daily (or on your schedule).

---

## 📄 `backup-n8n-to-s3.sh`

```bash
#!/bin/bash

TIMESTAMP=$(date +%F-%H%M%S)
BACKUP_DIR="/home/ubuntu/.n8n"
S3_BUCKET="s3://your-bucket-name/n8n-backups"
ARCHIVE="/tmp/n8n-backup-$TIMESTAMP.tar.gz"

# Create backup
tar -czf "$ARCHIVE" -C "$BACKUP_DIR" .

# Upload to S3
aws s3 cp "$ARCHIVE" "$S3_BUCKET/"

# Clean up
rm "$ARCHIVE"
```

---

## ⏰ Setup Cron Job

Edit crontab:

```bash
crontab -e
```

Add:

```cron
0 3 * * * /home/ubuntu/n8n-docker/backup-n8n-to-s3.sh >> /var/log/n8n-backup.log 2>&1
```

Runs every day at 03:00 UTC.

---

## 🔐 Ensure AWS Permissions

The EC2 role should allow this action:

```json
{
  "Effect": "Allow",
  "Action": "s3:PutObject",
  "Resource": "arn:aws:s3:::your-bucket-name/n8n-backups/*"
}
```
