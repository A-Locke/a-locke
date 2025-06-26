# Splitting n8n Between Admin Plane and Webhook Plane (Oracle Cloud, Kubernetes)

## **Objective**
To securely separate the n8n Admin UI and webhook processing endpoints in an Oracle Cloud (OCI) environment with Kubernetes and VPN, ensuring:

✅ The Admin UI is only accessible via VPN (private access).  
✅ Public webhooks remain accessible for integrations (APIs, webhooks, etc.).  
✅ TLS certificates are issued via Let's Encrypt using DNS-01 challenges with Cloudflare.  

---

## **Why Split n8n Admin and Webhook Planes?**
- Prevent Admin UI exposure to the public internet.  
- Allow only VPN users to access workflow design and credentials.  
- Keep webhook endpoints reachable publicly for real-time integrations.  
- Reduce attack surface while maintaining operational flexibility.  

---

## **Deployment Overview**
- **n8n** deployed in Kubernetes (OKE).  
- **VPN server** provides internal DNS resolution for admin domains.  
- **Cloudflare** manages public DNS, proxy, and TLS issuance with DNS-01.  
- **Cert-Manager** handles automatic certificate management.  
- Two domains:
  - `n8n-admin.your.domain` → Admin UI (VPN-only access).
  - `n8n-webhook.your.domain` → Public webhook endpoint.

---

## **Step-by-Step Implementation Guide**

### **1. Configure n8n Environment Variables**
In the Kubernetes `Deployment` for n8n:
```yaml
- name: N8N_EDITOR_BASE_URL
  value: "https://n8n-admin.your.domain"
- name: WEBHOOK_URL
  value: "https://n8n-webhook.your.domain"
```
Restart the deployment:
```bash
kubectl rollout restart deployment n8n-main -n n8n
```

### **2. VPN DNS Resolver Configuration**
On your VPN server (`dnsmasq` config):
```ini
interface=wg0
listen-address=10.10.10.1
bind-interfaces
domain=your.domain
address=/n8n-admin.your.domain/89.168.109.121
```
This resolves `n8n-admin.your.domain` to the public Load Balancer IP but is only accessible from VPN clients.

### **3. Ingress Separation**
#### Admin Ingress:
```yaml
annotations:
  cert-manager.io/cluster-issuer: letsencrypt-cloudflare
  nginx.ingress.kubernetes.io/whitelist-source-range: 10.0.30.0/24,10.0.10.0/24
```
- Only VPN subnets can reach Admin UI.

#### Webhook Ingress:
```yaml
annotations:
  cert-manager.io/cluster-issuer: letsencrypt-cloudflare
```
- Public webhook endpoint remains accessible.
- Cloudflare proxy stays enabled for DDoS protection.

### **4. DNS-01 Certificate Issuance with Cloudflare**
#### Cloudflare API Token:
```bash
kubectl create secret generic cloudflare-api-token-secret \
  --from-literal=api-token=<YOUR_CLOUDFLARE_API_TOKEN> -n cert-manager
```

#### ClusterIssuer for Let's Encrypt DNS-01:
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-cloudflare
spec:
  acme:
    email: your.email@domain
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-cloudflare-key
    solvers:
    - dns01:
        cloudflare:
          apiTokenSecretRef:
            name: cloudflare-api-token-secret
            key: api-token
```

#### Certificates for Both Domains:
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: n8n-admin-cert
  namespace: n8n
spec:
  secretName: n8n-admin-tls
  issuerRef:
    name: letsencrypt-cloudflare
    kind: ClusterIssuer
  commonName: n8n-admin.your.domain
  dnsNames:
  - n8n-admin.your.domain
```
And similarly for `n8n-webhook.your.domain`.

Cert-manager will handle DNS-01 validation and automatic renewal.

### **5. Final Testing**
✅ Admin UI only resolves within VPN.  
✅ Webhooks reachable publicly.  
✅ Valid Let's Encrypt certificates in use.  
✅ Separation confirmed in n8n UI — production webhooks use `n8n-webhook.your.domain`.

---

## **Issues Encountered During Setup**
- **HTTP-01 certificate issuance failed** due to:
  - Cloudflare proxy interfering with port 80 HTTP-01 validation.
  - Load Balancer port 80 restrictions.
- Solution: Switched entirely to DNS-01 validation via Cloudflare API.

- **Environment variables not initially applied** — required pod restart after deployment updates.

- **n8n UI Test URL confusion** — test URLs always reflect the Admin domain, while production URLs follow `WEBHOOK_URL` — this is intended n8n behavior.

---

## **Conclusion**
This approach:
- Provides clear separation of n8n's Admin and operational planes.
- Maintains security via VPN and Cloudflare.
- Supports reliable certificate management using DNS-01.
- Ensures public services function without compromising internal access control.

> Recommended for anyone running n8n in a production environment requiring both public integrations and secure administrative access.
