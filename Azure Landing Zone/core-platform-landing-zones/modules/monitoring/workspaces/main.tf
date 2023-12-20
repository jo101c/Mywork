
resource "azurerm_resource_group" "monitoring" {
  provider = azurerm.management

  name     = "rg-ae-${var.environment == "prod" ? "pr" : "np"}-platform-mgmt-operations"
  location = "Australia East"

  tags = local.tags
}

#----------------------------------------------------------------------------------------------#
#                                   Log Analytics Workspaces                                   #
#----------------------------------------------------------------------------------------------#

resource "azurerm_log_analytics_workspace" "monitoring" {
  provider = azurerm.management

  name                = "law-ae-${var.environment == "prod" ? "pr" : "np"}-platform-ops-01"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}