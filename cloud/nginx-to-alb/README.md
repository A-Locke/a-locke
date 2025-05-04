
# n8n Deployment on AWS with ALB (Replacing NGINX)

This guide outlines how to migrate a Dockerized deployment of [n8n](https://n8n.io) on an EC2 instance from using NGINX as a reverse proxy to using an AWS Application Load Balancer (ALB) for TLS termination, routing, and health checks.

---

## Why Replace NGINX with ALB?

Using ALB instead of NGINX offers several advantages:

- **Managed Service**: ALB is fully managed, reducing operational overhead.
- **TLS Termination**: ALB integrates with AWS Certificate Manager (ACM) for easy HTTPS.
- **Scalability**: Works well with EC2 Auto Scaling and dynamic instances.
- **Health Checks**: Built-in health monitoring and failover.
- **Advanced Routing**: Supports host/path-based routing and redirects.
- **Security**: Integrates with AWS WAF and security groups.

---

## Architecture Changes

### Before (with NGINX):
```
Client → NGINX (port 443) → Docker (n8n on port 5678)
```

### After (with ALB):
```
Client → ALB (HTTPS:443) → EC2 (Dockerized n8n on port 5678)
```

---

## Migration Steps

### 1. **Deploy n8n in Docker**

```bash
docker run -p 5678:5678 n8nio/n8n
```

Or via `docker-compose.yml`:
```yaml
services:
  n8n:
    image: n8nio/n8n
    restart: always
    environment:
      - N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true
      - N8N_HOST=0.0.0.0
    ports:
      - "5678:5678"
    env_file:
      - .env
    volumes:
      - n8n_data:/home/node/.n8n

volumes:
  n8n_data:
```

Add to `.env`:
```env
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=supersecure123
N8N_HOST=0.0.0.0
N8N_PROTOCOL=https
WEBHOOK_URL=https://n8n.example.com
```

---

### 2. **Create ALB**
- Scheme: Internet-facing
- Listeners:
  - HTTP (80): Redirect to HTTPS (443)
  - HTTPS (443): Forward to target group

### 3. **Set Up Target Group**
- Type: Instance
- Protocol: HTTP
- Port: 5678
- Health check path: `/`
- Register the EC2 instance

### 4. **Configure ACM Certificate**
- Request public certificate for `n8n.example.com`
- Validate via DNS (strip trailing dots from CNAMEs if necessary)
- Attach to ALB HTTPS listener

### 5. **Update Security Groups**
- ALB SG:
  - Inbound: TCP 80, 443 from `0.0.0.0/0`
  - **Outbound: TCP 5678 to the EC2 security group** ✅
- EC2 SG:
  - Inbound: TCP 5678 from ALB SG

### 6. **Update DNS**
- Point `n8n.example.com` to the ALB DNS using a CNAME record

---

## Cleanup

### Remove NGINX (native install):
```bash
sudo systemctl stop nginx
sudo systemctl disable nginx
sudo apt remove nginx -y
sudo apt autoremove -y
```

### Remove NGINX from Compose (if it existed):
Delete the nginx section from `docker-compose.yml`.

---

## Possible Issues and Resolutions

### ❌ 503 Service Unavailable
- **Cause**: ALB has no healthy targets.
- **Fix**: Ensure the target group points to port `5678`, and the health check path returns 200.

### ❌ ACM Certificate Error / Browser "Not Secure"
- **Cause**: Accessing via ALB DNS instead of your domain.
- **Fix**: Use a custom domain name (e.g., `n8n.example.com`) that matches the ACM cert.

### ❌ ERR_CONNECTION_REFUSED
- **Cause**: ALB forwarding to port 80/443 that are no longer in use.
- **Fix**: Update target group to point to port `5678`.

### ❌ Target Health Check Timeout
- **Cause**: n8n app is slow to respond or port blocked.
- **Fix**: 
  - Add `N8N_HOST=0.0.0.0`
  - Ensure EC2 SG allows inbound 5678 from ALB SG
  - Increase health check timeout to 10s

---

## Final Verification

- ✅ `https://n8n.example.com` loads without errors
- ✅ ALB Target Group shows "Healthy"
- ✅ `.env` and `docker-compose.yml` configured with correct host and auth

You're now running a secure, scalable n8n setup fully managed behind AWS ALB without the need for NGINX. 

---
