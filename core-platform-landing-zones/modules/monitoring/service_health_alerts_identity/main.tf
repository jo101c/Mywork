
#----------------------------------------------------------------------------------------------#
#                              Platform Identity Service Health Alerts                         #
#----------------------------------------------------------------------------------------------#

resource "azurerm_resource_group" "default" {
  provider = azurerm.identity
  count    = var.environment == "prod" ? 1 : 0

  name     = "rg-ae-pr-platform-identity-service-alerts"
  location = "Australia East"
  tags     = local.tags
}


resource "azurerm_monitor_activity_log_alert" "service_health_identity" {
  provider = azurerm.identity
  count    = var.environment == "prod" ? 1 : 0

  name                = "service-health-platform-identity"
  resource_group_name = var.environment == "prod" ? azurerm_resource_group.default[0].name : ""
  scopes              = ["/subscriptions/c6229714-28a5-4683-a0b2-74856f89dd2f"]
  description         = "Service Health Alerts for Platform Identity Subscription"
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