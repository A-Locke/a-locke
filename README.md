# 👋 Hi there, I'm Arthur Locke.

# Welcome to my Project Hub!

[![Connect on
LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/arthur-locke/)

------------------------------------------------------------------------

## 🧭 Objective

This repository documents my **hands-on learning journey** in
**Cybersecurity**, **Cloud Computing**, and **Artificial Intelligence**.

Each project represents applied learning --- taking concepts from
documentation, courses, and certifications and implementing them in real
environments.

The goal is to build a portfolio that demonstrates:

-   real infrastructure deployment
-   secure system design
-   automation and CI/CD
-   AI‑augmented engineering workflows

------------------------------------------------------------------------

# 🌟 Featured Projects

## 🤖 AI‑Augmented QA Automation

### [AI Agentic QA --- Playwright Planner → Generator → Healer](https://github.com/A-Locke/ai-agentic-qa-saucedemo)

A project exploring **AI‑assisted QA automation workflows** using
**Playwright + Claude Code**.

This experiment demonstrates how an AI‑driven pipeline can transform a
**Product Requirements Document (PRD)** into a working Playwright test
suite and maintain it when UI changes occur.

Workflow demonstrated:

-   **Planner Agent** → converts a PRD into a structured test plan
-   **Generator Agent** → produces deterministic Playwright tests
-   **Healer Agent** → repairs failing tests caused by simulated UI
    drift

Highlights:

-   Playwright test suite for the **SauceDemo** demo application
-   Simulated locator drift and AI‑assisted repair
-   Version‑controlled workflow separating **stable automation
    (`main`)** from **experimental healing scenarios**
-   Real debugging examples (test ID mismatch and brittle currency
    assertions)

Future phase:

Converting the suite into **Playwright CLI playbooks** for agent‑driven
browser execution.

------------------------------------------------------------------------

## ☁️ OCI Infrastructure Pipeline — Production K8s on Free Tier

### [OCI Infra Pipeline](https://github.com/A-Locke/n8n_kubernetes)

A **fully automated GitHub Actions CI/CD pipeline** that provisions, configures, and tears down a **production-grade Kubernetes cluster on Oracle Cloud Free Tier** — $0/month vs $250+ on AWS EKS.

**Infrastructure as Code stack:** Terraform (OKE cluster, VCN, compute, storage) + Ansible (VPN provisioning, DNS configuration) + Helm (application lifecycle).

**Security model:** All workloads are VPN-only. A WireGuard server on a free AMD instance acts as the sole ingress path for n8n, pgAdmin, and Grafana. TLS certificates are issued via cert-manager with Cloudflare DNS-01 challenge — no public exposure of services or challenge endpoints.

**Kubernetes hardening applied per workload:**
- RBAC with least-privilege service accounts
- NetworkPolicy (default-deny, explicit allow)
- HPA with CPU autoscaling (metrics-server)
- ResourceQuota + LimitRange per namespace
- PodDisruptionBudget for n8n workers

**Applications deployed:**

| App | Notes |
|---|---|
| n8n v2 | Queue mode — webhook listener + workers backed by Valkey |
| PostgreSQL | StatefulSet with block volume persistence |
| pgAdmin | Database management, VPN-only |
| Prometheus + Grafana | kube-prometheus-stack, emptyDir (stays within Always Free storage cap) |
| Cert-Manager + Ingress-Nginx | Wildcard TLS via Cloudflare DNS-01 |

**AI tooling included:**
- 5 Claude Code skills (`/k8s-status`, `/k8s-debug`, `/k8s-scale`, `/k8s-cost`, `/n8n-queue`) for conversational cluster ops
- Claude Desktop Kubernetes MCP integration guide for natural-language cluster management

------------------------------------------------------------------------

## 🌐 Professional One‑Page Website Template

### [Next.js One‑Page Template](https://github.com/A-Locke/one-page-web-public)

A clean, open‑source **Next.js 15 single‑page website template** for
professionals.

Features:

-   Configurable personal branding
-   Dynamic Credly badge integration
-   Business information footer
-   Tailwind CSS v4 + shadcn/ui components
-   Ready‑to‑deploy configuration for Vercel

------------------------------------------------------------------------

# 🛠️ Skills & Projects

  ---------------------------------------------------------------------------------------------------------
  Skill / Topic                                  Project
  ---------------------------------------------- ----------------------------------------------------------
  AWS EC2 n8n                                    [Deploy n8n to EC2 via Docker](./cloud/aws-n8n)

  AWS IAM, S3, Lambda                            [AWS n8n Add-Ons
                                                 Project](./cloud/aws-n8n-addons/README.md)

  AWS Secrets Manager and Docker                 [AWS Secrets Manager and
                                                 Docker](./cloud/aws-secrets-manager/README.md)

  GitHub Actions + EC2 Deployment                [Automated GitHub to EC2
                                                 Deploy](./cloud/aws-n8n-git/README.md)

  S3 Backups for EC2 Applications                [n8n Backup to S3](./cloud/aws-s3-backup/README.md)

  AI Chatbot persistent memory via Supabase      [Supabase n8n
                                                 Memory](./cloud/n8n-supabase-memory/README.md)

  Next.js frontend, auth and deployment via      [Next.js
  Vercel                                         frontend](./cloud/aws-n8n/nextjs-frontend/README.md)

  n8n RAG using Supabase Vector DB               [n8n RAG](./cloud/n8n-RAG/README.md)

  Migrating from nginx reverse proxy to AWS ALB  [nginx to ALB](./cloud/nginx-to-alb)

  Securing n8n webhooks with header auth         [header webhook auth](./cloud/n8n-webhook-security)

  AWS WAF and logging                            [WAF and logging](./cloud/aws-waf-and-logging)

  WhatsApp Business API Setup for n8n            [WhatsApp API](./cloud/whatsapp_api)

  Kubernetes cluster on Oracle Free Tier (pt1)   [Kubernetes cluster](./cloud/kubernetes/README.md)

  Kubernetes cluster on Oracle Free Tier (pt2)   [n8n deployment in k8s](./cloud/kubernetes/n8n-deployment)

  VPN for Kubernetes dashboards                  [VPN in k8s](./cloud/kubernetes/VPN/README.md)

  DNS‑01 certificates for private dashboards     [DNS‑01 setup](./cloud/kubernetes/dashboard/README.md)

  Splitting public/private n8n resources         [Admin
                                                 privacy](./cloud/kubernetes/n8n-admin-privacy/README.md)

  Kubernetes dashboard access                    [Dashboard
                                                 login](./cloud/kubernetes/dashboard/access/README.md)

  Kubernetes resources extraction for Helm       [Kubernetes → Helm](./cloud/kubernetes/helm/README.md)

  Kubernetes node pool migration                 [Node pool migration](./cloud/kubernetes/costs/README.md)

  Kubernetes context switching aliases           [Context alias](./cloud/kubernetes/context)
  ---------------------------------------------------------------------------------------------------------

> 📝 This table expands as new projects are completed.

------------------------------------------------------------------------

# 🧪 Certifications

[![ISC2
CC](https://images.credly.com/size/340x340/images/e98395d6-e705-430a-98d8-9bfbadbf97f2/image.png)](https://www.credly.com/badges/2054310e-e8ff-4b2d-8fa7-ab33a975c32c/linked_in?t=st7jq3)

[![Oracle Cloud Infrastructure 2025 Certified Foundations
Associate](https://github.com/user-attachments/assets/27a6991e-13f2-4479-8940-d7a2222673f5)](https://catalog-education.oracle.com/ords/certview/sharebadge?id=048F0DCA9846D6E18D3F09CE0CD4104D953BFB952FFBF4705F688C8ADDA65020)

------------------------------------------------------------------------

> 🚧 This repository is a living portfolio and evolves as new projects
> are completed and new technologies are explored.
