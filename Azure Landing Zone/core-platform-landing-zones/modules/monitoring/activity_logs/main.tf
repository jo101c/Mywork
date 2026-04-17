
#----------------------------------------------------------------------------------------------#
#                            Platform Management Diagnostic Settings                           #
#----------------------------------------------------------------------------------------------#

resource "azurerm_monitor_diagnostic_setting" "management" {
  provider = azurerm.management
  count    = var.environment == "prod" ? 1 : 0

  name                       = "AllLogs"
  target_resource_id         = "/subscriptions/<sub id>"
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
  target_resource_id         = "/subscriptions/<sub id>"
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
  target_resource_id         = "/subscriptions/<sub id>"
  log_analytics_workspace_id = var.monitoring_workspace_id

  dynamic "log" {
    for_each = local.log_types
    content {
      category = log.value
      enabled  = true

    }
  }
}