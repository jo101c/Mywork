data "azurerm_resource_group" "default_lzone_rg" {
  name = "rg-ae-${var.environment == "prod" ? "p" : "np"}-ops-tfstate-01"
}
