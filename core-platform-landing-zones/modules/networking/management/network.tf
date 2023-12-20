#----------------------------------------------------------------------------------------------#
#                                          Virtual Network                                     #
#----------------------------------------------------------------------------------------------#

resource "azurerm_virtual_network" "default" {
  provider = azurerm.management

  name                = "vnet-ae-${var.environment == "prod" ? "pr" : "np"}-platform-mgmt"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = var.environment == "prod" ? ["10.10.176.0/20"] : ["10.10.192.0/20"]

  tags = local.tags
}

#----------------------------------------------------------------------------------------------#
#                                          Subnets                                             #
#----------------------------------------------------------------------------------------------#

resource "azurerm_subnet" "management" {
  provider = azurerm.management

  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = var.environment == "prod" ? ["10.10.176.0/24"] : ["10.10.192.0/24"]
}

#----------------------------------------------------------------------------------------------#
#                                           Peerings                                           #
#----------------------------------------------------------------------------------------------#

resource "azurerm_virtual_network_peering" "management_to_hub" {
  provider = azurerm.management

  name                         = "peering-management-to-hub"
  resource_group_name          = azurerm_resource_group.default.name
  virtual_network_name         = azurerm_virtual_network.default.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_to_management" {
  provider = azurerm.hub

  name                         = "peering-hub-to-management"
  resource_group_name          = var.hub_vnet_resource_group_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.default.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

#----------------------------------------------------------------------------------------------#
#                                    Diagnostic Settings                                       #
#----------------------------------------------------------------------------------------------#


resource "azurerm_monitor_diagnostic_setting" "default" {
  provider = azurerm.management

  name                           = "diag_mgmt_vnet"
  target_resource_id             = azurerm_virtual_network.default.id
  log_analytics_workspace_id     = var.monitoring_workspace_id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"

  }
}