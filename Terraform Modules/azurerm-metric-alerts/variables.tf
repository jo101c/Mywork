
# SQL DB Resource Alert Rule Variables
variable "sql_metric_alerts" {
  type = map(string)
  default = {
    name             = "Alert Prod SQL DB"
    # scopes           = ["/subscriptions/*"]
    description      = "Alerts for Prod SQL"
    frequency        = "PT5M"
    severity         = 2
    window_size      = "PT5M"
  }
}

# VM Resource Alert Rule Variables
variable "vm_metric_alerts" {
  type = map(string)
  default = {
    name             = "Alert Prod VM"
    #scopes          = ["/subscriptions/*]
    description      = "Alerts for Prod App & Web Servers"
    frequency        = "PT1M"
    severity         = 2
    window_size      = "PT1M"
  }
}

# Alert Rule Tags
variable "tags" {
  description = "Tags for resources"  
  type        = map(string)
  default     = {
    deployment      = "Terraform"
    environment     = "Prd"
    businessprocess = "infra"
    repository      = "shared\terraform-azurerm-monitoring-alerts"
  }
}

# Scopes for sql db resources
variable "scopes_sql" {
  description = "(Required) Scope of resources to be deployed"
  type        = list(string)
  default     = ["/subscriptions/*"]
}

# Scopes for vm resources
variable "scopes_vm" {
  description = "(Required) Scope of resources to be deployed"
  type        = list(string)
  default     = ["/subscriptions/*"]
}
