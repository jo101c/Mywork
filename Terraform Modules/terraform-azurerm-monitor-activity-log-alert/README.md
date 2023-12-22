<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
<!-- Developer Input -->
# terraform-azurerm-monitor-activity-log-alert

## Overview
Manages an Activity Log Alert within Azure Monitor.

You create an alert rule by combining the resources to be monitored, the monitoring data from the resource, and the conditions that you want to trigger the alert. You can then define action groups and alert processing rules to determine what happens when an alert is triggered.

Alerts triggered by these alert rules contain a payload that uses the common alert schema.

### Prerequisites
- None

### Features
- Creation and management of Azure monitor scheduled query rule alerts.

### Limitations
- None.

### Default Alerts
- None

### Documentation
- <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert>
- <https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule?tabs=activity-log>
<!-- Developer Input -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_activity_log_alert.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_actions"></a> [actions](#input\_actions) | (Required) A list of objects specifying the Action Groups for this activity alert.<br>action\_group\_id - (Required) The ID of the Action Group can be sourced from the azurerm\_monitor\_action\_group resource.<br>webhook\_properties - (Optional) The map of custom string properties to include with the post operation. These data are appended to the webhook payload. | <pre>list(object({<br>    action_group_id    = string<br>    webhook_properties = map(string)<br>  }))</pre> | `null` | no |
| <a name="input_criteria"></a> [criteria](#input\_criteria) | (Required) A criteria block as defined below.<br>category - (Required) The category of the operation. Possible values are Administrative, Autoscale, Policy, Recommendation, ResourceHealth, Security and ServiceHealth.<br>operation\_name - (Optional) The Resource Manager Role-Based Access Control operation name. Supported operation should be of the form: <resourceProvider>/<resourceType>/<operation>.<br>resource\_provider - (Optional) The name of the resource provider monitored by the activity log alert.<br>resource\_type - (Optional) The resource type monitored by the activity log alert.<br>resource\_group - (Optional) The name of resource group monitored by the activity log alert.<br>resource\_id - (Optional) The specific resource monitored by the activity log alert. It should be within one of the scopes.<br>caller - (Optional) The email address or Azure Active Directory identifier of the user who performed the operation.<br>level - (Optional) The severity level of the event. Possible values are Verbose, Informational, Warning, Error, and Critical.<br>status - (Optional) The status of the event. For example, Started, Failed, or Succeeded.<br>sub\_status - (Optional) The sub status of the event.<br>recommendation\_type - (Optional) The recommendation type of the event. It is only allowed when category is Recommendation.<br>recommendation\_category - (Optional) The recommendation category of the event. Possible values are Cost, Reliability, OperationalExcellence, HighAvailability and Performance. It is only allowed when category is Recommendation.<br>recommendation\_impact - (Optional) The recommendation impact of the event. Possible values are High, Medium and Low. It is only allowed when category is Recommendation.<br><br>service\_health - (Optional) A block to define fine grain service health settings. Set to null if not required<br>  events - (Optional) Events this alert will monitor Possible values are Incident, Maintenance, Informational, ActionRequired and Security.<br>  locations - (Optional) Locations this alert will monitor. For example, West Europe.<br>  services - (Optional) Services this alert will monitor. For example, Activity Logs & Alerts, Action Groups. Defaults to all Services. | <pre>object({<br>    category                = string<br>    operation_name          = string<br>    resource_provider       = string<br>    resource_type           = string<br>    resource_group          = string<br>    resource_id             = string<br>    caller                  = string<br>    level                   = string<br>    status                  = string<br>    sub_status              = string<br>    recommendation_type     = string<br>    recommendation_category = string<br>    recommendation_impact   = string<br><br>    service_health = object({<br>      events    = list(string)<br>      locations = list(string)<br>      services  = list(string)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of this activity log alert. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the activity log alert. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the activity log alert instance. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_scopes"></a> [scopes](#input\_scopes) | (Required) The Scope at which the Activity Log should be applied. A list of strings which could be a resource group , or a subscription, or a resource ID (such as a Storage Account). | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The resource id of the monitor activity log alert. |
| <a name="output_name"></a> [name](#output\_name) | The name of the monitor activity log alert. |

## Usage
Basic Usage of this module as follows:
```hcl
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
```
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->