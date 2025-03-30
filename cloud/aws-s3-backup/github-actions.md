# 🧪 Option 2: Backup n8n to S3 via GitHub Actions

This method uses a GitHub Actions workflow to SSH into your EC2 instance and run the backup remotely.

---

## ⚙️ GitHub Workflow Example

Create `.github/workflows/backup.yml`:

```yaml
name: ☁️ Backup n8n to S3

on:
  schedule:
    - cron: '10 3 * * *'  # Runs daily at 03:10 UTC
  workflow_dispatch:       # Allow manual triggering

jobs:
  backup:
    runs-on: ubuntu-latest

    steps:
      - name: 🧪 SSH into EC2 and run backup script
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ${{ secrets.EC2_USER }}
          key: ${{ secrets.EC2_SSH_KEY }}
          script: |
            echo "Starting n8n S3 backup..."
            bash /home/ubuntu/n8n-docker/backup-n8n-to-s3.sh
            echo "✅ Backup script completed."

```

---

## 🔐 Required GitHub Secrets

| Name         | Value                        |
|--------------|------------------------------|
| `EC2_HOST`   | EC2 public IP or domain      |
| `EC2_USER`   | SSH username (e.g., `ubuntu`)|
| `EC2_SSH_KEY`| Private SSH key              |

---

## 🧠 Tips

- Offset this from your cron backup by a few minutes
- Use unique filenames per backup (`date +%F-%H%M%S`)
- Keep backup logs locally or in S3 for auditing
