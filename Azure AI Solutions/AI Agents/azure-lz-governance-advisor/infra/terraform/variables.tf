variable "subscription_id" {
  description = "Azure subscription ID."
  type        = string
}

variable "location" {
  description = "Azure region for resources. Choose a region where your selected Azure OpenAI model is available."
  type        = string
  default     = "australiaeast"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, prod."
  }
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
  default     = "rg-lzadvisor-dev-aue"
}

variable "openai_account_name" {
  description = "Azure OpenAI account name. Must be globally unique for the custom subdomain."
  type        = string
  default     = "oai-lzadvisor-dev-aue"
}

variable "model_deployment_name" {
  description = "Azure OpenAI deployment name used by the Foundry agent."
  type        = string
  default     = "gpt-4-1-mini-lzadvisor"
}

variable "model_name" {
  description = "Azure OpenAI model name. The current project default is gpt-4.1-mini."
  type        = string
  default     = "gpt-4.1-mini"
}

variable "model_version" {
  description = "Model version supported in your selected region. Update this to match the model catalog."
  type        = string
  default     = "2025-04-14"
}

variable "model_sku_name" {
  description = "Deployment SKU. GlobalStandard is preferred where available; otherwise use Standard."
  type        = string
  default     = "GlobalStandard"
}

variable "model_capacity" {
  description = "Small capacity for testing. Increase only if you need more throughput."
  type        = number
  default     = 10

  validation {
    condition     = var.model_capacity >= 1
    error_message = "model_capacity must be at least 1."
  }
}

variable "budget_amount" {
  description = "Monthly budget alert amount."
  type        = number
  default     = 25

  validation {
    condition     = var.budget_amount > 0
    error_message = "budget_amount must be greater than 0."
  }
}

variable "budget_contact_emails" {
  description = "Email addresses to notify for budget alerts."
  type        = list(string)

  validation {
    condition     = length(var.budget_contact_emails) > 0
    error_message = "Provide at least one budget contact email."
  }
}

variable "budget_start_date" {
  description = "Budget start date in RFC3339 format. Azure budgets generally expect the first day of a month."
  type        = string
  default     = "2026-04-01T00:00:00Z"
}

variable "enable_application_insights" {
  description = "Enable optional Application Insights tracing support. Disabled by default to keep v1 cheap."
  type        = bool
  default     = false
}

variable "enable_local_auth" {
  description = "Enable local key-based auth on the Azure OpenAI account. Keep true for simple portal demos unless you are enforcing Entra-only access."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_name" {
  description = "Log Analytics workspace name used only when Application Insights is enabled."
  type        = string
  default     = "log-lzadvisor-dev-aue"
}

variable "application_insights_name" {
  description = "Application Insights name used only when tracing is enabled."
  type        = string
  default     = "appi-lzadvisor-dev-aue"
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default = {
    workload      = "landing-zone-governance-advisor"
    environment   = "dev"
    cost-control  = "delete-after-demo"
    deployed-with = "terraform"
  }
}
