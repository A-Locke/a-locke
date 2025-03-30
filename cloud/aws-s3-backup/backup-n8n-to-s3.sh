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
