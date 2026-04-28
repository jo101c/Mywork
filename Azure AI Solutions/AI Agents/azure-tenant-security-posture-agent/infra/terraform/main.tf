resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_consumption_budget_resource_group" "main" {
  name              = "budget-tenantsecagent-${var.environment}"
  resource_group_id = azurerm_resource_group.main.id
  amount            = var.budget_amount
  time_grain        = "Monthly"

  time_period {
    start_date = var.budget_start_date
  }

  notification {
    enabled        = true
    threshold      = 50
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = var.budget_contact_emails
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = var.budget_contact_emails
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = var.budget_contact_emails
  }
}

resource "random_string" "sa_suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_storage_account" "main" {
  name                            = lower(local.storage_account_name)
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  https_traffic_only_enabled      = true
  tags                            = var.tags

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "reports" {
  name                  = local.report_container_name
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "findings" {
  name                  = local.findings_container_name
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_application_insights" "main" {
  name                = var.application_insights_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_key_vault" "main" {
  name                          = var.key_vault_name
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  public_network_access_enabled = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  rbac_authorization_enabled    = true
  tags                          = var.tags
}

resource "azurerm_user_assigned_identity" "agent" {
  location            = azurerm_resource_group.main.location
  name                = var.identity_name
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_key_vault_secret" "teams_summary_webhook_url" {
  name         = "teams-summary-webhook-url"
  value        = var.teams_summary_webhook_url
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "teams_qna_shared_secret" {
  name         = "teams-qna-shared-secret"
  value        = var.teams_qna_shared_secret
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_service_plan" "main" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "EP1"
  tags                = var.tags
}

resource "azurerm_linux_function_app" "main" {
  name                          = var.function_app_name
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  service_plan_id               = azurerm_service_plan.main.id
  storage_account_name          = azurerm_storage_account.main.name
  storage_account_access_key    = azurerm_storage_account.main.primary_access_key
  functions_extension_version   = "~4"
  https_only                    = true
  public_network_access_enabled = true
  tags                          = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.agent.id]
  }

  site_config {
    application_insights_connection_string = azurerm_application_insights.main.connection_string
    application_stack {
      python_version = "3.11"
    }
    ftps_state              = "Disabled"
    minimum_tls_version     = "1.2"
    scm_minimum_tls_version = "1.2"
    always_on               = true
    use_32_bit_worker       = false
  }

  app_settings = {
    "AZURE_OPENAI_ENDPOINT"          = azurerm_cognitive_account.openai.endpoint
    "AZURE_OPENAI_DEPLOYMENT"        = azurerm_cognitive_deployment.chat.name
    "AZURE_SUBSCRIPTION_ID"          = var.subscription_id
    "REPORT_BLOB_CONTAINER"          = local.report_container_name
    "FINDINGS_BLOB_CONTAINER"        = local.findings_container_name
    "STORAGE_ACCOUNT_NAME"           = azurerm_storage_account.main.name
    "REPORT_MAILBOX_FROM"            = var.report_mailbox_from
    "REPORT_MAILBOX_TO"              = var.report_mailbox_to
    "TEAMS_SUMMARY_WEBHOOK_URL"      = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.teams_summary_webhook_url.versionless_id})"
    "TEAMS_QNA_SHARED_SECRET"        = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.teams_qna_shared_secret.versionless_id})"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
  }
}

resource "azurerm_cognitive_account" "openai" {
  name                          = var.openai_account_name
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  custom_subdomain_name         = var.openai_account_name
  public_network_access_enabled = true
  local_auth_enabled            = false
  tags                          = var.tags
}

resource "azurerm_cognitive_deployment" "chat" {
  name                 = var.model_deployment_name
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = var.model_name
    version = var.model_version
  }

  sku {
    name     = var.model_sku_name
    capacity = var.model_capacity
  }
}

resource "azurerm_role_assignment" "identity_reader" {
  scope                = var.scan_scope
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.agent.principal_id
}

resource "azurerm_role_assignment" "identity_security_reader" {
  scope                = var.scan_scope
  role_definition_name = "Security Reader"
  principal_id         = azurerm_user_assigned_identity.agent.principal_id
}

resource "azurerm_role_assignment" "identity_resource_policy_reader" {
  scope                = var.scan_scope
  role_definition_name = "Resource Policy Reader"
  principal_id         = azurerm_user_assigned_identity.agent.principal_id
}

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.agent.principal_id
}

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.agent.principal_id
}

resource "azurerm_role_assignment" "openai_user" {
  scope                = azurerm_cognitive_account.openai.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_user_assigned_identity.agent.principal_id
}

data "azuread_service_principal" "msgraph" {
  client_id = "00000003-0000-0000-c000-000000000000"
}

resource "azuread_app_role_assignment" "mail_send" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Mail.Send"]
  principal_object_id = azurerm_user_assigned_identity.agent.principal_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}
