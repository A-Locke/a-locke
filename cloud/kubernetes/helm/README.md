# Cluster Extraction & Helm Conversion - Summary Guide

This document summarizes the process for extracting existing Kubernetes resources from a cluster, cleaning them, and preparing them for Helm chart conversion. The focus is on achieving full cluster reproducibility suitable for CI/CD pipelines and open-source deployments (e.g., Oracle Free Tier).

---

## Chapters

### 1. Installing `kubectl-neat` by Compiling from Source

If pre-built Windows binaries are unavailable:

```bash
git clone https://github.com/itaysk/kubectl-neat.git
cd kubectl-neat
go build -o kubectl-neat.exe
```

Move `kubectl-neat.exe` to a folder in your `PATH` for global use.

Test:
```bash
kubectl neat --help
```

---

### 2. Generic Namespace Discovery

List all namespaces:
```bash
kubectl get ns
```

### Recommended Extraction Focus

| Namespace              | Action                          |
|-----------------------|----------------------------------|
| `n8n`                 | Extract all resources            |
| `postgres`            | Extract pgAdmin, confirm Helm for PostgreSQL |
| `cert-manager`        | Extract full YAML + CRDs         |
| `ingress-nginx`       | Already Helm-managed; extract only values.yaml |
| `kubernetes-dashboard`| Extract resources, convert to Helm |

### Skip Extraction for:
- `default` namespace (avoid deploying apps here)
- `kube-public`, `kube-system`, `kube-node-lease` (system-managed)

---

### 3. Generic Resource Extraction + Cleaning with `kubectl neat`

Example commands per namespace:

```bash
# Deployments
kubectl get deployment <name> -n <namespace> -o yaml | kubectl neat > <name>-deployment.yaml

# Services
kubectl get svc <name> -n <namespace> -o yaml | kubectl neat > <name>-service.yaml

# Ingresses
kubectl get ingress <name> -n <namespace> -o yaml | kubectl neat > <name>-ingress.yaml

# Secrets
kubectl get secret <name> -n <namespace> -o yaml | kubectl neat > <name>-secret.yaml

# ServiceAccounts, Roles, RoleBindings
kubectl get sa -n <namespace> -o yaml | kubectl neat > sa.yaml
kubectl get role,rolebinding -n <namespace> -o yaml | kubectl neat > role.yaml

# ClusterRoles and ClusterRoleBindings
kubectl get clusterrole <name> -o yaml | kubectl neat > clusterrole.yaml
kubectl get clusterrolebinding <name> -o yaml | kubectl neat > clusterrolebinding.yaml
```

For `cert-manager` also extract CRDs:
```bash
kubectl get crd <crd-name> -o yaml | kubectl neat > crd-<crd-name>.yaml
```

---

### 4. Helmify Process (Summary)

For each cleaned YAML:
```bash
helmify <resource-file>.yaml
```
Generates a Helm chart structure with:
- `Chart.yaml`
- `values.yaml`
- `templates/<resource>.yaml`

Review and customize templates and values as needed.

---

### 5. Cluster Reproducibility Goals

- Full Helm charts per namespace.
- Extract and version control relevant CRDs.
- Optional: umbrella Helm chart or Terraform for provisioning.
- Avoid manual deployments, use Helm for 1-click replication.

---
