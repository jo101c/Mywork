
#----------------------------------------------------------------------------------------------#
#                            Platform Management Diagnostic Settings                           #
#----------------------------------------------------------------------------------------------#

resource "azurerm_monitor_diagnostic_setting" "management" {
  provider = azurerm.management
  count    = var.environment == "prod" ? 1 : 0

  name                       = "AllLogs"
  target_resource_id         = "/subscriptions/48c5ee80-e91b-4294-ba0e-6f21a11dd870"
  log_analytics_workspace_id = var.monitoring_workspace_id

  dynamic "log" {
    for_each = local.log_types
    content {
      category = log.value
      enabled  = true

    }
  }
}

#----------------------------------------------------------------------------------------------#
#                            Platform Identity Diagnostic Settings                             #
#----------------------------------------------------------------------------------------------#

resource "azurerm_monitor_diagnostic_setting" "identity" {
  provider = azurerm.identity
  count    = var.environment == "prod" ? 1 : 0

  name                       = "AllLogs"
  target_resource_id         = "/subscriptions/c6229714-28a5-4683-a0b2-74856f89dd2f"
  log_analytics_workspace_id = var.monitoring_workspace_id

  dynamic "log" {
    for_each = local.log_types
    content {
      category = log.value
      enabled  = true

    }
  }
}

#----------------------------------------------------------------------------------------------#
#                              Platform Hub Diagnostic Settings                                #
#----------------------------------------------------------------------------------------------#

resource "azurerm_monitor_diagnostic_setting" "hub" {
  provider = azurerm.hub
  count    = var.environment == "prod" ? 1 : 0

  name                       = "AllLogs"
  target_resource_id         = "/subscriptions/64c740c5-c455-4f78-b78a-a080fad5becb"
  log_analytics_workspace_id = var.monitoring_workspace_id

  dynamic "log" {
    for_each = local.log_types
    content {
      category = log.value
      enabled  = true

    }
  }
}