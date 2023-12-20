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

variable "hub_vnet_gw_subnet_id" {
  description = "The hub vnet gateway subnet id"
  type        = string
}

variable "hub_vnet_gw_subnet_name" {
  description = "The hub vnet gateway subnet name"
  type        = string
}

variable "hub_vnet_fw_subnet_id" {
  description = "The hub vnet firewall subnet id"
  type        = string
}

variable "hub_vnet_fw_subnet_name" {
  description = "The hub vnet firewall subnet name"
  type        = string
}