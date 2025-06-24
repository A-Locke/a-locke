
# ☁️ n8n Kubernetes Deployment with Redis, PostgreSQL, Ingress, and SSL on Oracle Cloud (OKE)

This guide documents the complete setup of **n8n in Queue Mode** with Redis, PostgreSQL (via Helm), and SSL-secured Ingress on Oracle Cloud's Free Tier Kubernetes (OKE) cluster. Includes planned improvements for production-readiness.

---

## ✅ Prerequisites

- Functional Oracle Cloud Free Tier account  
- OKE cluster with LoadBalancer (Ingress) support  
- Helm installed locally  
- `kubectl` configured to access your cluster  

---

## 🏗️ Full Setup Steps

### Step 0: Namespaces

```bash
kubectl create namespace n8n
kubectl create namespace postgres
```

---

### Step 1: Deploy Redis for Queue Mode

**File:** `k8s/n8n/redis-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: n8n
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis
          image: redis:6.2
          ports:
            - containerPort: 6379
---
apiVersion: v1
kind: Service
metadata:
  name: redis-service
  namespace: n8n
spec:
  ports:
    - port: 6379
      targetPort: 6379
  selector:
    app: redis
```

**Apply the deployment:**

```bash
kubectl apply -f .\k8s\n8n\redis-deployment.yaml
```

---

### Step 2: Deploy PostgreSQL with Helm

**Add Bitnami Helm repo:**

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

**Install PostgreSQL:**

```bash
helm install my-postgres bitnami/postgresql `
  --namespace postgres `
  --set auth.username=n8n `
  --set auth.password=strongpassword `
  --set auth.database=n8n `
  --set primary.persistence.size=8Gi
```

**Retrieve DB password:**

```bash
kubectl get secret --namespace postgres my-postgres -o jsonpath="{.data.password}" | base64 --decode
```

**Connection string format:**

```
postgresql://n8n:strongpassword@my-postgres-postgresql.postgres.svc.cluster.local:5432/n8n
```

---

### Step 3: Deploy n8n Main Pod (Queue Mode)

**File:** `k8s/n8n/n8n-main-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: n8n-main
  namespace: n8n
spec:
  replicas: 1
  selector:
    matchLabels:
      app: n8n-main
  template:
    metadata:
      labels:
        app: n8n-main
    spec:
      containers:
        - name: n8n
          image: n8nio/n8n:latest
          ports:
            - containerPort: 5678
          env:
            - name: DB_TYPE
              value: postgres
            - name: DB_POSTGRESDB_HOST
              value: my-postgres-postgresql.postgres.svc.cluster.local
            - name: DB_POSTGRESDB_PORT
              value: "5432"
            - name: DB_POSTGRESDB_DATABASE
              value: n8n
            - name: DB_POSTGRESDB_USER
              value: n8n
            - name: DB_POSTGRESDB_PASSWORD
              value: strongpassword
            - name: QUEUE_MODE_ENABLED
              value: "true"
            - name: N8N_REDIS_HOST
              value: redis-service
            - name: N8N_BASIC_AUTH_ACTIVE
              value: "true"
            - name: N8N_BASIC_AUTH_USER
              value: admin
            - name: N8N_BASIC_AUTH_PASSWORD
              value: adminpassword
---
apiVersion: v1
kind: Service
metadata:
  name: n8n-service
  namespace: n8n
spec:
  selector:
    app: n8n-main
  ports:
    - protocol: TCP
      port: 5678
      targetPort: 5678
```

**Apply the deployment:**

```bash
kubectl apply -f .\k8s\n8n\n8n-main-deployment.yaml
```

---

### Step 4: Deploy n8n Worker Pod

**File:** `k8s/n8n/n8n-worker-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: n8n-worker
  namespace: n8n
spec:
  replicas: 1
  selector:
    matchLabels:
      app: n8n-worker
  template:
    metadata:
      labels:
        app: n8n-worker
    spec:
      containers:
        - name: n8n
          image: n8nio/n8n:latest
          env:
            - name: N8N_EXECUTIONS_MODE
              value: queue
            - name: DB_TYPE
              value: postgres
            - name: DB_POSTGRESDB_HOST
              value: my-postgres-postgresql.postgres.svc.cluster.local
            - name: DB_POSTGRESDB_PORT
              value: "5432"
            - name: DB_POSTGRESDB_DATABASE
              value: n8n
            - name: DB_POSTGRESDB_USER
              value: n8n
            - name: DB_POSTGRESDB_PASSWORD
              value: strongpassword
            - name: QUEUE_MODE_ENABLED
              value: "true"
            - name: N8N_REDIS_HOST
              value: redis-service
```

**Apply the deployment:**

```bash
kubectl apply -f .\k8s\n8n\n8n-worker-deployment.yaml
```

---

### Step 5: Ingress and SSL Setup

**Install Ingress Controller with Helm:**

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx `
  --namespace ingress-nginx `
  --create-namespace `
  --version 4.12.3
```

---

### Step 6: Configure Ingress for n8n with SSL

**Example Ingress YAML:**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: n8n-ingress
  namespace: n8n
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - n8n.example.com
      secretName: n8n-tls-secret
  rules:
    - host: n8n.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: n8n-service
                port:
                  number: 5678
```

---

### Step 7: Deploy Cert-Manager and Obtain SSL

**Install Cert-Manager:**

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.yaml
```

**Example ClusterIssuer:**

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: your.email@example.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod-key
    solvers:
      - http01:
          ingress:
            class: nginx
```

**Apply Ingress configuration:**

```bash
kubectl apply -f .\k8s\ingress\n8n-ingress.yaml
```

*Certificate auto-generation will occur after DNS is set up.*

---

## 🔒 Planned Next Steps for Security & Production

- ✅ Provision dedicated Compute instance for VPN + DNS (e.g., WireGuard + BIND)  
- ✅ Restrict Kubernetes Dashboard access to VPN network only  
- ✅ Deploy pgAdmin to visualize PostgreSQL inside OKE, protected behind VPN  
- ✅ Migrate DNS to Cloudflare for better management and automation  
- ✅ Configure Cert-Manager for DNS-01 challenges with Cloudflare API  
- ✅ Package the full setup using Helm Charts for reproducible deployments  
- ✅ Implement Infrastructure as Code with Terraform to provision OKE, VCN, NAT, etc.  
- ✅ CI/CD pipeline with GitHub Actions to deploy changes to Helm/Terraform automatically  

---

## 🎯 Final Notes

This setup leverages Oracle Free Tier efficiently:

- **1 ARM VM** for general workloads (future VPN)  
- **1 AMD OKE cluster** running:  
    - n8n Main Pod  
    - n8n Worker Pod  
    - Redis  
    - PostgreSQL (Bitnami Helm)  
    - Ingress NGINX with SSL (cert-manager)  

> **Webhooks remain exposed via Ingress, while admin tools will be VPN-restricted.**
