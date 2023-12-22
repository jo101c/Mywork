# https://angleauto.atlassian.net/wiki/spaces/ISD/pages/18678435/Azure+Tagging+Naming+Convention
variable "service" {
  description = "(Required) Abbreviation of Solution Service Name."
  type        = string
}

variable "function" {
  description = "(Required) Abbreviation of Solution function."
  type        = string
}

variable "classification" {
  description = "(Required) The specified data classification for the workloads."
  type        = string

  # validation {
  #   condition     = contains(["highlyProtected", "protected", "internal", "public"], upper(var.classification))
  #   error_message = "Classification must be one of: highlyProtected, protected, internal, public."
  # }
}

variable "environment" {
  description = "Environment of the deployed resources."
  type        = string

  # validation {
  #   condition     = contains(["prd", "npd", "uat", "sit", "dev", "sbx"], upper(var.environment))
  #   error_message = "Environment must be one of: prd, npd, uat, sit, dev or sbx."
  # }
}

variable "region" {
  description = "(Required) Region where the microservices will be deployed."
  type        = string
  default     = "aue"

  validation {
    condition     = contains(["aue", "ause"], lower(var.region))
    error_message = "Region must be one of: 'aue', 'ause'."
  }
}

variable "tags" {
  description = "Additonal tags to apply to all resources. https://angleauto.atlassian.net/wiki/spaces/ISD/pages/18678435/Azure+Tagging+Naming+Convention"
  type        = map(string)
  default     = {}
}

variable "criticality" {
  description = "(Required) criticality that defines the support level will be deployed."
  type        = string

  validation {
    condition     = contains(["silver", "platinum", "gold", "bronze"], var.criticality)
    error_message = "Region must be one of: silver, platinum, gold, bronze."
  }
}
variable "disaster_recovery" {
  description = "Disaster Recovery"
  type        = string
  default     = "no"
}

variable "envSubMap" {
  description = "(Required) Map Environments to Subscriptions"
  type        = map(string)
}
