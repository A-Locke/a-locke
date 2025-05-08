# Adding WAF Protection and Logging to Your AWS ALB for n8n

This guide walks you through creating an AWS WAF Web ACL with rate limiting and enabling CloudWatch logging for monitoring and security auditing. It is specifically tailored to use with an Application Load Balancer (ALB) hosting an n8n instance.

---

## 🛡️ Step 1: Create a WAF Web ACL

1. Go to **AWS Console → WAF & Shield**
2. Click **Web ACLs → Create web ACL**

### Configuration:

* **Name**: `n8n-webhook-waf`
* **Region**: Same as your ALB (e.g. `eu-north-1`)
* **Resource type**: `Application Load Balancer`
* **Associated resource**: Select your ALB (e.g. `n8n-alb`)

---

## 🚦 Step 2: Add a Rate-Limiting Rule

Click **Add rules → Add my own rules**

### Rule setup:

* **Name**: `rate-limit`
* **Type**: `Rate-based rule`
* **Limit**: `100`
* **Aggregate key**: `IP`
* **Evaluation window**: 300 seconds (5 minutes)
* **Action**: `Block`

Enable visibility config:

```json
{
  "SampledRequestsEnabled": true,
  "CloudWatchMetricsEnabled": true,
  "MetricName": "rate-limit"
}
```

---

## 📜 Step 3: Create a CloudWatch Log Group

1. Go to **CloudWatch → Log groups → Create log group**
2. Use a name that starts with:

   ```
   aws-waf-logs-
   ```

   Example:

   ```
   aws-waf-logs-n8n-webhook
   ```
3. Ensure it's in the **same region** as your Web ACL
4. Set a **retention period** (e.g., 7 or 30 days)

---

## 📊 Step 4: Enable Logging for WAF

1. Return to **WAF → Your Web ACL → Logging and metrics tab**
2. Click **Edit logging configuration**
3. Select the log group you just created

   > If it doesn’t appear, make sure it follows the naming convention `aws-waf-logs-*`
4. Enable:

   * CloudWatch Metrics ✅
   * Sampled Requests ✅

---

## 🧪 Testing

Use `curl` to simulate traffic:

```bash
for i in {1..120}; do curl -s -o /dev/null -w "%{http_code} " https://n8n.locke.cz/webhook/chat; done
```

* After \~100 requests, your IP should get `403` responses
* Logs will appear in CloudWatch under `/aws/waf/logs/n8n-webhook`

---

## 📈 (Optional) Create CloudWatch Insights Dashboard

Example query:

```sql
fields @timestamp, httpRequest.clientIp, httpRequest.uri, terminatingRuleId
| filter terminatingRuleId = "rate-limit"
| sort @timestamp desc
```

This shows who triggered the rate limit and when.

---

## ✅ Summary

* 🔒 WAF blocks abusive traffic before it hits n8n
* 📉 Logs give visibility into suspicious patterns
* 🧰 Setup is low-maintenance and can scale with you

Want to add country blocking or header validation? Just add another rule to your Web ACL.
