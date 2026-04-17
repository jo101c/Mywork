
resource "azurerm_public_ip" "pip_azfw" {
  provider            = azurerm.hub
  name                = "pip-ae-${var.environment == "prod" ? "pr" : "np"}e-hub-fw"
  location            = var.location
  resource_group_name = var.hub_vnet_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_firewall_policy" "azfw_policy" {
  #checkov:skip=CKV_AZURE_220: "https://company.atlassian.net/browse/APPSEC-117"
  provider                 = azurerm.hub
  name                     = "azfw-ae-policy"
  resource_group_name      = var.hub_vnet_resource_group_name
  location                 = var.location
  sku                      = var.sku_tier
  threat_intelligence_mode = "Deny"

  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall" "fw" {
  provider            = azurerm.hub
  name                = "azfw-ae-${var.environment == "prod" ? "pr" : "np"}e-lz-01"
  location            = var.location
  resource_group_name = var.hub_vnet_resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  private_ip_ranges   = var.private_ip_ranges
  ip_configuration {
    name                 = "azfw-ae-ipconfig"
    subnet_id            = var.hub_vnet_fw_subnet_id
    public_ip_address_id = azurerm_public_ip.pip_azfw.id
  }
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  tags               = local.tags
}



