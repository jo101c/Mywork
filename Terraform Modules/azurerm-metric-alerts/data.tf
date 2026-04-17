data "azurerm_resource_group" "default" {
  name = "rg_name"
}

data "azurerm_monitor_action_group" "ambit_team" {
  name                = "Application Management Team"
  resource_group_name = "rg_name"
}