
#----------------------------------------------------------------------------------------------#
#                              Platform Hub Service Health Alerts                              #
#----------------------------------------------------------------------------------------------#

resource "azurerm_resource_group" "default" {
  provider = azurerm.hub
  count    = var.environment == "prod" ? 1 : 0

  name     = "rg-ae-pr-platform-hub-service-alerts"
  location = "Australia East"
  tags     = local.tags
}


resource "azurerm_monitor_activity_log_alert" "service_health_hub" {
  provider = azurerm.hub
  count    = var.environment == "prod" ? 1 : 0

  name                = "service-health-platform-hub"
  resource_group_name = var.environment == "prod" ? azurerm_resource_group.default[0].name : ""
  scopes              = ["/subscriptions/64c740c5-c455-4f78-b78a-a080fad5becb"]
  description         = "Service Health Alerts for Platform Hub Subscription"
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