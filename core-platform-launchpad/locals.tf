locals {
  storage_accounts = {
    "aefb${var.environment == "prod" ? "p" : "np"}tfstateplatform01" = { # Level 1 - Core Platform - Landing Zones
      location            = var.location,
      resource_group_name = data.azurerm_resource_group.default_lzone_rg.name,
      containers          = ["platform"]
    },
    "aefb${var.environment == "prod" ? "p" : "np"}tfstatemgmtsubs01" = { #Level 2 - App Landing Zone - Subscription Vending
      location            = var.location,
      resource_group_name = data.azurerm_resource_group.default_lzone_rg.name,
      containers          = ["app-lz-subscriptions"]
    },
    "aefb${var.environment == "prod" ? "p" : "np"}tfstatemgmtapps01" = { #Level 3 - App Landing Zone - Workload resources
      location            = var.location,
      resource_group_name = data.azurerm_resource_group.default_lzone_rg.name,
      containers          = ["app-workload1", "app-workload2"]
    }
  }

  container_combinations = flatten([
    for sa, details in local.storage_accounts : [
      for container in details.containers : {
        storage_account_name = sa,
        container_name       = container
      }
    ]
  ])
}