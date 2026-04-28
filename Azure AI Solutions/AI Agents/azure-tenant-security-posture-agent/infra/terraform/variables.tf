variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID."
}

variable "location" {
  type        = string
  description = "Primary Azure region."
  default     = "australiaeast"
}

variable "environment" {
  type        = string
  description = "Environment name."
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
  default     = "rg-tenantsecagent-dev-aue"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name."
  default     = "sttenantsecagentaue01"
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault name."
  default     = "kv-tenantsecagent-aue"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics workspace name."
  default     = "log-tenantsecagent-dev-aue"
}

variable "application_insights_name" {
  type        = string
  description = "Application Insights name."
  default     = "appi-tenantsecagent-dev-aue"
}

variable "service_plan_name" {
  type        = string
  description = "Function App plan name."
  default     = "asp-tenantsecagent-dev-aue"
}

variable "function_app_name" {
  type        = string
  description = "Function App name."
  default     = "func-tenantsecagent-dev-aue"
}

variable "identity_name" {
  type        = string
  description = "User-assigned managed identity name."
  default     = "id-tenantsecagent-dev-aue"
}

variable "openai_account_name" {
  type        = string
  description = "Azure OpenAI account name."
  default     = "oai-tenantsecagent-aue"
}

variable "model_deployment_name" {
  type        = string
  description = "Azure OpenAI deployment name."
  default     = "gpt-4-1-mini-security-agent"
}

variable "model_name" {
  type        = string
  description = "Azure OpenAI model name."
  default     = "gpt-4.1-mini"
}

variable "model_version" {
  type        = string
  description = "Azure OpenAI model version."
  default     = "2025-04-14"
}

variable "model_sku_name" {
  type        = string
  description = "Azure OpenAI deployment SKU."
  default     = "GlobalStandard"
}

variable "model_capacity" {
  type        = number
  description = "Azure OpenAI deployment capacity."
  default     = 10
}

variable "budget_amount" {
  type        = number
  description = "Monthly budget alert amount."
  default     = 100
}

variable "budget_contact_emails" {
  type        = list(string)
  description = "Budget alert recipients."
}

variable "budget_start_date" {
  type        = string
  description = "Budget start date in RFC3339."
  default     = "2026-04-01T00:00:00Z"
}

variable "report_mailbox_from" {
  type        = string
  description = "Mailbox used to send reports through Microsoft Graph."
}

variable "report_mailbox_to" {
  type        = string
  description = "Comma-separated destination email list."
}

variable "teams_summary_webhook_url" {
  type        = string
  description = "Teams summary delivery endpoint."
  sensitive   = true
}

variable "teams_qna_shared_secret" {
  type        = string
  description = "Shared secret required by the Q&A endpoint."
  sensitive   = true
}

variable "scan_scope" {
  type        = string
  description = "Scope used for tenant-wide role assignments, typically the root management group resource ID."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to supported resources."
  default = {
    workload      = "azure-tenant-security-specialist-agent"
    environment   = "dev"
    cost-control  = "delete-after-demo"
    deployed-with = "terraform"
  }
}

