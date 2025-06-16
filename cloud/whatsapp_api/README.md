
# WhatsApp Business API Setup for n8n Automation (Czech Republic)

This README guides you through the process of registering a WhatsApp Business Account and obtaining WhatsApp API access via Meta, specifically for use in **n8n automation workflows**. This setup assumes:

- Your company is based in the **Czech Republic** and has a valid **IČO** (Identifikační číslo osoby).
- You've deployed a public **one-page business website** using this template: [one-page-web-public](https://github.com/A-Locke/one-page-web-public).

---

## ✅ Requirements

Before proceeding, ensure you have the following:

1. **Valid IČO**: Registered in the Czech ARES registry.
2. **One-page website**: Hosted using [this template](https://github.com/A-Locke/one-page-web-public) and publicly accessible.
3. **Meta Business Account (Business Manager)**:
   - [Sign up here](https://business.facebook.com/)
   - Use your business email and address matching IČO records.
4. **Phone Number**: Not in use on WhatsApp, able to receive SMS or calls.
5. **Facebook Page** (optional but useful).
6. **n8n Instance**: Self-hosted or cloud version.

---

## 🧭 Step 1: Create Meta Business Account

1. Go to [Meta Business Manager](https://business.facebook.com/).
2. Click **"Create Account"** and follow the setup:
   - Business Name
   - Name & Business Email
   - Business Address (as per your IČO listing)
   - Website (link to your one-page site)

---

## 🧾 Step 2: Verify Your Business

While optional for some cases, **verification is highly recommended** for full API access and higher messaging limits:

1. In Business Manager, navigate to:  
   **Business Settings → Security Center → Business Verification**
2. Submit:
   - **Business Name** (must match IČO registry)
   - **Document**: Extract from ARES or other official registry
   - **Proof of Address**: Utility bill, tax document, etc.
3. **Domain Verification** (important for API usage):
   - Go to: **Business Settings → Brand Safety → Domains**
   - Add your domain and verify using **DNS TXT record** (recommended)

---

## 📞 Step 3: Create WhatsApp Business Account

1. In **Business Settings**:
   - Go to: **Accounts → WhatsApp Accounts**
   - Click **“Add”** and follow the wizard:
     - Select or create a **Business Account**
     - Enter your **display name**
     - Choose **category and description**
     - Add your **phone number** and verify it via SMS or voice call
2. Add the number to your WhatsApp Manager view.

---

## 🔑 Step 4: Get Meta WhatsApp API Access

To use the API in **n8n**, follow these steps:

### A. Create App in Meta for Developers
1. Go to: [https://developers.facebook.com/apps](https://developers.facebook.com/apps)
2. Click **“Create App”**, choose **"Business"** type.
3. Name the app and link it to your **Meta Business Account**.

### B. Add WhatsApp Product
1. Inside the app dashboard, click **"Add Product" → WhatsApp**.
2. Choose your verified WhatsApp Business Account.
3. You’ll be redirected to the **WhatsApp Business API** configuration page.

### C. Generate Access Token
1. Go to **WhatsApp > Getting Started**
2. Select your phone number.
3. Copy:
   - **Temporary Access Token** (expires in 23 hours)
   - **Phone Number ID**
   - **WhatsApp Business Account ID**

> ⚠️ **Permanent Token**: For production use, generate a **System User** and assign roles and token with `whatsapp_business_messaging` and `whatsapp_business_management` permissions.

Documentation: [Access Tokens Overview](https://developers.facebook.com/docs/graph-api/overview/access-tokens/)

---

## 🔗 Step 5: Connect WhatsApp API to n8n

In n8n, use the **HTTP Request** node or a community WhatsApp module:

### Minimal Example:
1. **Method**: `POST`
2. **URL**:  
   `https://graph.facebook.com/v19.0/<PHONE_NUMBER_ID>/messages`
3. **Headers**:
   ```json
   {
     "Authorization": "Bearer <ACCESS_TOKEN>",
     "Content-Type": "application/json"
   }
   ```
4. **Body (JSON)**:
   ```json
   {
     "messaging_product": "whatsapp",
     "to": "<recipient_phone_number>",
     "type": "text",
     "text": { "body": "Hello from n8n!" }
   }
   ```

### Optional:
- Add error-handling nodes, delay logic, or conditional flows.
- Store tokens securely using environment variables or n8n credential nodes.

---

## 📋 Naming & Compliance Guidelines

- **Display Name**: Must match your IČO-registered name or a verifiable brand.
- **Website**: Should include:
  - Contact details
  - Address (preferably Czech)
  - Optional: Privacy Policy

Refer to [Meta’s Display Name Guidelines](https://developers.facebook.com/docs/whatsapp/display-name/) for naming restrictions.

---

## 📚 Resources

- [WhatsApp Business Platform Docs](https://developers.facebook.com/docs/whatsapp/)
- [Meta Business Manager](https://business.facebook.com/)
- [n8n WhatsApp API Example](https://n8n.io/workflows/)
- [ARES – Czech Company Registry](https://wwwinfo.mfcr.cz/ares/ares.html)

---

## 📬 Support

- **Meta Support**: [Contact via Business Manager](https://business.facebook.com/)
- **n8n Support**: [n8n Community](https://community.n8n.io/)
