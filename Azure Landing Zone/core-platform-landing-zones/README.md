## Azure Platform Landing Zone (Terraform)

**Author:** Joshua Cavallo

---

## Overview

This repository contains a modular **Azure Landing Zone implementation** built using Terraform, aligned to enterprise design patterns.

It demonstrates how to design and deploy a scalable, secure, and repeatable Azure platform using:

* Hub and Spoke network architecture
* Centralised security and governance
* Environment separation (prod / nonprod)
* Infrastructure as Code (IaC) using reusable modules
* CI/CD-driven deployments

This is a **sanitised example** based on real-world enterprise implementations. All sensitive data, naming, and IP ranges have been modified for demonstration purposes.

---

## Architecture Summary

The platform follows a **hub-and-spoke model**:

* **Hub VNet**

  * Azure Firewall
  * Bastion
  * Shared services and routing

* **Spoke VNets**

  * **Identity** (e.g. Entra Domain Services / identity workloads)
  * **Management** (e.g. jump hosts, admin services)
  * **Workloads** (e.g. AVD or application environments)

* **Centralised Controls**

  * Azure Firewall Policy (network + application rules)
  * NSGs and routing
  * Log Analytics for monitoring and diagnostics

---

## Repository Structure

```bash
modules/
  monitoring/
    action_groups/
    activity_logs/
    service_health_alerts_hub/
    service_health_alerts_identity/
    service_health_alerts_mgmt/
    workspaces/

  networking/
    bastion/
    dns/
    firewall/
    hub/
    identity/
    management/

  policies/
  security/

.gitlab-ci.yml
.checkov.yml

backend.tf
providers.tf
main.tf
variables.tf
locals.tf
terraform.tf
data.tf
```

### Key Points

* **modules/networking**
  Contains core platform networking components, including:

  * Hub VNet
  * Identity VNet
  * Management VNet
  * Firewall, DNS, Bastion

* **modules/monitoring**
  Implements platform-wide observability:

  * Log Analytics workspaces
  * Activity logs
  * Service health alerts

* **modules/security & policies**
  Designed for governance and security enforcement.

* **Root configuration**
  Orchestrates module deployment and environment configuration.

* **CI/CD**
  Defined via `.gitlab-ci.yml`, with security checks using Checkov.

---

## Design Decisions

* **Hub-Spoke Architecture**
  Enables centralised control of network traffic, security, and shared services.

* **Azure Firewall over NSG-only model**
  Provides advanced filtering (FQDN, threat intelligence, central policy management).

* **Separate Identity / Management / Workload VNets**
  Improves security isolation and aligns with enterprise landing zone practices.

* **Modular Terraform Design**
  Allows reuse, scalability, and clear separation of responsibilities.

* **CI/CD Integration**
  Ensures consistent and controlled infrastructure deployments.

---

## Getting Started

### Prerequisites

* Terraform
* Git
* Azure CLI or OIDC-based authentication
* Visual Studio Code (recommended)

---

### Clone Repository

```bash
git clone <repository-url>
cd <repository>
git checkout -b feature/<your-feature-name>
```

---

### Working with the Code

1. Navigate to the relevant module or root configuration
2. Make changes
3. Run:

```bash
terraform init
terraform plan
```

4. Review output and validate changes before committing

---

## Deployment Workflow

Deployments are handled via CI/CD pipeline:

* **Plan** runs automatically on merge request
* **Apply** requires manual approval
* **Authentication** handled securely via pipeline configuration

---

## Best Practices

* **Keep modules focused and composable**
* **Avoid hardcoding sensitive data** (use Key Vault or pipeline variables)
* **Use consistent naming conventions**
* **Always review `terraform plan` before applying**
* **Run security checks (e.g. Checkov, tfsec)**
* **Regularly sync with main/nonprod branches to avoid drift**

---

## What This Repository Demonstrates

* Enterprise Azure Landing Zone design
* Network segmentation and hub-spoke architecture
* Azure Firewall policy and traffic control
* Terraform module structuring at scale
* CI/CD-driven infrastructure deployment
* Secure and governed cloud platform design

---
