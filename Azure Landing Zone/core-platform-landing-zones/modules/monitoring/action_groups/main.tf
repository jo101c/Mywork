
#----------------------------------------------------------------------------------------------#
#                                   Service Health Action Group                                #
#----------------------------------------------------------------------------------------------#

resource "azurerm_monitor_action_group" "service_health" {
  provider = azurerm.management
  count    = var.environment == "prod" ? 1 : 0

  name                = "ServiceHealthManagement"
  resource_group_name = var.monitoring_rg_name
  short_name          = "healthmgmt"

  webhook_receiver {
    name                    = "callmyapi"
    service_uri             = "http://example.com/alert" #Update with Freshservice webhook
    use_common_alert_schema = true
  }

  tags = local.tags

}