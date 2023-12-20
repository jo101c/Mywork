
output "monitoring_action_group_ids" {
  value = {
    service_health = length(azurerm_monitor_action_group.service_health) > 0 ? azurerm_monitor_action_group.service_health[0].id : null
  }
}