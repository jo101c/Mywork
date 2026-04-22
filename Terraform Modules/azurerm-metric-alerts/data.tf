data "azurerm_resource_group" "default" {
  name = var.resource_group_name
}

data "azurerm_monitor_action_group" "ambit_team" {
  name                = var.action_group_name
  resource_group_name = coalesce(var.action_group_resource_group_name, var.resource_group_name)
}
