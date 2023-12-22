#
# Configuration as per Nerdio documentation https://nmw.zendesk.com/hc/en-us/articles/4731655590679-Advanced-Installation-Create-Azure-AD-Application
#
resource "azuread_application" "nerdio_manager" {
  display_name            = "Nerdio Manager - ${local.long_environment}"
  logo_image              = filebase64("${path.module}/resources/nerdio.png")
  sign_in_audience        = "AzureADMyOrg"
  prevent_duplicate_names = true

  feature_tags {
    enterprise = true
    hide       = true
  }

  web {
    homepage_url = "https://${local.web_app_name}.azurewebsites.net"
    logout_url   = "https://${local.web_app_name}.azurewebsites.net/signout-oidc"
    redirect_uris = [
      "https://${local.web_app_name}.azurewebsites.net/",
      "https://${local.web_app_name}.azurewebsites.net/signin-oidc",
    ]

    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = true
    }
  }

  app_role {
    id                   = "ed0cdef0-4267-4470-bfff-5e0b6944f9e4"
    value                = "DesktopAdmin"
    display_name         = "Desktop Admin"
    description          = "Complete access to User sessions, ability to view Host Pools, hosts and restart them, but no ability to add/remove or change any settings."
    allowed_member_types = ["User"]
    enabled              = true
  }
  app_role {
    id                   = "e856de81-1e53-486a-8668-7d564866ae39"
    value                = "EndUser"
    display_name         = "Desktop User"
    description          = "View & manage own sessions (Message, Log off, Disconnect). Personal desktop users can restart, power off and power their personal desktops."
    allowed_member_types = ["User"]
    enabled              = true
  }
  app_role {
    id                   = "a94e83da-b314-4232-b8c8-94508c5ed533"
    value                = "HelpDesk"
    display_name         = "Help Desk"
    description          = "Complete access to User sessions only."
    allowed_member_types = ["User"]
    enabled              = true
  }
  app_role {
    id                   = "3807160f-e77a-4fcf-959a-df572bcc3767"
    value                = "RestClient"
    display_name         = "REST Client"
    description          = "REST Client access."
    allowed_member_types = ["Application"]
    enabled              = true
  }
  app_role {
    id                   = "0a1b7425-f55a-44a6-9caa-b9a5cc9448da"
    value                = "Reviewer"
    display_name         = "Reviewer"
    description          = "View access to all areas of NMW; no ability to save or make changes."
    allowed_member_types = ["User"]
    enabled              = true
  }
  app_role {
    id                   = "d1c2ade8-98f8-45fd-aa4a-6d06b947c66f"
    value                = "WvdAdmin"
    display_name         = "Nerdio Admin"
    description          = "Complete access to all areas of Nerdio Manager."
    allowed_member_types = ["User"]
    enabled              = true
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Group.Read.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["GroupMember.Read.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Organization.Read.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
      type = "Role"
    }

    # Delegated permissions
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["Application.ReadWrite.All"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["AppRoleAssignment.ReadWrite.All"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["Directory.Read.All"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["offline_access"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["openid"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["profile"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.ReadBasic.All"]
      type = "Scope"
    }
  }

  # TODO: confirm required
  required_resource_access {
    resource_app_id = "797f4846-ba00-4fd7-ba43-dac1f8f63013" # Windows Azure Service Management API

    # Delegated permissions
    resource_access {
      id   = "41094075-9dad-400e-a0bd-54e686782033" # user_impersonation
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "nerdio_manager" {
  application_id               = azuread_application.nerdio_manager.application_id
  app_role_assignment_required = true

  feature_tags {
    enterprise = true
    hide       = true
  }
}

# Rotate secret every year.
resource "time_rotating" "nerdio_manager" {
  rotation_days = 365 # 1 year
}

resource "azuread_application_password" "nerdio_manager" {
  display_name          = "Managed by Terraform"
  application_object_id = azuread_application.nerdio_manager.object_id
  end_date_relative     = "17520h" # 2 Years

  rotate_when_changed = {
    rotation = time_rotating.nerdio_manager.id
  }
}

# TODO: permissions per environment
# resource "azurerm_role_assignment" "nerdio_rg_contributor" {
#   scope                = module.rg.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_service_principal.nerdio_manager.object_id
# }

# resource "azurerm_role_assignment" "nerdio_subscription_reader" {
#   for_each = {
#     Production     = "7785f4d2-6931-457d-b4f9-f6cb5277ede5"
#     Non-Production = "d4c8d3d1-72cd-4f3b-8f4b-04994b52c1ac"
#   }
#
#   scope                = each.value
#   role_definition_name = "Reader"
#   principal_id         = azuread_service_principal.nerdio_manager.object_id
# }

# resource "azurerm_role_assignment" "nerdio_subscription_backup_reader" {
#   for_each = {
#     Production     = "7785f4d2-6931-457d-b4f9-f6cb5277ede5"
#     Non-Production = "d4c8d3d1-72cd-4f3b-8f4b-04994b52c1ac"
#   }
#
#   scope                = each.value
#   role_definition_name = "Backup Reader"
#   principal_id         = azuread_service_principal.nerdio_manager.object_id
# }
