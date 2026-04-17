variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  type        = string
}

variable "hub_vnet_resource_group_name" {
  description = "Name of the resource group containing the hub virtual network."
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network."
  type        = string
}

variable "hub_vnet_gw_subnet_id" {
  description = "Resource ID of the gateway subnet in the hub virtual network."
  type        = string
}

variable "hub_vnet_gw_subnet_name" {
  description = "Name of the gateway subnet in the hub virtual network."
  type        = string
}

variable "hub_vnet_fw_subnet_id" {
  description = "Resource ID of the AzureFirewallSubnet in the hub virtual network."
  type        = string
}

variable "hub_vnet_fw_subnet_name" {
  description = "Name of the Azure Firewall subnet in the hub virtual network."
  type        = string
}

variable "name" {
  description = "Name of the Azure Firewall."
  type        = string
  default     = "azfw-example-01"
}

variable "resource_group_name" {
  description = "Name of the resource group for the Azure Firewall."
  type        = string
  default     = "rg-example-network-01"
}

variable "location" {
  description = "Azure region for deployment."
  type        = string
  default     = "eastus"
}

variable "sku_name" {
  description = "Azure Firewall SKU name."
  type        = string
  default     = "AZFW_VNet"

  validation {
    condition     = contains(["AZFW_Hub", "AZFW_VNet"], var.sku_name)
    error_message = "Must be one of: AZFW_Hub, AZFW_VNet."
  }
}

variable "sku_tier" {
  description = "Azure Firewall SKU tier."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Premium", "Standard"], var.sku_tier)
    error_message = "Must be one of: Premium, Standard."
  }
}

variable "dns_servers" {
  description = "Optional list of DNS servers used by Azure Firewall."
  type        = list(string)
  default     = null
}

variable "threat_intelligence_mode" {
  description = "Threat intelligence mode for Azure Firewall."
  type        = string
  default     = "Alert"

  validation {
    condition     = contains(["Off", "Alert", "Deny", ""], var.threat_intelligence_mode)
    error_message = "Must be one of: Off, Alert, Deny, or empty string."
  }
}

variable "firewall_policy_id" {
  description = "Optional resource ID of the Azure Firewall Policy."
  type        = string
  default     = null

  validation {
    condition     = can(regex("^(?i:/subscriptions/.+?/resourceGroups/.+?/providers/Microsoft.Network/firewallPolicies/.+|null)$", format("%v", var.firewall_policy_id)))
    error_message = "Must be a valid Firewall Policy ID."
  }
}

variable "private_ip_ranges" {
  description = "Optional list of private IP ranges excluded from SNAT."
  type        = list(string)
  default     = null
}

variable "firewall_zones" {
  description = "Availability zones for Azure Firewall deployment."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "law_id" {
  description = "Optional Log Analytics Workspace resource ID."
  type        = string
  default     = null
}