# Read from Infrastructure Automation Account
module "aa_infra" {
  source = "git::https://anglefinanceauto@dev.azure.com/anglefinanceauto/Azure%20Virtual%20Desktops/_git/avd-module-automationaccount-infra-read"

  providers = {
    # The provider with access to the Automation Account.
    azurerm = azurerm
  }

  name                = "avd-shr-aue-shared-infra-aa"
  resource_group_name = "avd-shr-aue-shared-rg"

  # Values you want to retrieve from the Automation Account.
  variables = {
    frontend_rg     = "string"
    data_rg         = "string"
    network_rg      = "string"
    shared_rg       = "string"
    logic_rg        = "string"
    virtual_network = "string"
    nerdio_subnet   = "string"
    key_vault       = "string"
  }
}