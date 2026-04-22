# Azure Platform Engineering Portfolio

## Disclaimer

This repository contains a sanitised Azure platform implementations based on real-world enterprise environments.

Sensitive data, naming conventions, and IP ranges have been modified for demonstration purposes. Additional examples and modules are being progressively added over time.

## Overview

This repository showcases a **modular Azure platform implementation** built using Terraform, aligned to enterprise landing zone and cloud governance patterns.

It demonstrates end-to-end platform design, including:

* Azure Landing Zones (hub-spoke architecture)
* Subscription vending (YAML-driven)
* Terraform backend (launchpad pattern)
* Monitoring and alerting modules
* CI/CD and DevSecOps practices

---

## Repository Structure

```
Azure Landing Zone/
  app-landing-zone-subscription-vending/
  core-platform-landing-zones/
  core-platform-launchpad/

Terraform Modules/
  azurerm-metric-alerts/
```

---

## Key Components

### Platform Landing Zones

* Hub-spoke architecture
* Azure Firewall, NSGs, routing
* Identity and management separation
* Designed following Microsoft Cloud Adoption Framework

---

### Subscription Vending

* YAML-driven subscription creation
* Uses Azure `lz-vending` module
* Automates billing and management group assignment

---

### Platform Launchpad

* Terraform backend design
* Storage account + container segmentation
* Enables scalable state management

---

### Monitoring & Alerts

* Reusable Terraform module for Azure Monitor alerts
* Supports SQL and VM alerting
* Uses dynamic Terraform constructs for scalability

---

## What This Demonstrates

* Enterprise Azure platform design
* Terraform module architecture at scale
* Cloud governance and subscription lifecycle management
* DevOps and CI/CD integration
* Real-world platform engineering patterns

---

## Notes

This repository is a **sanitised example** based on real-world enterprise implementations.
All sensitive values, naming, and IP ranges have been modified for demonstration purposes.
Terraform state files, plan files, local variable files, and environment files are intentionally excluded from version control via `.gitignore`.

Authentication and environment-specific identifiers should be supplied at runtime using Azure CLI, managed identity/OIDC, pipeline variables, or non-committed `*.tfvars` files.

---

## Author

Joshua Cavallo  
Azure Platform Engineer | Cloud & DevOps Specialist  
GitHub: https://github.com/jo101c/Mywork
