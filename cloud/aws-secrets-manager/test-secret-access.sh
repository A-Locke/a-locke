#!/bin/bash

# Config
SECRET_NAME="n8n/prod/env"
REGION="your_region"

echo "Testing access to AWS Secrets Manager..."

# Try to fetch the secret
aws secretsmanager get-secret-value \
  --secret-id "$SECRET_NAME" \
  --region "$REGION" \
  --query SecretString \
  --output text \
  > /tmp/n8n-secret-test.env

# Check if it succeeded
if [ $? -eq 0 ]; then
  echo "✅ Success: Secret fetched and written to /tmp/n8n-secret-test.env"
  echo "First few lines of the secret:"
  head -n 5 /tmp/n8n-secret-test.env
else
  echo "❌ Error: Failed to fetch secret"
  exit 1
fi
