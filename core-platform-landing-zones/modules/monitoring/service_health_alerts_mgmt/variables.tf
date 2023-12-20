variable "environment" {
  description = "The environment (prod/nonprod)"
  type        = string
}

variable "service_health_action_group_id" {
  description = "Service Health action group ID"
  type        = string
}

variable "monitoring_rg_name" {
  description = "Monitoring resource group name"
  type        = string
}