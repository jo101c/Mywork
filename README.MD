# Azure Platform Engineering

## Disclaimer

This repository contains a sanitised Azure platform implementations based on real-world enterprise environments.

Sensitive data, naming conventions, and IP ranges have been modified for demonstration purposes. Additional examples and modules are being progressively added over time.

## Overview

This repository showcases a **modular Azure platform engineering portfolio** spanning Terraform-based landing zones, cloud governance, DevOps, and Azure AI solutions.

It demonstrates end-to-end platform design, including:

* Azure Landing Zones (hub-spoke architecture)
* Subscription vending (YAML-driven)
* Terraform backend (launchpad pattern)
* Monitoring and alerting modules
* AI governance advisory agents
* AI-assisted tenant security posture monitoring
* Microsoft Foundry / Azure OpenAI integration
* Cost-conscious AI implementation patterns
* CI/CD and DevSecOps practices

---

## Repository Structure

```
Azure AI Solutions/
  AI Agents/
    azure-lz-governance-advisor/
    azure-tenant-security-posture-agent/

Azure Landing Zone/
  app-landing-zone-subscription-vending/
  core-platform-landing-zones/
  core-platform-launchpad/

Terraform Modules/
  azurerm-metric-alerts/
```

---

## Key Components

### AI Solutions

* `azure-lz-governance-advisor` demonstrates an Azure AI governance agent that reviews landing zone evidence against Cloud Adoption Framework guidance
* `azure-tenant-security-posture-agent` demonstrates a daily Azure tenant security posture agent that scans findings, generates reports, and supports follow-up Q&A
* Together, the AI projects use Microsoft Foundry / Azure OpenAI, Terraform scaffolding, and GitHub OIDC workflows
* They showcase both cost-conscious AI implementation patterns and secure Azure-native automation for governance and security operations
* See each project README for the full walkthrough and setup details

---

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
* Applied AI for governance automation
* AI-assisted tenant security posture assessment
* Prompt engineering and AI solution design
* Azure AI architecture using Microsoft Foundry / Azure OpenAI
* Azure Functions-based AI automation for security operations
* DevOps and CI/CD integration
* Real-world platform engineering patterns

---

## Author

Joshua Cavallo  
Azure Platform Engineer | Cloud & DevOps Specialist  
GitHub: https://github.com/jo101c/Mywork
