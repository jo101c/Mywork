locals {
  regex_vnet_id_metadata = "^(?i:/subscriptions/.+?/resourceGroups/(?P<resource_group_name>.+?)/providers/Microsoft.Network/virtualNetworks/(?P<name>.+?))$"

  azfw_general_configs = {
    AZFW_Hub = {
      virtual_network   = null
      threat_intel_mode = "" # If virtual_hub_setting, the threat_intelligence_mode has to be explicitly set as ""

    }
    AZFW_VNet = {
      virtual_network   = try(regex(local.regex_vnet_id_metadata, var.hub_vnet_id), null)
      threat_intel_mode = var.threat_intelligence_mode

    }
  }[var.sku_name]

  additional_tags = jsondecode(file("${path.module}/../../../tags_${var.environment == "nonprod" ? "development" : "production"}.json"))

  tags = merge({
    workload   = "Networking"
    repository = "company/azure/core-platform-landing-zones/modules/networking/firewall/"
  }, local.additional_tags)
}