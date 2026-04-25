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

## ☸️ Kubernetes CKA Training Platform with AI Agent Solver

### [kube-dojo — CKA Prep + AI Solver](https://github.com/A-Locke/kube-dojo)

A **local Kubernetes training platform** for CKA exam preparation, with a built-in AI agent solver that thinks out loud at every step.

Each task injects a **real broken Kubernetes state** into a local `kind` cluster — misconfigured Services, bad images, missing RBAC, stuck PVCs, scheduling taints — and verifies the fix deterministically.

Modes:

-   **Human mode** → read the prompt, diagnose and fix with `kubectl`
-   **AI solver mode** → local Claude Code agent solves the task, explaining every command before running it and interpreting output after
-   **Task generation** → `/generate-task` command designs, writes, and live-tests a complete new scenario from a one-line description

Highlights:

-   5/5 tasks solved autonomously by the local AI agent in a single suite run
-   Deterministic `verify.sh` per task — no fuzzy grading, just pass or fail
-   **Killercoda integration** — scenarios published to [`kube-dojo-scenarios`](https://github.com/A-Locke/kube-dojo-scenarios), playable in a browser with zero local setup
-   Dual-backend architecture separating cluster provisioning from task logic

Stack: `kind` · `kubectl` · Bash · Python · PowerShell · Claude Code

------------------------------------------------------------------------

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

## 🔍 OpenAPI Contract Testing & AI Drift Detection

### [SpecGuard — OpenAPI Contract Testing Platform](https://github.com/A-Locke/OpenAPI)

A **contract-first OpenAPI testing platform** built as a TypeScript pnpm monorepo (9 packages/apps) — contract runner CLI, drift detection engine, AI semantic analyzer, MCP server, wrapper API, mock server, and shared packages.

Wraps the **Apify TikTok Scraper** Actor: the internal OpenAPI spec is the product contract; the upstream spec is the vendor reference. The platform continuously validates the wrapper against both.

**What it does:**

- **Contract runner** executes HTTP requests against the live wrapper API, validates each response against the internal OpenAPI spec using AJV, and produces structured pass/fail/warn/error reports — distinguishing transport errors, upstream drift, wrapper violations, and assertion failures
- **Drift engine** (`drift-core`) performs structural diff between the upstream Apify spec and the internal contract, surfacing breaking changes before they reach production
- **AI semantic analysis** (`ai-drift-analyzer`) calls `claude-sonnet-4-6` with **prompt caching** — the static spec is pinned in cache, only the drift delta is sent per run — to produce severity classifications and remediation suggestions on top of raw structural diffs
- **AI test generation** (`--ai-test-gen`) generates additional edge-case `TestCase` objects from the internal spec at runtime and merges them with spec-driven tests; breakdown logged per source
- **MCP server** (4 tools) exposes raw spec content, drift reports, and test inputs for the host Claude to reason over — **no API key required**; tools are pure data providers

**Verified results (CI artifact, 2026-04-18):**

| Metric | Result |
|---|---|
| Unit tests | 24 / 24 passing |
| Contract tests | 8 / 8 passing |
| Contract violations | 0 |
| CI pipeline | type-check → unit tests → Docker build → live contract run |

**Stack:** TypeScript strict, Fastify, Zod (boundary parsing), AJV (OpenAPI schema validation), undici, Vitest, Docker multi-stage (`node:20-alpine`), GitHub Actions CI.

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
  OpenAPI contract testing, drift detection, AI   [SpecGuard](https://github.com/A-Locke/OpenAPI)

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
