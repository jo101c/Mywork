
# SQL DB Resource Alert Rule Variables
variable "sql_metric_alerts" {
  description = "Shared configuration applied to all SQL metric alerts."
  type = object({
    name        = string
    description = string
    frequency   = string
    severity    = number
    window_size = string
  })
  default = {
    name        = "Alert Prod SQL DB"
    description = "Alerts for Prod SQL"
    frequency   = "PT5M"
    severity    = 2
    window_size = "PT5M"
  }
}

# VM Resource Alert Rule Variables
variable "vm_metric_alerts" {
  description = "Shared configuration applied to all VM metric alerts."
  type = object({
    name        = string
    description = string
    frequency   = string
    severity    = number
    window_size = string
  })
  default = {
    name        = "Alert Prod VM"
    description = "Alerts for Prod App & Web Servers"
    frequency   = "PT1M"
    severity    = 2
    window_size = "PT1M"
  }
}

# Alert Rule Tags
variable "tags" {
  description = "Tags applied to the created metric alerts."
  type        = map(string)
  default = {
    deployment      = "terraform"
    environment     = "prod"
    businessprocess = "infra"
    repository      = "portfolio/mywork"
  }
}

# Scopes for sql db resources
variable "scopes_sql" {
  description = "Target resource IDs for SQL alerts."
  type        = list(string)
  default     = ["/subscriptions/*"]
}

# Scopes for vm resources
variable "scopes_vm" {
  description = "Target resource IDs for VM alerts."
  type        = list(string)
  default     = ["/subscriptions/*"]
}

variable "resource_group_name" {
  description = "Resource group containing the alert rules and action group."
  type        = string
}

variable "action_group_name" {
  description = "Azure Monitor action group name to attach to each alert."
  type        = string
}

variable "action_group_resource_group_name" {
  description = "Optional override for the action group's resource group. Defaults to resource_group_name."
  type        = string
  default     = null
}
