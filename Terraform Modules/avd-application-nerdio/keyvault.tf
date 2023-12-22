resource "azurerm_role_assignment" "nerdio_webapp_secrets_officer" {
  scope                = module.aa_infra.vars["key_vault"].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_windows_web_app.nerdio.identity[0].principal_id
}

resource "azurerm_role_assignment" "nerdio_app_secrets_user" {
  scope                = module.aa_infra.vars["key_vault"].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.nerdio_manager.object_id
}

resource "azurerm_key_vault_secret" "azuread_client_secret" {
  name         = "AzureAD--ClientSecret" # Name is dictated by Nerdio
  value        = azuread_application_password.nerdio_manager.value
  key_vault_id = module.aa_infra.vars["key_vault"].id
}

# https://nmw.zendesk.com/hc/en-us/articles/4731671900567-Azure-AD-SQL-Authentication
resource "azurerm_key_vault_secret" "sql_connection" {
  name = "ConnectionStrings--DefaultConnection" # Name is dictated by Nerdio
  value = join(";", [
    "Server=tcp:${module.sql_server.fully_qualified_domain_name},1433",
    "Authentication=Active Directory Service Principal",
    "Database=${azurerm_mssql_database.nerdio.name}",
    "Initial Catalog=${azurerm_mssql_database.nerdio.name}",
    "Persist Security Info=False",
    "User ID=${azuread_application.nerdio_manager.application_id}",
    "Password=${azuread_application_password.nerdio_manager.value}",
    "MultipleActiveResultSets=False",
    "Encrypt=True",
    "TrustServerCertificate=False",
    "Connection Timeout=30",
    "" # Ensure the connection string ends with a semi-colon.
  ])
  key_vault_id = module.aa_infra.vars["key_vault"].id
}
