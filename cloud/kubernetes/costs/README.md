# OKE Cost Mitigation and Always Free Transition Guide

This guide explains how to safely migrate an OKE cluster to Always Free resources and enforce cost control measures.

---

## 1. Migrate OKE Node Pool to Reduce Costs

- **Add** a new node pool using `VM.Standard.A1.Flex` instances, eligible for Always Free (up to 4 OCPU, 24GB total).
- **Cordon** the old node pool running `A3 Flex` instances to prevent new workloads from being scheduled:
  ```bash
  kubectl cordon <old-node-name>
  ```
- **Drain** the old node pool:
  ```bash
  kubectl drain <old-node-name> --ignore-daemonsets --delete-emptydir-data
  ```
- **Delete** the old paid node pool from the Oracle Console or using OCI CLI.

### Known Issue: NGINX Controller Eviction Blocked

- You may encounter eviction errors for `ingress-nginx-controller` pods due to a **Pod Disruption Budget (PDB)**:
  ```text
  Cannot evict pod as it would violate the pod's disruption budget.
  ```
- Cause:
  - The `PDB` enforces `MIN AVAILABLE = 1`.
  - If the new pod on the A1 Flex node is not yet in `Ready` state, eviction is blocked.
- Solution:
  - Wait for the new pod to fully start and become `Ready`:
    ```bash
    kubectl get pods -n ingress-nginx -o wide -w
    ```
  - Once the new pod is ready, repeat the drain command.

---

## 2. Verify Storage and Clean Up Residual Costs

- **Check Block Volumes:**
  - Navigate to **Block Storage → Block Volumes** in the Console.
  - Ensure only volumes marked **Always Free** remain.
- **Check Boot Volumes:**
  ```bash
  oci compute boot-volume list --compartment-id <your-compartment-id>
  ```
- **Delete** any detached or oversized volumes that exceed Always Free limits.

---

## 3. Set Up a Cost Control Budget

- **Create** a budget in the Oracle Console:
  - Scope: Root compartment or specific compartments hosting Always Free resources.
  - Amount: `100 CZK` monthly.
  - Notifications: `1%` threshold for early alerts.
  - Start Date: `July 1, 2025` to allow residual June costs to settle.

---

## 4. Monitor and Enforce Always Free Compliance

- **Track total A1 Flex usage:**
  - Stay within `4 OCPUs` and `24GB RAM` combined across all regions.
- **Tag resources** for easy identification:
  ```text
  Namespace: CostControl
  Tag Key: BillingType
  Tag Value: AlwaysFree
  ```
- **Monitor Cost Analysis** regularly to ensure no unintended charges appear.

---

## Conclusion

Follow this process to migrate OKE workloads to Always Free, avoid unnecessary costs, and enforce budget controls effectively.
