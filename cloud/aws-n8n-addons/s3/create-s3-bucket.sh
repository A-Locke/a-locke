#!/bin/bash

set -e

BUCKET_NAME="$1"

if [ -z "$BUCKET_NAME" ]; then
  echo "❌ Usage: $0 <bucket-name>"
  exit 1
fi

REGION=$(aws configure get region)

echo "🪣 Creating S3 bucket: $BUCKET_NAME in $REGION..."
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --create-bucket-configuration LocationConstraint="$REGION"

echo "🕒 Enabling versioning..."
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

echo "🔐 Enabling encryption (AES256)..."
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

echo "✅ Bucket $BUCKET_NAME setup complete."
