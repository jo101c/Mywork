resource "azurerm_monitor_activity_log_alert" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  scopes              = var.scopes
  description         = var.description

  dynamic "criteria" {
    for_each = var.criteria[*] # This will only evaluate between 0-1 loop as this is a map.

    content {
      category                = var.criteria.category
      operation_name          = var.criteria.operation_name
      resource_provider       = var.criteria.resource_provider
      resource_type           = var.criteria.resource_type
      resource_group          = var.criteria.resource_group
      resource_id             = var.criteria.resource_id
      caller                  = var.criteria.caller
      level                   = var.criteria.level
      status                  = var.criteria.status
      sub_status              = var.criteria.sub_status
      recommendation_type     = var.criteria.recommendation_type
      recommendation_category = var.criteria.recommendation_category
      recommendation_impact   = var.criteria.recommendation_impact

      dynamic "service_health" {
        for_each = var.criteria.service_health[*]

        content {
          events    = service_health.value.events
          locations = service_health.value.locations
          services  = service_health.value.services
        }
      }
    }
  }

  dynamic "action" {
    for_each = var.actions != null ? var.actions : []

    content {
      action_group_id    = action.value.action_group_id
      webhook_properties = action.value.webhook_properties
    }
  }
}
