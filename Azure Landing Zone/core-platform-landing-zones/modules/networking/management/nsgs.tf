
#----------------------------------------------------------------------------------------------#
#                                    Management Subnet NSG                                     #
#----------------------------------------------------------------------------------------------#

resource "azurerm_network_security_group" "management" {
  provider = azurerm.management

  name                = "nsg-ae-mgmt-management"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tags                = local.tags
}

resource "azurerm_subnet_network_security_group_association" "management" {
  provider = azurerm.management

  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}


#----------------------------------------------------------------------------------------------#
#                                    NSG Flow Logs                                             #
#----------------------------------------------------------------------------------------------#


# resource "azurerm_network_watcher_flow_log" "log_management" {
#   provider = azurerm.management

#   network_watcher_name      = azurerm_network_watcher.default.name
#   resource_group_name       = azurerm_resource_group.default.name
#   name                      = "management-${var.environment == "prod" ? "pr" : "np"}-log-management"
#   location                  = azurerm_resource_group.default.location
#   tags                      = local.tags

#   network_security_group_id = azurerm_network_security_group.management.id
#   storage_account_id        = data.azurerm_storage_account.flow_logs.id
#   enabled                   = true

#   retention_policy {
#     enabled = true
#     days = 90
#   }

#    traffic_analytics {
#      enabled                = true
#      workspace_id           = data.azurerm_log_analytics_workspace.flow_logs_law.workspace_id
#      workspace_region       = "australiasoutheast"
#      workspace_resource_id  = data.azurerm_log_analytics_workspace.flow_logs_law.id
#      interval_in_minutes    = 10
#    }      
# }