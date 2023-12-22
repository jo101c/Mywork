module "sql_server" {
  source = "git::https://anglefinanceauto@dev.azure.com/anglefinanceauto/Shared/_git/terraform-azurerm-sqlserver?ref=v2.2.3"

  providers = {
    azurerm.shared_subscription = azurerm
    azurerm.internal_shared     = azurerm.internal_shared
    azurerm.internal_prod       = azurerm.internal_prod
  }

  service                     = var.service
  region                      = var.region
  environment                 = var.environment
  function                    = var.function
  resource_group_name         = module.aa_infra.vars["data_rg"].name
  network_resource_group_name = module.aa_infra.vars["network_rg"].name
  subnet_id                   = module.aa_infra.vars["nerdio_subnet"].id
  tde_key_vault_id            = module.aa_infra.vars["key_vault"].id

  azuread_authentication_only = true

  tags = local.tags
}

# Add Nerdio Manager Service Principal Object ID to SQL admins AD group
resource "azuread_group_member" "ad_application_nerdio_manager_sql_admin" {
  group_object_id  = module.sql_server.permission_groups.sql_admins
  member_object_id = azuread_service_principal.nerdio_manager.object_id
}

# Create the database for Nerdio
resource "azurerm_mssql_database" "nerdio" {
  name      = "Nerdio"
  server_id = module.sql_server.id
  collation = "Latin1_General_CI_AS"
  sku_name  = "S0"

  zone_redundant = false

  tags = merge(
    local.tags,
    { name = "Nerdio" }
  )
}
