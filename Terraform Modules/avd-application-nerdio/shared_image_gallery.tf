resource "azurerm_shared_image_gallery" "nerdio" {
  name = lower(join("", [
    replace(local.base_name, "-", ""), # Remove "-" characters.
    "nerdio",                          # Function
    "sig",                             # Resource
  ]))
  resource_group_name = module.aa_infra.vars["logic_rg"].name
  location            = module.aa_infra.vars["logic_rg"].location
  description         = "Images for Virtual Desktops - ${var.environment}"

  tags = local.tags
}
