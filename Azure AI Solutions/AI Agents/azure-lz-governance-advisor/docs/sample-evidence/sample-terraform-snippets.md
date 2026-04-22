# Sample Evidence: Terraform Snippets

These snippets are intentionally incomplete and should be reviewed as sample evidence.

## Resource Group

```hcl
resource "azurerm_resource_group" "workload" {
  name     = "rg-payments-prod-aue"
  location = "australiaeast"

  tags = {
    workload    = "payments"
    environment = "prod"
  }
}
```

## Role Assignment

```hcl
resource "azurerm_role_assignment" "app_team_owner" {
  scope                = azurerm_resource_group.workload.id
  role_definition_name = "Owner"
  principal_id         = var.app_team_group_object_id
}
```

## Storage Account

```hcl
resource "azurerm_storage_account" "app" {
  name                     = "stpaymentprodaue001"
  resource_group_name      = azurerm_resource_group.workload.name
  location                 = azurerm_resource_group.workload.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

## Known Gaps

- Resource group tags are missing `owner` and `costCentre`.
- Owner role may be too broad for the application team.
- Storage account network restrictions are not configured.
- Diagnostic settings are not configured.
- No module standard is shown.
- No policy assignment or exemption workflow is shown.
