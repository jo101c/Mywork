variable "environment" {
  description = "The environment (prod/nonprod)"
  type        = string
}

variable "monitoring_workspace_id" {
  description = "Resource ID of the Monitoring Log Analytics Workspace"
  type        = string
}