# Kubernetes Context Switching on Oracle Cloud Infrastructure (OCI)

This guide explains how to manage multiple Kubernetes clusters in the same OCI region using PowerShell, including how to configure kubeconfig entries, switch between contexts, and define convenient aliases. It also documents common issues and how to resolve them.

---

## 📍 Scenario

Assume two Kubernetes clusters are deployed in the same OCI region:
- One in the **root** compartment
- One in the **root/infrastructure** compartment

Use distinct **contexts** in your kubeconfig file to ensure `kubectl` commands target the intended cluster.

---

## 🧰 Prerequisites

- `oci` CLI installed and configured
- `kubectl` installed
- OCID for each cluster obtained from the OCI Console

---

## ⚙️ Step 1: Add Clusters to kubeconfig (PowerShell)

Run the following command for each cluster to add its configuration:

```powershell
oci ce cluster create-kubeconfig `
  --cluster-id <cluster-ocid> `
  --region <region> `
  --file $HOME\.kube\config `
  --token-version 2.0.0 `
  --kube-endpoint PUBLIC_ENDPOINT `
  --merge
```

> Replace `<cluster-ocid>` with the OCID retrieved from the OCI Console.

The `--merge` flag ensures multiple clusters can coexist in the same config.

---

## 🔄 Step 2: Switch Between Contexts

List available contexts:

```powershell
kubectl config get-contexts
```

Switch context to the desired cluster:

```powershell
kubectl config use-context context-crpwglvkoxq   # Infra cluster
kubectl config use-context context-ci7fmrl6jya   # Root cluster
```

Verify active context:

```powershell
kubectl config current-context
```

---

## 💡 Step 3: Define PowerShell Aliases

### 1. Create PowerShell Profile (if it doesn't exist)

Check or create the profile:

```powershell
New-Item -ItemType File -Path $PROFILE -Force
```

Open it for editing:

```powershell
notepad $PROFILE
```

### 2. Add Context Functions and Aliases

```powershell
function Set-KubeInfra {
    kubectl config use-context context-crpwglvkoxq
    kubectl config current-context
}

function Set-KubeRoot {
    kubectl config use-context context-ci7fmrl6jya
    kubectl config current-context
}

Set-Alias kinfra Set-KubeInfra
Set-Alias kroot Set-KubeRoot
```

Save and reload your profile:

```powershell
. $PROFILE
```

Now run `kroot` or `kinfra` to switch clusters quickly.

---

## 🐞 Common Issues

### ❌ PowerShell Profile Not Found

**Symptom:**  
Running `notepad $PROFILE` returns:  
_"The system cannot find the path specified"_

**Solution:**  
Create the profile file using:

```powershell
New-Item -ItemType File -Path $PROFILE -Force
```

---

### ❌ Aliases with Special Characters

**Symptom:**  
Aliases with dashes or complex names aren't supported in PowerShell.

**Solution:**  
Define PowerShell functions, then create simple aliases like `kroot` and `kinfra`.

---

## ✅ Summary

- Use `oci ce cluster create-kubeconfig` in PowerShell to add clusters.
- Manage access using `kubectl config use-context`.
- Automate switching with PowerShell functions and aliases.
- Address common issues with profile creation and alias syntax.

---
