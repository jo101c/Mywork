output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "function_app_name" {
  value = azurerm_linux_function_app.main.name
}

output "function_qna_url" {
  value = "https://${azurerm_linux_function_app.main.default_hostname}/api/teams/qna"
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "key_vault_name" {
  value = azurerm_key_vault.main.name
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}

output "model_deployment_name" {
  value = azurerm_cognitive_deployment.chat.name
}

output "managed_identity_principal_id" {
  value = azurerm_user_assigned_identity.agent.principal_id
}
