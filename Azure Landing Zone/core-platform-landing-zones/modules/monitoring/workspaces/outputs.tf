output "workspaces" {
  value = {
    monitoring_rg_name           = azurerm_resource_group.monitoring.name
    monitoring_region            = azurerm_resource_group.monitoring.location
    monitoring_workspace_cust_id = azurerm_log_analytics_workspace.monitoring.workspace_id
    monitoring_workspace_name    = azurerm_log_analytics_workspace.monitoring.name
    monitoring_workspace_id      = azurerm_log_analytics_workspace.monitoring.id
  }
}