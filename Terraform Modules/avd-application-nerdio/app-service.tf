resource "azurerm_windows_web_app" "nerdio" {
  name                      = local.web_app_name
  resource_group_name       = module.aa_infra.vars["frontend_rg"].name
  location                  = module.aa_infra.vars["frontend_rg"].location
  service_plan_id           = azurerm_service_plan.nerdio.id
  https_only                = true
  virtual_network_subnet_id = module.aa_infra.vars["virtual_network"].subnet["webapp"].id

  site_config {
    always_on           = true
    http2_enabled       = true
    minimum_tls_version = 1.2
    ftps_state          = "Disabled"
    use_32_bit_worker   = false

    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }

  app_settings = {
    # "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.nerdio.connection_string
    "ApplicationInsights:ConnectionString"   = azurerm_application_insights.nerdio.connection_string
    "ApplicationInsights:InstrumentationKey" = azurerm_application_insights.nerdio.instrumentation_key
    "AzureAd:Instance"                       = "https://login.microsoftonline.com/"
    "AzureAd:ClientId"                       = azuread_application.nerdio_manager.application_id
    "AzureAd:TenantId"                       = data.azurerm_subscription.current.tenant_id
    "Billing:Mode"                           = "MAU"
    "Deployment:AutomationAccountName"       = azurerm_automation_account.nerdio.name
    "Deployment:AutomationEnabled"           = "True"
    "Deployment:AzureTagPrefix"              = "NMW"
    "Deployment:AzureType"                   = "AzureCloud"
    "Deployment:KeyVaultName"                = module.aa_infra.vars["key_vault"].name
    "Deployment:LogAnalyticsWorkspace"       = azurerm_log_analytics_workspace.nerdio.id
    "Deployment:Region"                      = module.aa_infra.vars["frontend_rg"].location
    "Deployment:ResourceGroupName"           = module.aa_infra.vars["frontend_rg"].name
    "Deployment:ScriptedActionAccount"       = azurerm_automation_account.nerdio.id
    "Deployment:SubscriptionId"              = data.azurerm_subscription.current.subscription_id
    "Deployment:SubscriptionDisplayName"     = data.azurerm_subscription.current.display_name
    "Deployment:TenantId"                    = data.azurerm_subscription.current.tenant_id
    "Deployment:UpdaterRunbookRunAs"         = "nmwUpdateRunAs"
    "Deployment:WebAppName"                  = local.web_app_name
    "RoleAuthorization:Enabled"              = "True"
    "WVD:AadTenantId"                        = data.azurerm_subscription.current.tenant_id
    "WVD:SubscriptionId"                     = data.azurerm_subscription.current.subscription_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      tags["NMW_OBJECT_TYPE"] # Tag managed by Nerdio.
    ]
  }
}

resource "azurerm_service_plan" "nerdio" {
  name = lower(join("-", [
    var.service,
    local.deployment_region.short_name,
    var.environment,
    var.function,
    "plan",
  ]))
  resource_group_name = module.aa_infra.vars["shared_rg"].name
  location            = module.aa_infra.vars["shared_rg"].location
  sku_name            = "P1v2"
  os_type             = "Windows"

  tags = local.tags
}

# TODO: figure out PE use. this code was never deployed
# resource "azurerm_private_endpoint" "webapp" {
#   name                = join("-", [azurerm_windows_web_app.nerdio.name, "pep"])
#   resource_group_name = azurerm_windows_web_app.nerdio.resource_group_name
#   location            = azurerm_windows_web_app.nerdio.location
#   subnet_id           = module.aa_infra.vars["nerdio_subnet"].id

#   # TODO: Fix and remove use of table entity
#   # private_dns_zone_group {
#   #   name = azurerm_windows_web_app.nerdio.name
#   #   private_dns_zone_ids = [
#   #     data.azurerm_storage_table_entity.private_link_dns_web_app.entity.id
#   #   ]
#   # }

#   private_service_connection {
#     name                           = module.aa_infra.vars["virtual_network"].name
#     private_connection_resource_id = azurerm_windows_web_app.nerdio.id
#     is_manual_connection           = false
#     subresource_names              = ["sites"]
#   }
# }
