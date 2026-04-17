## Azure Platform Launchpad (Terraform)

**Author:** Joshua Cavallo

---

## Overview

This repository provides a **bootstrap (launchpad) implementation** for an Azure platform using Terraform.

It is designed to initialise core platform components required before deploying full landing zones, including:

* Storage accounts for Terraform state management
* Blob containers for environment and workload segregation
* Foundational configuration for scalable Infrastructure as Code (IaC) deployments

This solution enables a **repeatable and structured foundation** for managing Terraform state across multiple environments and platform layers.

---

## Purpose

Before deploying a full Azure Landing Zone, a **secure and structured backend** is required.

This repository solves that by:

* Creating **multiple storage accounts** aligned to platform layers
* Structuring **state containers** for different environments and workloads
* Providing a scalable pattern for **state isolation and governance**

---

## Architecture Approach

The design follows a **layered platform model**:

* **Level 1 – Core Platform**

  * Central platform resources
  * Shared state container (`platform`)

* **Level 2 – Subscription / Landing Zone Vending**

  * State for subscription provisioning
  * Container: `app-lz-subscriptions`

* **Level 3 – Workload Layer**

  * Application-level infrastructure state
  * Containers: `app-workload1`, `app-workload2`

Each layer is deployed into **separate storage accounts** to ensure:

* Isolation of Terraform state
* Reduced blast radius
* Improved governance and access control

---

## Repository Structure

```bash
backend.tf
providers.tf
main.tf
variables.tf
locals.tf
outputs.tf
data.tf
```

### Key Components

* **locals.tf**

  * Defines storage account structure dynamically
  * Uses environment-aware naming (prod / nonprod)
  * Generates container combinations for deployment

* **main.tf**

  * Creates storage accounts using `for_each`
  * Dynamically provisions containers per account
  * Implements dependency handling using `time_sleep` to avoid race conditions

* **variables.tf**

  * Defines configurable parameters such as:

    * replication type
    * access tier
    * container access level

* **backend.tf**

  * Defines Terraform backend configuration

---

## Key Features

* **Dynamic Resource Creation**

  * Uses `for_each` and `locals` to scale storage accounts and containers

* **Environment-Aware Naming**

  * Automatically adjusts naming based on `prod` vs `nonprod`

* **State Segmentation**

  * Separates Terraform state by:

    * platform
    * subscription provisioning
    * workloads

* **Dependency Handling**

  * Introduces controlled delay (`time_sleep`) to ensure container creation stability

---

## Getting Started

### Prerequisites

* Terraform
* Azure CLI or OIDC authentication
* Git

---

### Setup

```bash
git clone <repository-url>
cd <repository>
terraform init
```

---

### Plan & Apply

```bash
terraform plan
terraform apply
```

---

## Design Decisions

* **Multiple Storage Accounts vs Single**

  * Improves isolation and reduces risk of state corruption or access overlap

* **Container-Based Segmentation**

  * Enables logical separation of platform, subscription, and workload state

* **Dynamic Terraform Patterns**

  * Reduces duplication and improves scalability

* **Launchpad First Approach**

  * Establishes a solid foundation before deploying landing zones

---

## What This Repository Demonstrates

* Terraform dynamic constructs (`for_each`, `locals`, `flatten`)
* Scalable backend design for enterprise Terraform usage
* Platform bootstrap strategy (launchpad pattern)
* Environment-based configuration patterns
* Real-world Azure infrastructure design thinking

---

## Notes

This repository is a **sanitised example** based on real-world enterprise implementations.
All naming conventions and configurations have been adjusted for demonstration purposes.

---
