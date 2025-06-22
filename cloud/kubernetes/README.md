# n8n on Oracle Kubernetes Engine (OKE) - Setup Guide

This guide documents the setup process of an OKE (Oracle Kubernetes Engine) cluster to deploy **n8n**, from initial design decisions to the point of setting up the Kubernetes Dashboard for internal use.

---

## 🧩 Choosing n8n Mode: Normal vs. Queue

| Feature                      | Normal Mode                   | Queue Mode                              |
|-----------------------------|-------------------------------|------------------------------------------|
| Execution Architecture      | All in one pod (webhook, UI, execution) | Webhook/UI in one pod, execution in workers |
| Scalability                 | Limited (1 pod)               | Horizontally scalable workers            |
| External Communication      | Full access                   | Workers can reach APIs directly          |
| Message Queue Required      | ❌                            | ✅ (e.g., Redis)                          |
| Load Handling               | Light to Medium               | Medium to Heavy                          |
| Best Use Case               | Prototypes, small projects    | Workflows triggered concurrently or via external input (e.g., chatbots) |

---

## 🏠 Docker Compose vs. Kubernetes (OKE)

| Feature              | Docker Compose (Single Host) | Kubernetes (OKE Cluster)             |
|---------------------|-------------------------------|--------------------------------------|
| Deployment Type     | Local / single VM             | Managed, scalable cluster            |
| High Availability   | ❌                            | ✅                                   |
| Auto-scaling        | ❌                            | ✅                                   |
| Traffic Routing     | Manual                        | Ingress controller, LoadBalancer     |
| Cost                | Low, simple                   | Slightly higher, scalable, Free Tier |

---

## ☁️ Why Oracle Cloud Free Tier Works For Us

Oracle offers:
- **4 OCPUs + 24GB RAM** Always Free.
- **Managed Kubernetes (OKE)** included in Free Tier.
- Persistent **Block Volumes**, **Object Storage**, and **Load Balancers**.
- Enough resources to host:
  - A minimal OKE cluster.
  - n8n webhook pod and worker pods.
  - Supporting services (Redis, PostgreSQL).

It’s a great choice for hobby projects, startups, or proof-of-concept chatbot/game backends.

---

## 🔹 Oracle Cloud Kubernetes Cluster

### Steps:
1. Create free Oracle Cloud account
2. Go to **Developer Services → Kubernetes Clusters (OKE)** > Quick Create
3. Configure Cluster Basics
| Field                  | Suggested Value                                 |
| ---------------------- | ----------------------------------------------- |
| **Name**               | `n8n-cluster`                                   |
| **Kubernetes Version** | Choose latest stable (e.g., 1v1.33.1 (latest))       |
| **Compartment**        | Same as your VCN (e.g., `(root)`) |
| **VCN**                | Select your configured VCN                      |
| **Subnets**            | Pick your public subnet(s) from dropdown        |

💡 4. Node Pool Configuration

This defines the VM workers that will run your workloads.
| Field              | Suggested Value                                            |
| ------------------ | ---------------------------------------------------------- |
| **Node Pool Name** | `n8n-node-pool`                                            |
| **Shape**          | `VM.Standard.A1.Flex` (ARM-based — eligible for free tier) |
| **OCPUs**          | `1`                                                        |
| **Memory (GB)**    | `6`                                                        |
| **Node Count**     | Start with `1`                                             |


✅ Leave OS Image as default (Oracle Linux)

✅ Make sure Public IP Address Assignment is enabled (optional but useful for first setup/debugging)
5. Access & Authentication

Keep RBAC and Kubeconfig options enabled:

    Oracle will generate the kubeconfig file you’ll need for kubectl access.

    You can download it after the cluster is created.

🛠6. Create the Cluster

Click Create Cluster at the bottom of the page.

🚀 Provisioning takes ~10–15 minutes. The cluster status will show “Creating” until ready.

🚨 Possible issue

Out of host capacity means Oracle Cloud Infrastructure (OCI) does not currently have enough available hardware resources in the selected Availability Domain (AD) within the Frankfurt (eu-frankfurt-1) region to fulfill your request — most likely due to limited Free Tier-compatible VM shapes like VM.Standard.A1.Flex being over-utilized.

This is not a bug in your setup — it is a common limitation with always-free or heavily subscribed shapes.

If that happens:

    Try different Availability Domains.

    Attempt deployment during off-peak hours.
	
	Consider switching to Pay As You Go mode instead of Free Tier(set up a Budget to notify you if any costs are incurred)

---

## 🔧 Installing OCI CLI (MSI Method)

Install OCI CLI using the official MSI installer:

1. Download: [OCI CLI MSI Installer](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
2. Run the installer with default settings.
3. After install, run:
   ```powershell
   oci --version
   ```

---

## 🔐 Setting Up kubeconfig

After the cluster is created via OKE wizard:

```powershell
oci ce cluster create-kubeconfig `
  --cluster-id <your-cluster-ocid> `
  --file "C:\Users\<user>\.kube\config" `
  --region <your-region> `
  --token-version 2.0.0 `
  --kube-endpoint PUBLIC_ENDPOINT
```

Then verify cluster access:
```bash
kubectl get nodes
```

If nodes are listed and status is `Ready`, your cluster is accessible.

---

## 🧭 Installing the Kubernetes Dashboard (Internal Only)

We opted for an internal-only dashboard (not exposed via Ingress):

1. Apply the official dashboard manifests:
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
   ```

2. Access it locally with:
   ```bash
   kubectl proxy
   ```

   Then open: [http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

3. To generate a login token:
   ```bash
   kubectl -n kubernetes-dashboard create token kubernetes-dashboard
   ```

4. Use that token to log in.

Dashboard is currently internal only. Ingress and OAuth2 Proxy setup will follow in future steps.

---


## ✅ Summary

- We chose **queue mode** for scalable, decoupled workflow execution.
- Deployed OKE cluster using Oracle Free Tier.
- Installed and configured `oci` CLI and `kubectl` access.
- Deployed the **Kubernetes Dashboard**, accessed via local proxy for now.
