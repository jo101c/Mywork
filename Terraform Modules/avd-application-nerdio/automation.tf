###
# Scripted Actions for Nerdio
# https://nmw.zendesk.com/hc/en-us/articles/4731662951447-Scripted-Actions-Overview
###
resource "azurerm_automation_account" "nerdio" {
  name = lower(join("-", compact([
    local.service,
    local.deployment_region.short_name,
    local.environment,
    var.function,
    "aa",
  ])))
  location            = module.aa_infra.vars["logic_rg"].location
  resource_group_name = module.aa_infra.vars["logic_rg"].name
  sku_name            = "Basic"

  tags = local.tags
}

resource "azurerm_automation_module" "nerdio" {
  for_each = local.modules

  name                    = each.key
  automation_account_name = azurerm_automation_account.nerdio.name
  resource_group_name     = azurerm_automation_account.nerdio.resource_group_name

  module_link {
    uri = each.value
  }
}

resource "azurerm_automation_runbook" "nerdio" {
  for_each = local.runbooks

  name                    = each.key
  automation_account_name = azurerm_automation_account.nerdio.name
  resource_group_name     = azurerm_automation_account.nerdio.resource_group_name
  location                = azurerm_automation_account.nerdio.location
  log_verbose             = false
  log_progress            = true
  description             = each.value.description
  runbook_type            = each.value.type

  publish_content_link {
    uri     = each.value.uri
    version = each.value.version
  }
}

resource "azurerm_automation_variable_string" "nerdio" {
  for_each = { for k, v in local.variables :
    k => v
    if v.type == "string"
  }

  name                    = each.key
  automation_account_name = azurerm_automation_account.nerdio.name
  resource_group_name     = azurerm_automation_account.nerdio.resource_group_name
  value                   = each.value.value
  description             = each.value.description
  encrypted               = each.value.encrypted
}

#
# Automation Run-As Account
#
resource "azuread_application" "automation_runas" {
  display_name = "Nerdio Manager Automation - ${local.long_environment}"

  feature_tags {
    hide = true
  }
}

resource "azuread_service_principal" "automation_runas" {
  application_id               = azuread_application.automation_runas.application_id
  app_role_assignment_required = true

  feature_tags {
    hide = true
  }
}

# resource "azurerm_role_assignment" "automation_runas_rg_contributor" {
#   scope                = module.logic_rg.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_service_principal.automation_runas.object_id
# }

# Create certificate for run as account
resource "azurerm_key_vault_certificate" "automation_runas" {
  name         = "nmw-automation-cert"
  key_vault_id = module.aa_infra.vars["key_vault"].id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = [
        "1.3.6.1.5.5.7.3.1", # Server Authentication
        "1.3.6.1.5.5.7.3.2", # Client Authentication
      ]

      key_usage = [
        "digitalSignature",
        "keyEncipherment",
      ]

      subject            = "CN=nmw-automation-cert"
      validity_in_months = 12
    }
  }
}

resource "azuread_service_principal_certificate" "automation_runas" {
  service_principal_id = azuread_service_principal.automation_runas.id
  encoding             = "hex"
  type                 = "AsymmetricX509Cert"
  value                = azurerm_key_vault_certificate.automation_runas.certificate_data
  start_date           = azurerm_key_vault_certificate.automation_runas.certificate_attribute[0].not_before
  end_date             = azurerm_key_vault_certificate.automation_runas.certificate_attribute[0].expires
}

# https://github.com/hashicorp/terraform-provider-azurerm/issues/11475#issuecomment-827085559
data "azurerm_key_vault_secret" "automation_runas" {
  name         = azurerm_key_vault_certificate.automation_runas.name
  key_vault_id = azurerm_key_vault_certificate.automation_runas.key_vault_id
}

resource "azurerm_automation_certificate" "automation_runas" {
  name                    = "AzureRunAsCertificate"
  automation_account_name = azurerm_automation_account.nerdio.name
  resource_group_name     = azurerm_automation_account.nerdio.resource_group_name
  base64                  = data.azurerm_key_vault_secret.automation_runas.value
  exportable              = true
}

resource "azurerm_automation_connection_certificate" "runas" {
  name                        = "AzureRunAsConnection"
  automation_account_name     = azurerm_automation_account.nerdio.name
  resource_group_name         = azurerm_automation_account.nerdio.resource_group_name
  automation_certificate_name = azurerm_automation_certificate.automation_runas.name
  subscription_id             = data.azurerm_subscription.current.subscription_id
}

# Create certificate for scripted action account
resource "azurerm_key_vault_certificate" "scripted_action" {
  name         = "nmw-scripted-action-cert"
  key_vault_id = module.aa_infra.vars["key_vault"].id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = [
        "1.3.6.1.5.5.7.3.1", # Server Authentication
        "1.3.6.1.5.5.7.3.2", # Client Authentication
      ]

      key_usage = [
        "digitalSignature",
        "keyEncipherment",
      ]

      subject            = "CN=nmw-scripted-action-cert"
      validity_in_months = 12
    }
  }
}

# https://github.com/hashicorp/terraform-provider-azurerm/issues/11475#issuecomment-827085559
data "azurerm_key_vault_secret" "scripted_action" {
  name         = azurerm_key_vault_certificate.scripted_action.name
  key_vault_id = azurerm_key_vault_certificate.scripted_action.key_vault_id
}

resource "azurerm_automation_certificate" "scripted_action" {
  name                    = "ScriptedActionRunAsCert"
  automation_account_name = azurerm_automation_account.nerdio.name
  resource_group_name     = azurerm_automation_account.nerdio.resource_group_name
  base64                  = data.azurerm_key_vault_secret.scripted_action.value
  exportable              = true
}

resource "azuread_service_principal_certificate" "scripted_action" {
  service_principal_id = azuread_service_principal.nerdio_manager.id
  encoding             = "hex"
  type                 = "AsymmetricX509Cert"
  value                = azurerm_key_vault_certificate.scripted_action.certificate_data
  start_date           = azurerm_key_vault_certificate.scripted_action.certificate_attribute[0].not_before
  end_date             = azurerm_key_vault_certificate.scripted_action.certificate_attribute[0].expires
}
