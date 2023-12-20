
resource "azurerm_resource_group" "hub_vnet" {
  provider = azurerm.hub

  name     = "rg-ae-${var.environment == "prod" ? "pr" : "np"}-platform-hub-networking"
  location = "Australia East"

  tags = local.tags
}

resource "azurerm_network_watcher" "default" {
  provider = azurerm.hub

  name                = "nw-ae-${var.environment == "prod" ? "pr" : "np"}-platform-hub"
  location            = azurerm_resource_group.hub_vnet.location
  resource_group_name = azurerm_resource_group.hub_vnet.name
  tags                = local.tags
}