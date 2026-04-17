output "id" {
  description = "The ID of the Azure Firewall."
  value       = azurerm_firewall.fw.id
}

output "private_ip_address" {
  description = "The first Private IP Address of the Azure Firewall."
  value       = one(compact(azurerm_firewall.fw.ip_configuration[*].private_ip_address))
}


output "public_ip_ids" {
  description = "The map of Azure Firewall public IP IDs."
  value       = azurerm_public_ip.pip_azfw.id
}

output "firewall_name" {
  value = azurerm_firewall.fw.name
}

output "firewall_policy_id" {
  value = azurerm_firewall_policy.azfw_policy.id
} 