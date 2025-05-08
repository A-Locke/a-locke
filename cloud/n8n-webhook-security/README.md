# Securing n8n Webhooks with Custom Headers

This guide explains how to secure n8n webhooks using custom HTTP headers, and how to integrate that security across your **n8n workflow**, **frontend application**, and **Vercel deployment**.

---

## Why Secure Webhooks?

Webhooks exposed publicly (e.g. `https://n8n.your.address/webhook/chat`) can be:

* Discovered via scraping
* Triggered by malicious actors or bots
* Exploited to drain API tokens ("denial of wallet")

Using a custom HTTP header adds an extra layer of defense without needing full token-based auth.

---

## Step 1: Secure the n8n Webhook Node

In your **Webhook Trigger node**, select the `Header Auth` method:

![Screenshot_10](https://github.com/user-attachments/assets/fee7fc79-d586-4afd-a981-a18551dcee27)


Configure it like this:

* **Authentication**: Header Auth
* **Header Name**: `x-n8n-access`
* **Header Value**: `secure-key-abc123`

This tells n8n to **reject any request** that doesn’t include this exact header and value.

---

## Step 2: Store Header Info in Vercel

In your Vercel project:

1. Go to **Project → Settings → Environment Variables**
2. Add the following:

| Name                   | Value                               | Environment |
| ---------------------- | ----------------------------------- | ----------- |
| `N8N_API_HEADER_NAME`  | `x-n8n-access`                      | All         |
| `N8N_API_HEADER_VALUE` | `secure-key-abc123`                 | All         |
| `N8N_WEBHOOK_URL`      | `https://n8n.n8n.your.address/webhook/chat` | All         |

3. Redeploy your frontend project so the environment variables are available.

---

## Step 3: Call n8n Securely From Your Frontend

Here is an excerpt from your **`route.ts`** (Next.js App Router backend API route), demonstrating how the webhook is called securely:

```ts
const headerName = process.env.N8N_API_HEADER_NAME;
const headerValue = process.env.N8N_API_HEADER_VALUE;

const headers: Record<string, string> = {
  'Content-Type': 'application/json',
};

if (headerName && headerValue) {
  headers[headerName] = headerValue;
}

const n8nResponse = await fetch(process.env.N8N_WEBHOOK_URL!, {
  method: 'POST',
  headers,
  body: JSON.stringify(n8nPayload),
  signal: controller.signal
});
```

This ensures:

* The secret header name and value are never hard-coded
* Only authorized requests (from your app) are accepted by the n8n webhook

---

## Summary

| Layer        | Responsibility                            |
| ------------ | ----------------------------------------- |
| **n8n**      | Validates custom header for access        |
| **Vercel**   | Stores header name/value securely         |
| **Frontend** | Reads headers from env, sends them to n8n |

With this setup:

* Your webhook is still fast and stateless
* You get lightweight access control without OAuth complexity
* Security can be upgraded later (e.g., to JWTs or API Gateway)

---

## Optional Enhancements

* Rotate the key periodically in Vercel
* Obfuscate the webhook path (`/webhook/ai-gen-x9a3bc`)
* Add WAF rate limiting to ALB for additional protection
