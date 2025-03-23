# 🔐 Setting Up SSL with Let's Encrypt (Certbot)

This guide explains how to secure your `n8n.yourdomain.com` portal with HTTPS using a free SSL certificate from Let's Encrypt via **Certbot**.

---

## 📦 Requirements

- A valid domain name (with an A record pointing to your EC2 instance)
- NGINX installed and running on port 80
- Certbot available on your server

---

## ⚙️ Install Certbot

Update your packages and install Certbot with NGINX support:

```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
```

---

## 🧪 Test NGINX Configuration (Before SSL)

Ensure NGINX is running and the config is valid:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Confirm that your site is accessible via:

```
http://n8n.yourdomain.com
```

---

## 🚀 Request an SSL Certificate

Run the following Certbot command:

```bash
sudo certbot --nginx -d n8n.yourdomain.com
```

Certbot will:

- Validate your domain via HTTP
- Edit your NGINX config to include SSL
- Reload NGINX with HTTPS enabled

---

## 🔁 Automatic Renewal

Certbot automatically sets up a systemd timer for renewal.

You can manually test auto-renewal with:

```bash
sudo certbot renew --dry-run
```

---

## ✅ Test SSL Setup

Open a browser and go to:

```
https://n8n.yourdomain.com
```

You should see:

- A secure lock icon in the browser
- A valid SSL certificate

---

## 🖼 Example Screenshot

![SSL Success Screenshot](https://github.com/user-attachments/assets/66d65010-4053-423a-b0e2-4843ef12f1d3)
