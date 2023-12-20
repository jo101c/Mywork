variable "environment" {
  description = "The environment (prod/nonprod)"
  type        = string
}

variable "hub_vnet_id" {
  description = "The hub vnet ID"
  type        = string
}

variable "hub_vnet_resource_group_name" {
  description = "The hub vnet resource group"
  type        = string
}

variable "hub_vnet_name" {
  description = "The hub vnet name"
  type        = string
}

variable "monitoring_workspace_id" {
  description = "Resource ID of the Monitoring Log Analytics Workspace"
  type        = string
}