variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the activity log alert instance. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "(Required) The name of the activity log alert. Changing this forces a new resource to be created."
  type        = string
}

variable "description" {
  description = " (Optional) The description of this activity log alert."
  type        = string
  default     = null
}

variable "scopes" {
  description = "(Required) The Scope at which the Activity Log should be applied. A list of strings which could be a resource group , or a subscription, or a resource ID (such as a Storage Account)."
  type        = list(string)
}

variable "criteria" {
  description = <<-EOF
  (Required) A criteria block as defined below.
  category - (Required) The category of the operation. Possible values are Administrative, Autoscale, Policy, Recommendation, ResourceHealth, Security and ServiceHealth.
  operation_name - (Optional) The Resource Manager Role-Based Access Control operation name. Supported operation should be of the form: <resourceProvider>/<resourceType>/<operation>.
  resource_provider - (Optional) The name of the resource provider monitored by the activity log alert.
  resource_type - (Optional) The resource type monitored by the activity log alert.
  resource_group - (Optional) The name of resource group monitored by the activity log alert.
  resource_id - (Optional) The specific resource monitored by the activity log alert. It should be within one of the scopes.
  caller - (Optional) The email address or Azure Active Directory identifier of the user who performed the operation.
  level - (Optional) The severity level of the event. Possible values are Verbose, Informational, Warning, Error, and Critical.
  status - (Optional) The status of the event. For example, Started, Failed, or Succeeded.
  sub_status - (Optional) The sub status of the event.
  recommendation_type - (Optional) The recommendation type of the event. It is only allowed when category is Recommendation.
  recommendation_category - (Optional) The recommendation category of the event. Possible values are Cost, Reliability, OperationalExcellence, HighAvailability and Performance. It is only allowed when category is Recommendation.
  recommendation_impact - (Optional) The recommendation impact of the event. Possible values are High, Medium and Low. It is only allowed when category is Recommendation.

  service_health - (Optional) A block to define fine grain service health settings. Set to null if not required
    events - (Optional) Events this alert will monitor Possible values are Incident, Maintenance, Informational, ActionRequired and Security.
    locations - (Optional) Locations this alert will monitor. For example, West Europe.
    services - (Optional) Services this alert will monitor. For example, Activity Logs & Alerts, Action Groups. Defaults to all Services.
  EOF

  type = object({
    category                = string
    operation_name          = string
    resource_provider       = string
    resource_type           = string
    resource_group          = string
    resource_id             = string
    caller                  = string
    level                   = string
    status                  = string
    sub_status              = string
    recommendation_type     = string
    recommendation_category = string
    recommendation_impact   = string

    service_health = object({
      events    = list(string)
      locations = list(string)
      services  = list(string)
    })
  })

  default = null
}


variable "actions" {
  description = <<-EOF
  (Required) A list of objects specifying the Action Groups for this activity alert.
  action_group_id - (Required) The ID of the Action Group can be sourced from the azurerm_monitor_action_group resource.
  webhook_properties - (Optional) The map of custom string properties to include with the post operation. These data are appended to the webhook payload.
  EOF

  type = list(object({
    action_group_id    = string
    webhook_properties = map(string)
  }))

  default = null
}