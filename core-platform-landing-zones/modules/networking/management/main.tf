
resource "azurerm_resource_group" "default" {
  provider = azurerm.management

  name     = "rg-ae-${var.environment == "prod" ? "pr" : "np"}-platform-mgmt-networking"
  location = "Australia East"
  tags     = local.tags
}

resource "azurerm_network_watcher" "default" {
  provider = azurerm.management

  name                = "nw-ae-${var.environment == "prod" ? "pr" : "np"}-platform-mgmt"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tags                = local.tags
}