locals {

  # Web app
  web_app_name = lower(join("-", [
    local.base_name,
    "nerdio", # Function
    "wa",     # Resource
  ]))

  # Automation Account
  modules = {
    "AzureAD" = "https://www.powershellgallery.com/api/v2/package/AzureAD/2.0.2.76"
  }

  runbooks = {
    # nmwUpdateRunAs = {
    #   description = "Update using automation Run As account"
    #   uri = "TBC"
    #   version = "1.0.0.0"
    #   type = "PowerShell"
    # }
  }

  variables = {
    subscriptionId = {
      type        = "string"
      description = "Azure Subscription Id"
      value       = data.azurerm_subscription.current.subscription_id
      encrypted   = false
    }
    webAppName = {
      type        = "string"
      description = "Web App Name"
      value       = azurerm_windows_web_app.nerdio.name
      encrypted   = false
    }
    resourceGroupName = {
      type        = "string"
      description = "Resource group"
      value       = module.aa_infra.vars["logic_rg"].name
      encrypted   = false
    }
  }

  # https://angleauto.atlassian.net/wiki/spaces/ISD/pages/18678435/Azure+Tagging+Naming+Convention#Resource-Naming-Convention
  base_name = lower(join("-", compact([
    var.service,                        # Service
    local.environment,                  # Environment
    local.deployment_region.short_name, # Region
  ])))

  environment = lower(var.environment)
  service     = var.service

  subscription_id = lookup(var.envSubMap, lower(var.environment), "sbx")

  is_prod = upper(var.environment) == "PRD"

  long_environment = coalesce(
    upper(local.environment) == "PRD" ? "Production" : "",
    upper(local.environment) == "SHR" ? "Shared" : "",
    upper(local.environment) == "NPD" ? "Non-Production" : "",
    upper(local.environment) == "DEV" ? "Development" : "",
    upper(local.environment) == "SBX" ? "Sandbox" : "",
    upper(local.environment),
  )

  firewall_offset = coalesce(
    upper(local.environment) == "PRD" ? 0 : null,
    upper(local.environment) == "SHR" ? 1 : null,
    upper(local.environment) == "NPD" ? 2 : null,
    upper(local.environment) == "UAT" ? 3 : null,
    upper(local.environment) == "SIT" ? 4 : null,
    upper(local.environment) == "DEV" ? 5 : null,
    upper(local.environment) == "SBX" ? 6 : null,
  )

  deployment_region = local.regions[var.region]
  regions = {
    aue = {
      name       = "Australia East"
      old_name   = "Sydney"
      short_name = "aue"
      location   = "australiaeast"
      zones      = [1, 2, 3]
    }
    ause = {
      name       = "Australia Southeast"
      old_name   = "Melbourne"
      short_name = "ause"
      location   = "australiasoutheast"
      zones      = null
    }
  }

  tags = merge(
    var.tags,
    {
      service          = var.service
      environment      = var.environment
      billingCode      = "CIO"
      owner            = "DL-AAF-Cloud@angleauto.com.au"
      classification   = var.classification
      criticality      = var.criticality
      deploymentMethod = "terraform"
      repository       = "Azure Virtual Desktops - avd-infrastructure"
      disasterRecovery = var.disaster_recovery
      Documentation    = ""
      expiryDate       = "NA"
      Workload         = "Nerdio"
    }
  )
}
