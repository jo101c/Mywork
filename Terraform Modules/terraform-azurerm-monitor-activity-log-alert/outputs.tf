output "name" {
  description = "The name of the monitor activity log alert."
  value       = azurerm_monitor_activity_log_alert.this.name
}

output "id" {
  description = "The resource id of the monitor activity log alert."
  value       = azurerm_monitor_activity_log_alert.this.id
}