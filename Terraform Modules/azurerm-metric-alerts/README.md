## Azure Metric Alerts Module (Terraform)

**Author:** Joshua Cavallo

---

## Overview

This Terraform module provides a **scalable and reusable approach** to deploying Azure Monitor metric alerts across multiple resource types.

It uses dynamic Terraform constructs (`locals`, `for_each`) to define and deploy alert rules consistently for:

* Azure SQL Databases
* Azure Virtual Machines

The module is designed to standardise alerting across environments while reducing duplication and improving maintainability.

---

## Purpose

In enterprise environments, alerting is often:

* Inconsistent
* Manually configured
* Difficult to scale

This module solves that by:

* Defining alert criteria centrally using `locals`
* Dynamically deploying multiple alert rules
* Enforcing consistent alerting standards across workloads

---

## How It Works

### 1. Alert Definitions (locals.tf)

Alert rules are defined as maps:

* **SQL Alerts**

  * CPU utilisation
  * Storage capacity
  * Deadlocks
  * Failed connections
  * Memory usage

* **VM Alerts**

  * CPU utilisation
  * Memory availability

Each alert includes:

* Metric namespace
* Metric name
* Aggregation type
* Operator
* Threshold

---

### 2. Dynamic Deployment (main.tf)

Alerts are created using:

```hcl id="l3f4nt"
for_each = local.criteria_sql
for_each = local.criteria_vm
```

This allows:

* Easy addition of new alert rules
* Consistent deployment across all environments
* Minimal code duplication

Each alert is configured with:

* Scope (target resources)
* Severity
* Frequency
* Window size
* Action group integration

---

### 3. Configuration (variables.tf)

Key configurable inputs:

* `scopes_sql` → Target SQL resources
* `scopes_vm` → Target VM resources
* `resource_group_name` → Resource group that hosts the alert rules
* `action_group_name` → Existing Azure Monitor Action Group to notify
* `action_group_resource_group_name` → Optional override when the action group lives elsewhere
* `sql_metric_alerts` → SQL alert configuration
* `vm_metric_alerts` → VM alert configuration
* `tags` → Standardised tagging

---

## Repository Structure

```bash id="f9f7vy"
main.tf         # Alert rule deployment logic
locals.tf       # Alert definitions and criteria
variables.tf    # Module inputs and configuration
data.tf         # Data sources (resource group, action group)
providers.tf    # Provider configuration
```

---

## Example Usage

```hcl id="oz9w42"
module "metric_alerts" {
  source = "./modules/azurerm-metric-alerts"

  resource_group_name = "rg-monitoring-prod"
  action_group_name   = "ag-platform-ops"
  scopes_sql = ["/subscriptions/<subscription-id>"]
  scopes_vm  = ["/subscriptions/<subscription-id>"]

  tags = {
    environment = "prod"
    deployment  = "terraform"
  }
}
```

---

## Design Decisions

* **Centralised Alert Definitions**

  * Using `locals` ensures all alert rules are managed in one place

* **Dynamic Resource Creation**

  * `for_each` enables scalable and maintainable alert deployment

* **Separation by Resource Type**

  * SQL and VM alerts are defined and deployed independently

* **Standardised Alert Configuration**

  * Ensures consistent severity, frequency, and thresholds across environments

---

## Key Features

* Reusable Terraform module for Azure Monitor alerts
* Supports multiple resource types (SQL, VM)
* Easily extendable by adding new criteria in `locals.tf`
* Integrates with Azure Monitor Action Groups
* Reduces manual alert configuration

---

## What This Module Demonstrates

* Advanced Terraform patterns (`for_each`, maps, locals)
* Scalable monitoring design
* Standardisation of operational alerts
* Real-world Azure observability practices

---

## Notes

* This module assumes an existing **Azure Monitor Action Group** is available
* Authentication should be supplied by the calling root module, Azure CLI session, or OIDC pipeline identity
* Metric validation is skipped (`skip_metric_validation = true`) to support flexible deployment scenarios
* Default thresholds and values are examples and should be tuned per environment

---

## Future Enhancements (Optional)

* Support for additional resource types (App Services, Storage, AKS)
* Parameterised thresholds per environment
* Integration with alert processing rules
* Custom action group configuration

---
