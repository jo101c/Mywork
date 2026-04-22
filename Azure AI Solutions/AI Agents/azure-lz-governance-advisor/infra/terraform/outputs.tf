output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.main.name
}

output "openai_endpoint" {
  description = "Azure OpenAI endpoint."
  value       = azurerm_cognitive_account.openai.endpoint
}

output "model_deployment_name" {
  description = "Model deployment name to select in Microsoft Foundry."
  value       = azurerm_cognitive_deployment.chat.name
}

output "application_insights_name" {
  description = "Application Insights resource name when enabled."
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].name : null
}

output "application_insights_connection_string" {
  description = "Application Insights connection string when enabled."
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].connection_string : null
  sensitive   = true
}
