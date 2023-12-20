
module "networking_identity" {
  source = "./modules/networking/identity"

  providers = {
    azurerm.identity   = azurerm.identity_platform
    azurerm.hub        = azurerm.hub_platform
    azurerm.management = azurerm.management_platform
  }

  environment                  = var.environment
  hub_vnet_id                  = module.networking_hub.hub_vnet.hub_vnet_id
  hub_vnet_resource_group_name = module.networking_hub.hub_vnet.hub_vnet_resource_group_name
  hub_vnet_name                = module.networking_hub.hub_vnet.hub_vnet_name
  monitoring_workspace_id      = module.monitoring_workspaces.workspaces.monitoring_workspace_id
}

#---------------------------------------------------------------------------------------------#

module "networking_management" {
  source = "./modules/networking/management"

  providers = {
    azurerm.management = azurerm.management_platform
    azurerm.hub        = azurerm.hub_platform
  }

  environment                  = var.environment
  hub_vnet_id                  = module.networking_hub.hub_vnet.hub_vnet_id
  hub_vnet_resource_group_name = module.networking_hub.hub_vnet.hub_vnet_resource_group_name
  hub_vnet_name                = module.networking_hub.hub_vnet.hub_vnet_name
  monitoring_workspace_id      = module.monitoring_workspaces.workspaces.monitoring_workspace_id
}

#---------------------------------------------------------------------------------------------#

module "networking_hub" {
  source = "./modules/networking/hub"

  providers = {
    azurerm.hub        = azurerm.hub_platform
    azurerm.management = azurerm.management_platform
  }

  environment             = var.environment
  monitoring_workspace_id = module.monitoring_workspaces.workspaces.monitoring_workspace_id
}

#---------------------------------------------------------------------------------------------#

module "networking_firewall" {
  source = "./modules/networking/firewall"

  providers = {
    azurerm.hub = azurerm.hub_platform
  }

  environment                  = var.environment
  hub_vnet_id                  = module.networking_hub.hub_vnet.hub_vnet_id
  hub_vnet_resource_group_name = module.networking_hub.hub_vnet.hub_vnet_resource_group_name
  hub_vnet_name                = module.networking_hub.hub_vnet.hub_vnet_name
  hub_vnet_gw_subnet_id        = module.networking_hub.hub_vnet.hub_vnet_gw_subnet_id
  hub_vnet_gw_subnet_name      = module.networking_hub.hub_vnet.hub_vnet_gw_subnet_name
  hub_vnet_fw_subnet_id        = module.networking_hub.hub_vnet.hub_vnet_fw_subnet_id
  hub_vnet_fw_subnet_name      = module.networking_hub.hub_vnet.hub_vnet_fw_subnet_name
}

#---------------------------------------------------------------------------------------------#

module "monitoring_workspaces" {
  source = "./modules/monitoring/workspaces"

  providers = {
    azurerm.management = azurerm.management_platform
  }

  environment = var.environment
}

#---------------------------------------------------------------------------------------------#

module "monitoring_activity_logs" {
  source = "./modules/monitoring/activity_logs"

  providers = {
    azurerm.management = azurerm.management_platform
    azurerm.hub        = azurerm.hub_platform
    azurerm.identity   = azurerm.identity_platform
  }

  environment             = var.environment
  monitoring_workspace_id = module.monitoring_workspaces.workspaces.monitoring_workspace_id
}

#---------------------------------------------------------------------------------------------#

module "monitoring_action_groups" {
  source = "./modules/monitoring/action_groups"

  providers = {
    azurerm.management = azurerm.management_platform
  }

  environment        = var.environment
  monitoring_rg_name = module.monitoring_workspaces.workspaces.monitoring_rg_name
}

#---------------------------------------------------------------------------------------------#

module "monitoring_service_health_alerts_mgmt" {
  source = "./modules/monitoring/service_health_alerts_mgmt"

  providers = {
    azurerm.management = azurerm.management_platform
  }

  environment                    = var.environment
  service_health_action_group_id = module.monitoring_action_groups.monitoring_action_group_ids.service_health
  monitoring_rg_name             = module.monitoring_workspaces.workspaces.monitoring_rg_name
}

module "monitoring_service_health_alerts_identity" {
  source = "./modules/monitoring/service_health_alerts_identity"

  providers = {
    azurerm.identity = azurerm.identity_platform
  }

  environment                    = var.environment
  service_health_action_group_id = module.monitoring_action_groups.monitoring_action_group_ids.service_health
}

module "monitoring_service_health_alerts_hub" {
  source = "./modules/monitoring/service_health_alerts_hub"

  providers = {
    azurerm.hub = azurerm.hub_platform
  }

  environment                    = var.environment
  service_health_action_group_id = module.monitoring_action_groups.monitoring_action_group_ids.service_health
}