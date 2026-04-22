# SQL Based Alert Rules / Criteria looped via locals for new alert rules
# Scope can be updated for adding new resource scopes
resource "azurerm_monitor_metric_alert" "metric_alerts_sql" {

  for_each = local.criteria_sql

  name                = each.value.alert_name
  resource_group_name = data.azurerm_resource_group.default.name
  scopes              = var.scopes_sql
  description         = var.sql_metric_alerts.description
  tags                = var.tags
  frequency           = var.sql_metric_alerts.frequency
  severity            = var.sql_metric_alerts.severity
  window_size         = var.sql_metric_alerts.window_size
  enabled             = true

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold

    skip_metric_validation = true
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.ambit_team.id
  }
}

# VM Based Alert Rules / Criteria looped via locals for new alert rules
# Scope can be updated for adding new resource scopes
resource "azurerm_monitor_metric_alert" "metric_alerts_vm" {

  for_each = local.criteria_vm

  name                = each.value.alert_name
  resource_group_name = data.azurerm_resource_group.default.name
  scopes              = var.scopes_vm
  description         = var.vm_metric_alerts.description
  tags                = var.tags
  frequency           = var.vm_metric_alerts.frequency
  severity            = var.vm_metric_alerts.severity
  window_size         = var.vm_metric_alerts.window_size
  enabled             = true

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold

    skip_metric_validation = true
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.ambit_team.id
  }
}
