## Azure Landing Zone – Subscription Vending (Terraform)

**Author:** Joshua Cavallo

---

## Overview

This repository implements an **Azure Landing Zone Subscription Vending solution** using Terraform.

It enables automated creation and configuration of Azure subscriptions based on **declarative YAML input**, aligning with enterprise-scale landing zone patterns.

The solution leverages the official Azure module:

* `Azure/lz-vending/azurerm`

and extends it with a structured, scalable approach for managing multiple subscriptions.

---

## Purpose

In large-scale environments, manual subscription creation leads to:

* Inconsistent configuration
* Lack of governance
* Operational overhead

This solution addresses that by:

* Defining subscriptions as **code (YAML)**
* Automating provisioning via Terraform
* Enforcing consistent governance and structure

---

## How It Works

### 1. YAML-Driven Configuration

Subscriptions are defined in YAML files:

```yaml id="8m9z8x"
name: example-subscription
workload: Production
location: australiaeast
billing_enrollment_account: <billing_id>
management_group_id: example-mg
```

Each YAML file represents a **landing zone subscription**.

---

### 2. Dynamic File Processing (locals.lzvending.tf)

Terraform dynamically reads all YAML files:

```hcl id="qj0k1t"
landing_zone_files = fileset(local.landing_zone_data_dir, "landing_zone_*.yaml")

landing_zone_data_map = {
  for f in local.landing_zone_files :
  f => yamldecode(file("${local.landing_zone_data_dir}/${f}"))
}
```

This enables:

* Automatic onboarding of new subscriptions
* No changes required to Terraform code when adding new landing zones

---

### 3. Subscription Deployment (main.lzvending.tf)

Each YAML definition is deployed using:

```hcl id="x4v2kc"
for_each = local.landing_zone_data_map
```

The module provisions:

* Azure subscription
* Billing association
* Management group assignment

---

## Repository Structure

```bash id="m7u9fi"
lzdata/
  landing_zone_0.yaml     # Subscription definitions

locals.lzvending.tf       # YAML processing logic
main.lzvending.tf         # Subscription deployment
providers.tf              # Provider configuration
variables.tf              # Input variables
backend.tf                # Terraform backend
```

---

## Key Features

* **YAML-Driven Subscription Vending**
  Easily define new subscriptions without modifying Terraform code

* **Dynamic Scaling**
  Supports multiple landing zones via file-based configuration

* **Management Group Integration**
  Automatically assigns subscriptions to the correct hierarchy

* **Billing Integration**
  Links subscriptions to the correct billing enrollment account

* **Reusable & Extendable Design**
  Built on top of official Azure Terraform modules

---

## Getting Started

### Prerequisites

* Terraform
* Azure CLI or OIDC authentication
* Appropriate permissions for:

  * Subscription creation
  * Billing account access
  * Management group assignment

---

### Add a New Subscription

1. Create a new YAML file in `/lzdata`:

```yaml id="2x7a1k"
name: my-new-subscription
workload: Production
location: eastus
billing_enrollment_account: <billing_id>
management_group_id: example-mg
```

2. Run:

```bash id="a4v5dp"
terraform init
terraform plan
terraform apply
```

---

## Design Decisions

* **YAML over Terraform Variables**

  * Enables non-Terraform users to define subscriptions
  * Improves scalability and usability

* **fileset + yamldecode Pattern**

  * Allows dynamic discovery of landing zones
  * Removes need for code changes when scaling

* **Official Azure Module Usage**

  * Ensures alignment with Microsoft best practices

* **Separation of Data and Logic**

  * YAML = configuration
  * Terraform = execution

---

## What This Repository Demonstrates

* Enterprise subscription vending design
* Advanced Terraform patterns (`for_each`, `fileset`, `yamldecode`)
* Azure governance and management group structure
* Scalable platform onboarding processes
* Infrastructure as Code at organisational level

---

## Notes

* This is a **sanitised example** based on real-world enterprise implementations
* Billing account IDs and management groups are placeholders
* Requires appropriate Azure RBAC permissions to function

---

## Future Enhancements (Optional)

* Policy assignment during subscription creation
* Tagging standards enforcement
* Integration with identity and RBAC modules
* Environment-specific YAML validation

---
