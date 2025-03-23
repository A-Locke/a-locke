#!/bin/bash

set -e

ROLE_NAME="n8n-lambda-role"
POLICY_NAME="n8n-lambda-policy"

echo "📄 Creating trust-policy.json..."
cat > trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }]
}
EOF

echo "🔧 Creating IAM Role: $ROLE_NAME..."
aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document file://trust-policy.json

echo "🔐 Attaching Inline Policy: $POLICY_NAME..."
aws iam put-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name "$POLICY_NAME" \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["logs:*", "s3:*"],
        "Resource": "*"
      }
    ]
  }'

echo "✅ IAM Role created and configured."
rm trust-policy.json
