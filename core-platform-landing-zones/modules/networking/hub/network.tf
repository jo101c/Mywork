#----------------------------------------------------------------------------------------------#
#                                          Virtual Network                                     #
#----------------------------------------------------------------------------------------------#

resource "azurerm_virtual_network" "hub_vnet" {
  provider = azurerm.hub

  name                = "vnet-ae-${var.environment == "prod" ? "pr" : "np"}-platform-hub"
  location            = azurerm_resource_group.hub_vnet.location
  resource_group_name = azurerm_resource_group.hub_vnet.name
  address_space       = var.environment == "prod" ? ["10.11.0.0/22"] : ["10.12.0.0/22"]

  tags = local.tags
}

#----------------------------------------------------------------------------------------------#
#                                          Subnets                                             #
#----------------------------------------------------------------------------------------------#

resource "azurerm_subnet" "gateway" {
  provider = azurerm.hub

  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_vnet.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.environment == "prod" ? ["10.11.0.0/24"] : ["10.12.0.0/24"]
}

resource "azurerm_subnet" "azurefirewall" {
  provider = azurerm.hub

  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_vnet.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.environment == "prod" ? ["10.11.1.0/26"] : ["10.12.1.0/26"]
}

resource "azurerm_subnet" "azurebastion" {
  provider = azurerm.hub

  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub_vnet.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.environment == "prod" ? ["10.11.1.64/26"] : ["10.12.1.64/26"]
}

#----------------------------------------------------------------------------------------------#
#                                    Diagnostic Settings                                       #
#----------------------------------------------------------------------------------------------#


resource "azurerm_monitor_diagnostic_setting" "default" {
  provider = azurerm.hub

  name                           = "diag_hub_vnet"
  target_resource_id             = azurerm_virtual_network.hub_vnet.id
  log_analytics_workspace_id     = var.monitoring_workspace_id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"

  }
}