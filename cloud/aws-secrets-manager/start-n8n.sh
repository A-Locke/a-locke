#!/bin/bash

# Config
SECRET_NAME="n8n/prod/env"
REGION="your_region"

echo "Fetching secrets from AWS Secrets Manager..."

# Fetch the secret JSON
aws secretsmanager get-secret-value \
  --secret-id "$SECRET_NAME" \
  --region "$REGION" \
  --query SecretString \
  --output text \
  > .env.json

# Convert JSON to .env format
echo "Converting secret JSON to .env format..."
jq -r 'to_entries | .[] | "\(.key)=\(.value)"' .env.json > .env

# Clean up
rm .env.json

# Start or restart n8n container
echo "Restarting n8n Docker service..."
docker compose down
docker compose up -d

echo "✅ n8n is up and running with secrets loaded from AWS."
