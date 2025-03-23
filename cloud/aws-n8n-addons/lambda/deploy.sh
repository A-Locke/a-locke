#!/bin/bash

set -e

FUNCTION_NAME="n8nSampleLambda"
ROLE_NAME="n8n-lambda-role"

# Get role ARN dynamically
ROLE_ARN=$(aws iam get-role --role-name "$ROLE_NAME" --query 'Role.Arn' --output text)

echo "📦 Zipping handler.py..."
zip function.zip handler.py

echo "🚀 Creating Lambda function: $FUNCTION_NAME..."
aws lambda create-function \
  --function-name "$FUNCTION_NAME" \
  --runtime python3.9 \
  --role "$ROLE_ARN" \
  --handler handler.lambda_handler \
  --zip-file fileb://function.zip

rm function.zip
echo "✅ Lambda function created and ready."
