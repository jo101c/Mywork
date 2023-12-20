resource "azurerm_storage_account" "default" {
  for_each = local.storage_accounts

  name                     = each.key
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

resource "time_sleep" "wait_60_seconds" {
  for_each = azurerm_storage_account.default

  create_duration = var.create_duration
  depends_on      = [azurerm_storage_account.default]
}

resource "azurerm_storage_container" "default" {
  for_each = { for combo in local.container_combinations : "${combo.storage_account_name}-${combo.container_name}" => combo }

  name                  = each.value.container_name
  storage_account_name  = each.value.storage_account_name
  container_access_type = var.container_access_type

  depends_on = [time_sleep.wait_60_seconds]
}