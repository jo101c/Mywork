provider "azurerm" {
  features {}
  use_oidc = true
}

provider "azurerm" {
  features {}
  subscription_id = var.ARM_IDENTITY_SUBSCRIPTION_ID
  client_id       = var.CLIENT_ID
  use_oidc        = true
  alias           = "identity_platform"
}

provider "azurerm" {
  features {}
  subscription_id = var.ARM_MANAGEMENT_SUBSCRIPTION_ID
  client_id       = var.CLIENT_ID
  use_oidc        = true
  alias           = "management_platform"
}

provider "azurerm" {
  features {}
  subscription_id = var.ARM_HUB_SUBSCRIPTION_ID
  client_id       = var.CLIENT_ID
  use_oidc        = true
  alias           = "hub_platform"
}