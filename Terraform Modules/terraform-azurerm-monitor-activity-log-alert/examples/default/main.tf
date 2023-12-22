module "test-activity-alert" {
  source = "git::https://dev.azure.com/bupaaunz/Landing_Zones/_git/terraform-azurerm-monitor-activity-log-alert?ref=v0.1.0"

  resource_group_name = "rg-asif-test"
  name                = "rbac-activity-alert"
  description         = "This alert will monitor for Administrative role assignments write events"
  scopes = [
    "/subscriptions/9b57dc4b-f9f6-4dfc-8215-fa64ac41a60d/resourceGroups/rg-asif-test"
  ]

  criteria = {
    resource_id             = null
    operation_name          = "Microsoft.Authorization/roleAssignments/write"
    category                = "Administrative"
    resource_provider       = null
    resource_type           = null
    resource_group          = null
    caller                  = null
    level                   = null
    status                  = null
    sub_status              = null
    recommendation_type     = null
    recommendation_category = null
    recommendation_impact   = null

    service_health = null
  }

  actions = [
    {
      action_group_id    = module.test-action-group.id
      webhook_properties = null
    }
  ]

}