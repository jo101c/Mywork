
#----------------------------------------------------------------------------------------------#
#                                          Routes                                              #
#----------------------------------------------------------------------------------------------#


resource "azurerm_route_table" "default" {
  provider = azurerm.management

  name                          = "rt-ae-management"
  location                      = azurerm_resource_group.default.location
  resource_group_name           = azurerm_resource_group.default.name
  disable_bgp_route_propagation = false
}

resource "azurerm_route" "default" {
  provider = azurerm.management

  name                   = "default-route"
  resource_group_name    = azurerm_resource_group.default.name
  route_table_name       = azurerm_route_table.default.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.environment == "prod" ? "10.11.1.20" : "10.12.1.20"
}

#----------------------------------------------------------------------------------------------#
#                                      Route Associations                                      #
#----------------------------------------------------------------------------------------------#


resource "azurerm_subnet_route_table_association" "management" {
  provider = azurerm.management

  subnet_id      = azurerm_subnet.management.id
  route_table_id = azurerm_route_table.default.id
}