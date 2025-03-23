# 🌍 DNS Configuration for n8n Portal

This guide explains how to configure DNS records so that your custom domain (e.g., `n8n.yourdomain.com`) correctly points to your AWS EC2 instance hosting the n8n application.

---

## ✅ Requirements

- A registered domain name (e.g., via Namecheap, GoDaddy, or Cloudflare)
- Access to your domain registrar’s DNS settings
- The public IPv4 address of your EC2 instance

---

## 🛠️ Steps to Configure DNS

### 1. Get Your EC2 Public IP Address

Log in to the [AWS Console](https://console.aws.amazon.com/), navigate to your EC2 instance, and copy the **Public IPv4 address** (e.g., `3.121.123.45`).

---

### 2. Create an A Record

Go to your domain registrar’s DNS management dashboard and create the following record:

| Type | Name  | Value (EC2 IP) | TTL     |
|------|-------|----------------|---------|
| A    | n8n   | 3.121.123.45   | Default |

**Details:**
- **Type:** `A`
- **Name / Host:** `n8n` (or `@` for root domain)
- **Value / Points to:** your EC2 public IP
- **TTL:** Leave as default (or ~30 minutes)

---

### 3. Verify DNS Propagation

Check propagation status using a tool like:

🔗 [https://www.whatsmydns.net/](https://www.whatsmydns.net/)

Look up your domain (e.g., `n8n.yourdomain.com`) and confirm that the IP resolves globally.

---

## 🧪 Test Your Setup

Once DNS has propagated, open your browser and navigate to:

```
http://n8n.yourdomain.com
```

If NGINX and n8n are set up correctly, you should see the n8n web interface.

---

## 🖼 Example Screenshot

![DNS Working Example](https://github.com/user-attachments/assets/26855223-98d1-4f06-a2a0-a90e5b5b21f4)
