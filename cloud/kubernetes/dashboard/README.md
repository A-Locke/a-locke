
# Secure Kubernetes Dashboard with Cloudflare & Let's Encrypt (DNS-01)

This guide outlines the process to:
- Migrate your domain DNS to Cloudflare
- Automate trusted certificate issuance for the Kubernetes Dashboard using Let's Encrypt with DNS-01 challenges

## ✅ Prerequisites
- Control of your domain (e.g., locke.cz)
- Access to your domain registrar
- Access to your Kubernetes cluster with NGINX Ingress installed
- Cert-Manager installed (https://cert-manager.io/docs/installation/)

---

## 🛠 Step 1: Move DNS to Cloudflare

1. Sign up at [https://cloudflare.com](https://cloudflare.com)
2. Add your domain (e.g., locke.cz)
3. Cloudflare will scan your existing DNS records
4. Update your domain registrar's nameservers to Cloudflare's provided servers
5. Wait for DNS propagation (typically <24h)

---

## 🛠 Step 2: Create Cloudflare API Token

1. Log in to Cloudflare Dashboard
2. Go to **My Profile → API Tokens**
3. Create a token with:
   - Zone → DNS → Edit
   - Zone → Zone → Read
4. Scope token to your `locke.cz` domain
5. Save the token securely

---

## 🛠 Step 3: Store Cloudflare API Token in Kubernetes

```
kubectl create secret generic cloudflare-api-token-secret \
  --from-literal=api-token=<YOUR_CLOUDFLARE_API_TOKEN> \
  -n cert-manager
```

---

## 🛠 Step 4: Create ClusterIssuer for Let's Encrypt

**clusterissuer.yaml**

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-cloudflare
spec:
  acme:
    email: your.email@example.com
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

```
kubectl apply -f clusterissuer.yaml
```

---

## 🛠 Step 5: Request Certificate for Dashboard

**dashboard-cert.yaml**

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: dashboard-cert
  namespace: kubernetes-dashboard
spec:
  secretName: dashboard-tls
  issuerRef:
    name: letsencrypt-cloudflare
    kind: ClusterIssuer
  commonName: dashboard.locke.cz
  dnsNames:
  - dashboard.locke.cz
```

```
kubectl apply -f dashboard-cert.yaml
```

Cert-Manager will automatically manage DNS-01 challenges via Cloudflare API.

---

## 🛠 Step 6: Configure Ingress for Dashboard

**dashboard-ingress.yaml**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-cloudflare
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  rules:
  - host: dashboard.locke.cz
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kubernetes-dashboard
            port:
              number: 443
  tls:
  - hosts:
    - dashboard.locke.cz
    secretName: dashboard-tls
```

```
kubectl apply -f dashboard-ingress.yaml
```

---

# 🎉 Result

✔ Your Kubernetes Dashboard is available at `https://dashboard.locke.cz`  
✔ Fully trusted Let's Encrypt certificate via DNS-01  
✔ Automatic certificate renewal handled by Cert-Manager  

