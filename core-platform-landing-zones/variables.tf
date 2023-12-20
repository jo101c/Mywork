variable "location" {
  default = "Australia East"
}

variable "environment" {
  description = "The environment (prod/nonprod)"
  type        = string
}

variable "CLIENT_ID" {
  description = "Service Principal Client ID"
  type        = string
}

variable "ARM_IDENTITY_SUBSCRIPTION_ID" {
  description = "Subscription ID for Identity"
  type        = string
}

variable "ARM_MANAGEMENT_SUBSCRIPTION_ID" {
  description = "Subscription ID for Management"
  type        = string
}

variable "ARM_HUB_SUBSCRIPTION_ID" {
  description = "Subscription ID for Hub"
  type        = string
}
