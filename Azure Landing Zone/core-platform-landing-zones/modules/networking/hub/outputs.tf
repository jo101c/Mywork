output "hub_vnet" {
  value = {
    hub_vnet_id                  = azurerm_virtual_network.hub_vnet.id
    hub_vnet_resource_group_name = azurerm_virtual_network.hub_vnet.resource_group_name
    hub_vnet_name                = azurerm_virtual_network.hub_vnet.name
    hub_vnet_gw_subnet_id        = azurerm_subnet.gateway.id
    hub_vnet_gw_subnet_name      = azurerm_subnet.gateway.name
    hub_vnet_fw_subnet_id        = azurerm_subnet.azurefirewall.id
    hub_vnet_fw_subnet_name      = azurerm_subnet.azurefirewall.name
  }
}