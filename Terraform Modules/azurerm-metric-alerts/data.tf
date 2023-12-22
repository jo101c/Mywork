data "azurerm_resource_group" "default" {
  name = "ambit-shared-syd-prd-rg"
}

data "azurerm_monitor_action_group" "ambit_team" {
  name                = "Ambit Application Management Team"
  resource_group_name = "ambit-syd-prd-rg"
}