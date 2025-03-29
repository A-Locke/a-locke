# n8n on AWS EC2 with Secrets Manager and Docker

This project provides a secure and automated deployment setup for [n8n](https://n8n.io/) on an AWS EC2 instance using Docker and AWS Secrets Manager.

## 🔐 Security Approach

Instead of storing `.env` files on disk or in version control, this setup retrieves all secrets securely at runtime from AWS Secrets Manager using IAM roles attached to the EC2 instance.

## ✅ Features

- Dockerized deployment of n8n
- Environment variables securely stored in AWS Secrets Manager
- Secrets fetched dynamically at container startup
- IAM roles used for permission-based access (no AWS credentials stored on the server)
- Ready to be extended with GitHub Actions or systemd

## 📁 Project Structure

```
.
├── docker-compose.yml
├── start-n8n.sh
├── test-secret-access.sh
└── README.md
```

## 🚀 Usage

1. Attach an IAM role to your EC2 instance with permission to access Secrets Manager.
2. Store your environment variables in Secrets Manager as a JSON object.
3. Run `./start-n8n.sh` to pull the secrets, convert them to `.env` format, and start the n8n container.

---

## 📦 Store Entire `.env` in AWS Secrets Manager

Store your environment variables as a single secret in AWS Secrets Manager in JSON format:

```json
{
  "N8N_BASIC_AUTH_ACTIVE": "true",
  "N8N_BASIC_AUTH_USER": "login",
  "N8N_BASIC_AUTH_PASSWORD": "password",
  "N8N_AWS_EC2_METADATA_DISABLED": "false",
  "N8N_AWS_REGION": "your-region",
  "N8N_PROTOCOL": "https",
  "N8N_SECURE_COOKIE": "true",
  "WEBHOOK_URL": "https://n8n.example.com",
}
```

Name it something like `n8n/prod/env`.

---

## 🧾 IAM Policy for EC2 Role (for Secrets Manager)

Attach this policy to the IAM role assigned to your EC2 instance:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "arn:aws:secretsmanager:your-region:your-account-id:secret:n8n/prod/env*"
    }
  ]
}
```

Replace `your-region` and `your-account-id` accordingly.

---

## ✅ Script: `test-secret-access.sh`

This script verifies that the EC2 instance can access the secret.

```bash
#!/bin/bash

SECRET_NAME="your/secret/name"
REGION="your-region"

echo "Testing access to AWS Secrets Manager..."

aws secretsmanager get-secret-value \
  --secret-id "$SECRET_NAME" \
  --region "$REGION" \
  --query SecretString \
  --output text > /tmp/n8n-secret-test.env

if [ $? -eq 0 ]; then
  echo "✅ Success: Secret fetched and written to /tmp/n8n-secret-test.env"
  head -n 5 /tmp/n8n-secret-test.env
else
  echo "❌ Error: Failed to fetch secret"
  exit 1
fi
```

---

## 🛠 How to Use

1. Run the script:
   ```bash
   chmod +x test-secret-access.sh
   ./test-secret-access.sh
   ```
2. If successful, integrate the `start-n8n.sh` script for deployment.

![Screenshot_15](https://github.com/user-attachments/assets/04c3f636-57eb-44a9-af6f-77348d07ecf0)


---

## 🔧 Next Step: Convert JSON ➡️ `.env` Format

Once you've fetched the JSON-formatted secret, use `jq` to convert it to the standard `.env` format that Docker Compose expects:

```bash
jq -r 'to_entries | .[] | "\(.key)=\(.value)"' .env.json > .env
```

This turns the JSON into key=value pairs.

---

## ✅ Create `start-n8n.sh` in the project folder

```bash
#!/bin/bash

# Move to the project directory
cd /path/to/n8n-docker || {
  echo "❌ Failed to find project directory"
  exit 1
}

# Config (REPLACE with your own secret name and region)
SECRET_NAME="your/secret/name"
REGION="your-region"

echo "Fetching secrets from AWS Secrets Manager..."

# Fetch secret
aws secretsmanager get-secret-value \
  --secret-id "$SECRET_NAME" \
  --region "$REGION" \
  --query SecretString \
  --output text > .env.json

# Convert to .env format
echo "Converting secret JSON to .env format..."
jq -r 'to_entries | .[] | "\(.key)=\(.value)"' .env.json > .env
rm .env.json

# Restart n8n
echo "Restarting n8n Docker service..."
docker compose down
docker compose up -d

echo "✅ n8n is up and running with secrets loaded from AWS."
```

---

## 🧪 How to Run

Make the script executable and run it:

```bash
chmod +x start-n8n.sh
./start-n8n.sh
```

![Screenshot_14](https://github.com/user-attachments/assets/8b2fb05c-f495-44cb-8185-ac7ccd187d1f)


---

## 🎯 Certification Relevance

This project supports skills relevant to:

- ✅ **EC2 & Docker Deployment**: Demonstrates automation of application deployment using shell scripts, Docker Compose, and EC2 Linux instances.
- 🔐 **AWS Secrets Manager**: Implements secure secret management and runtime environment injection without storing secrets on disk.
- 👤 **AWS IAM Roles**: Utilizes identity-based permissions and role attachment to EC2 for secure access to AWS services without static credentials.

## ✅ Future Enhancements

- 🚀 Host n8n Docker Setup in GitHub
  
Commit the Docker Compose setup and deployment scripts to a private or public GitHub repository. This enables easier collaboration, version control, and deployment tracking across environments.

- ⚙️ Add GitHub Actions CI/CD Workflow
  
Automate deployment to the EC2 instance using GitHub Actions. For example, on push to main, use SSH to:
  - Pull the latest changes to the EC2 instance
  - Run start-n8n.sh to securely fetch updated secrets
  - Restart the Docker container with the latest configuration
