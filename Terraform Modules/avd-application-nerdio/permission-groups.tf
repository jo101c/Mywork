resource "azuread_group" "nerdio" {
  for_each = { for v in azuread_application.nerdio_manager.app_role :
    v.value => v
    if contains(v.allowed_member_types, "User")
  }

  display_name            = "Nerdio Manager - ${each.value.display_name} - ${var.environment}"
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_app_role_assignment" "nerdio" {
  for_each = azuread_group.nerdio

  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.nerdio_manager.object_id
  app_role_id         = azuread_service_principal.nerdio_manager.app_role_ids[each.key]
}
