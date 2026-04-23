# Azure Platform Engineering Portfolio

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
* Microsoft Foundry / Azure OpenAI integration
* Cost-conscious AI implementation patterns
* CI/CD and DevSecOps practices

---

## Repository Structure

```
Azure AI Solutions/
  AI Agents/
    azure-lz-governance-advisor/

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
* Uses Microsoft Foundry, Azure OpenAI, Terraform scaffolding, and GitHub OIDC workflows
* Produces governance findings, missing evidence, and 30/60/90-day remediation roadmaps
* Designed as a portfolio-ready, low-cost AI implementation that complements the platform engineering projects in this repository
* See the project README for the full walkthrough and setup details

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
* Prompt engineering and AI solution design
* Azure AI architecture using Microsoft Foundry / Azure OpenAI
* DevOps and CI/CD integration
* Real-world platform engineering patterns

---

## Author

Joshua Cavallo  
Azure Platform Engineer | Cloud & DevOps Specialist  
GitHub: https://github.com/jo101c/Mywork
