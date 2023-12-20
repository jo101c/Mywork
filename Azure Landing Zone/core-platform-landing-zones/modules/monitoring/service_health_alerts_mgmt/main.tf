
#----------------------------------------------------------------------------------------------#
#                              Platform Management Service Health Alerts                       #
#----------------------------------------------------------------------------------------------#


resource "azurerm_monitor_activity_log_alert" "service_health_mgmt" {
  provider = azurerm.management
  count    = var.environment == "prod" ? 1 : 0

  name                = "service-health-platform-mgmt"
  resource_group_name = var.monitoring_rg_name
  scopes              = ["/subscriptions/48c5ee80-e91b-4294-ba0e-6f21a11dd870"]
  description         = "Service Health Alerts for Platform Management Subscription"
  enabled             = true

  criteria {
    category = "ServiceHealth"
    service_health {
      events    = null
      locations = ["Australia East"]
      services  = null
    }
  }

  action {
    action_group_id = var.service_health_action_group_id
  }

  tags = local.tags
}