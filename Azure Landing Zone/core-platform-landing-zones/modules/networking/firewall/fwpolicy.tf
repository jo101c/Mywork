## IP Group definitions
resource "azurerm_ip_group" "workload_avd_ip_group" {
  provider            = azurerm.hub
  name                = "workload-avd-ip-group"
  resource_group_name = var.hub_vnet_resource_group_name
  location            = var.location
  cidrs               = ["10.10.68.0/24", "10.10.70.0/24", "10.10.192.0/24", "10.10.193.0/24"]
  tags                = local.tags
}

resource "azurerm_ip_group" "platform_ip_group" {
  provider            = azurerm.hub
  name                = "platform-ip-group"
  resource_group_name = var.hub_vnet_resource_group_name
  location            = var.location
  cidrs               = ["10.11.0.0/24"]
  tags                = local.tags
}

## Firewall Policy Rule Collection Group

resource "azurerm_firewall_policy_rule_collection_group" "net_policy_rule_collection_group" {
  provider           = azurerm.hub
  name               = "default-network-rule-collection-group"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 200
  depends_on = [
    azurerm_firewall_policy.azfw_policy,
    azurerm_ip_group.workload_avd_ip_group,
    azurerm_ip_group.platform_ip_group
  ]

  network_rule_collection {
    name     = "default-network-rule-collection"
    action   = "Allow"
    priority = 200

    rule {
      name              = "windows-time-update"
      protocols         = ["UDP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id, azurerm_ip_group.platform_ip_group.id]
      destination_ports = ["123"]
      destination_fqdns = ["time.windows.com"]
    }

    rule {
      name              = "windows-id-login"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id, azurerm_ip_group.platform_ip_group.id]
      destination_ports = ["443", "80"]
      destination_fqdns = ["login.windows.net"]
    }

    rule {
      name              = "security-vendor-login"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id, azurerm_ip_group.platform_ip_group.id]
      destination_ports = ["443", "80"]
      destination_fqdns = ["login.securityvendor.example"]
    }

    rule {
      name                  = "proxy-access-region-1"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["203.0.113.0/24", "198.51.100.0/24"]
      destination_ports     = ["80", "9400"]
    }

    rule {
      name                  = "proxy-access-pac"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["203.0.113.10", "203.0.113.11", "198.51.100.10", "198.51.100.11"]
      destination_ports     = ["80", "9400"]
    }

    rule {
      name                  = "proxy-access-region-2"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["198.51.100.128/25", "203.0.113.128/25"]
      destination_ports     = ["80", "9400"]
    }

    rule {
      name                  = "proxy-access-region-3"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["192.0.2.0/24"]
      destination_ports     = ["80", "9400"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "app_policy_rule_collection_group" {
  provider           = azurerm.hub
  name               = "default-application-rule-collection-group"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 300
  depends_on = [
    azurerm_firewall_policy.azfw_policy,
    azurerm_ip_group.workload_avd_ip_group,
    azurerm_ip_group.platform_ip_group
  ]

  application_rule_collection {
    name     = "default-application-rule-collection"
    action   = "Allow"
    priority = 300

    rule {
      name        = "windows-update"
      description = "Allow Windows Update"

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id, azurerm_ip_group.platform_ip_group.id]
      destination_fqdn_tags = ["WindowsUpdate"]
    }

    rule {
      name        = "global-rule-to-microsoft"
      description = "Allow access to Microsoft endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = ["*.microsoft.com", "login.microsoftonline.com", "login.windows.net"]
      terminate_tls     = false
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id, azurerm_ip_group.platform_ip_group.id]
    }
  }

  application_rule_collection {
    name     = "application-rule-collection-security-tool"
    action   = "Allow"
    priority = 310

    rule {
      name        = "defender-endpoints"
      description = "Allow connectivity to security tooling"

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id, azurerm_ip_group.platform_ip_group.id]
      terminate_tls     = false
      destination_fqdns = [
        "crl.microsoft.com",
        "ctldl.windowsupdate.com",
        "*.events.data.microsoft.com",
        "notify.windows.com",
        "settings-win.data.microsoft.com",
        "*.blob.core.windows.net",
        "securitytelemetrystorage.blob.core.windows.net"
      ]
    }
  }
}

## AVD Policy
## Refer to Microsoft documentation for Azure Virtual Desktop + Azure Firewall patterns

resource "azurerm_firewall_policy_rule_collection_group" "workload_avd_policy_rule_collection_group" {
  provider           = azurerm.hub
  name               = "policy-avd-01"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 400
  depends_on = [
    azurerm_firewall_policy.azfw_policy,
    azurerm_ip_group.workload_avd_ip_group,
    azurerm_ip_group.platform_ip_group
  ]

  network_rule_collection {
    name     = "avd-platform-network-rule-collection"
    action   = "Allow"
    priority = 200

    rule {
      name              = "avd-net-1"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports = ["443"]
      destination_fqdns = ["login.microsoftonline.com"]
    }

    rule {
      name                  = "avd-net-2"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports     = ["443"]
      destination_addresses = ["WindowsVirtualDesktop", "AzureFrontDoor.Frontend", "AzureMonitor"]
    }

    rule {
      name              = "avd-net-3"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports = ["443"]
      destination_fqdns = ["gcs.prod.monitoring.core.windows.net"]
    }

    rule {
      name                  = "avd-net-4"
      protocols             = ["TCP", "UDP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["168.63.129.16"]
      destination_ports     = ["53"]
    }

    rule {
      name                  = "avd-rule-az-kms"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["azkms.core.windows.net"]
      destination_ports     = ["1688"]
    }

    rule {
      name                  = "avd-rule-kms"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["kms.core.windows.net"]
      destination_ports     = ["1688"]
    }

    rule {
      name              = "avd-net-5"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports = ["443"]
      destination_fqdns = ["avd-artifacts.blob.core.windows.net"]
    }

    rule {
      name              = "avd-net-6"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports = ["443"]
      destination_fqdns = ["avd-portal-storage.blob.core.windows.net"]
    }

    rule {
      name              = "avd-net-7"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports = ["443"]
      destination_fqdns = ["oneocsp.microsoft.com"]
    }

    rule {
      name                  = "avd-net-rdp-shortpath-endpoints"
      protocols             = ["UDP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["*"]
      destination_ports     = ["38300-39300"]
    }

    rule {
      name                  = "avd-net-stun-turn-udp"
      protocols             = ["UDP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["20.202.0.0/16"]
      destination_ports     = ["3478"]
    }

    rule {
      name                  = "avd-net-stun-turn-tcp"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["20.202.0.0/16"]
      destination_ports     = ["443"]
    }

    rule {
      name              = "avd-net-monitoring-vendor"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports = ["443"]
      destination_fqdns = [
        "endpoint.ingress.monitoringvendor.example",
        "region1.endpoint.ingress.monitoringvendor.example",
        "deployment.endpoint.ingress.monitoringvendor.example"
      ]
    }
  }

  network_rule_collection {
    name     = "avd-workload-network-rule-collection"
    action   = "Allow"
    priority = 210

    rule {
      name              = "avd-net-git-provider-ssh"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports = ["22"]
      destination_fqdns = ["gitlab.com"]
    }

    rule {
      name                  = "avd-net-fileshare"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["203.0.113.50"]
      destination_ports     = ["445"]
    }

    rule {
      name                  = "avd-net-external-vpn"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["198.51.100.25", "198.51.100.26"]
      destination_ports     = ["443"]
    }

    rule {
      name                  = "avd-net-external-dns"
      protocols             = ["TCP", "UDP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = [
        "203.0.113.60",
        "203.0.113.61",
        "198.51.100.60",
        "198.51.100.61"
      ]
      destination_ports = ["53"]
    }

    rule {
      name                  = "avd-net-aad-pool-join"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_addresses = ["168.63.129.1"]
      destination_ports     = ["80", "443", "32526"]
    }
  }

  network_rule_collection {
    name     = "avd-workload-sftp-network-rule-collection"
    action   = "Allow"
    priority = 220

    rule {
      name                  = "avd-sftp-partner-1"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports     = ["22"]
      destination_addresses = ["203.0.113.101", "203.0.113.102"]
    }

    rule {
      name                  = "avd-sftp-partner-2"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports     = ["22"]
      destination_addresses = ["198.51.100.101", "198.51.100.102"]
    }

    rule {
      name                  = "avd-sftp-partner-3"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports     = ["22"]
      destination_addresses = ["192.0.2.101"]
    }

    rule {
      name                  = "avd-sftp-partner-4"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports     = ["22"]
      destination_addresses = ["192.0.2.102"]
    }

    rule {
      name                  = "avd-sftp-partner-5"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports     = ["22"]
      destination_addresses = ["203.0.113.110", "203.0.113.111", "198.51.100.110"]
    }

    rule {
      name                  = "avd-sftp-partner-6"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_ports     = ["22"]
      destination_addresses = ["198.51.100.120", "198.51.100.121", "198.51.100.122"]
    }
  }

  application_rule_collection {
    name     = "avd-application-rule-collection"
    action   = "Allow"
    priority = 300

    rule {
      name        = "windows-update-allow"
      description = "Allow Windows Update"

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_fqdn_tags = ["WindowsUpdate", "Windows Diagnostics", "MicrosoftActiveProtectionService"]
    }

    rule {
      name        = "avd-app-ms-1"
      description = "Allow AVD Microsoft endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "*.events.data.microsoft.com",
        "*.wvd.microsoft.com",
        "unitedstates.cp.wd.microsoft.com",
        "ocps.manage.microsoft.com"
      ]
      terminate_tls    = false
      source_ip_groups = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "avd-app-ms-2"
      description = "Allow Azure platform endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "*.blob.core.windows.net",
        "*.core.windows.net",
        "*.servicebus.windows.net",
        "*.prod.warm.ingest.monitor.core.windows.net"
      ]
      terminate_tls    = false
      source_ip_groups = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "avd-app-ms-3"
      description = "Allow Microsoft supporting endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "*.sfx.ms",
        "prod.warmpath.msftcloudes.com",
        "catalogartifact.azureedge.net",
        "aadcdn.msauth.net"
      ]
      terminate_tls    = false
      source_ip_groups = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "avd-app-ms-4"
      description = "Allow Azure DNS endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = ["*.azure-dns.com", "*.azure-dns.net"]
      terminate_tls     = false
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "avd-app-digicert"
      description = "Allow certificate endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = ["*.digicert.com"]
      terminate_tls     = false
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "office365-allow"
      description = "Allow Office 365 access from AVD"

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_fqdn_tags = [
        "Office365.Exchange.Allow.Required",
        "Office365.Exchange.Default.Required",
        "Office365.Common.Allow.Required",
        "Office365.Common.Default.Required",
        "Office365.Exchange.Optimize",
        "Office365.Common.Default.NotRequired",
        "Office365.SharePoint.Default.Required",
        "Office365.SharePoint.Default.NotRequired",
        "Office365.SharePoint.Optimize",
        "Office365.Skype.Allow.NotRequired",
        "Office365.Skype.Default.NotRequired",
        "Office365.Skype.Default.Required",
        "Office365.Skype.Allow.Required"
      ]
    }

    rule {
      name        = "microsoft365-allow"
      description = "Allow connectivity to M365 services"

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      terminate_tls     = false
      destination_fqdns = [
        "tenant-my.sharepoint.com",
        "tenant.sharepoint.com",
        "skydrive.wns.windows.com",
        "r4.res.office365.com",
        "settings-win.data.microsoft.com",
        "*.blob.core.windows.net",
        "genericstorage.blob.core.windows.net"
      ]
    }

    rule {
      name        = "aad-join-device-allow"
      description = "Allow AAD join device traffic"

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups      = [azurerm_ip_group.workload_avd_ip_group.id]
      destination_fqdn_tags = ["WindowsVirtualDesktop"]
    }

    rule {
      name        = "aad-join-device-allow-fqdn"
      description = "Allow AAD join device traffic via FQDNs"

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      terminate_tls     = false
      destination_fqdns = ["enterpriseregistration.windows.net", "device.login.microsoftonline.com", "pas.windows.net"]
    }

    rule {
      name        = "business-website-allow"
      description = "Allow web access to organisation endpoints"

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      terminate_tls     = false
      destination_fqdns = [
        "example.com",
        "*.example.com",
        "*.example-app.cloud",
        "*.s3.amazonaws.com"
      ]
    }

    rule {
      name        = "proxy-pac-allow"
      description = "Allow connectivity to proxy PAC file"

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      terminate_tls     = false
      destination_fqdns = ["pac.proxyvendor.example"]
    }
  }

  application_rule_collection {
    name     = "avd-workload-application-rule-collection"
    action   = "Allow"
    priority = 320

    rule {
      name        = "scheduler-platform-allow"
      description = "Allow scheduler platform endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
      terminate_tls     = false
      destination_fqdns = [
        "scheduler.app-test.example-app.cloud",
        "scheduler.app-prod.example-app.cloud",
        "scheduler.app-dev.example-app.cloud",
        "scheduler.app-eng.example-app.cloud"
      ]
    }

    rule {
      name        = "messaging-platform-allow"
      description = "Allow access to messaging platform endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      protocols {
        type = "Http"
        port = 80
      }

      destination_fqdns = [
        "interact.example-messaging.com",
        "api.example-messaging.oraclecloud.com"
      ]
      terminate_tls    = false
      source_ip_groups = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "additional-rules"
      description = "Allow additional common endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      protocols {
        type = "Http"
        port = 80
      }

      destination_fqdns = [
        "nexusrules.officeapps.live.com",
        "config.edge.skype.com",
        "ocsp.digicert.com",
        "crl3.digicert.com",
        "update.googleapis.com",
        "ts-ocsp.ws.symantec.com",
        "ts-crl.ws.symantec.com",
        "ocsp.verisign.com",
        "*.amazontrust.com"
      ]
      terminate_tls    = false
      source_ip_groups = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "azure-services-rules"
      description = "Allow Azure monitoring and management endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      protocols {
        type = "Http"
        port = 80
      }

      destination_fqdns = [
        "*.oms.opinsights.azure.com",
        "*.ods.opinsights.azure.com",
        "*.handler.control.monitor.azure.com",
        "update.googleapis.com"
      ]
      terminate_tls    = false
      source_ip_groups = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "data-platform-services-rules"
      description = "Allow access to external data platform endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      protocols {
        type = "Http"
        port = 80
      }

      destination_fqdns = [
        "tenant-prod.ap-southeast-2.snowflakecomputing.com",
        "tenant-nonprod.ap-southeast-2.snowflakecomputing.com",
        "analytics-prod.ap-southeast-2.snowflakecomputing.com",
        "analytics-nonprod.ap-southeast-2.snowflakecomputing.com",
        "customer-stage.s3.amazonaws.com",
        "customer-stage.s3.ap-southeast-2.amazonaws.com",
        "app.snowflake.com",
        "apps-api.c1.ap-southeast-2.aws.app.snowflake.com"
      ]
      terminate_tls    = false
      source_ip_groups = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "security-validation-services-rules"
      description = "Allow access to security validation endpoints"

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "*.securityvalidation.example",
        "email.scenarios.securityvalidation.example",
        "validation.securityvalidation.example"
      ]
      terminate_tls    = false
      source_ip_groups = [azurerm_ip_group.workload_avd_ip_group.id]
    }

    rule {
      name        = "rstudio-package-allow"
      description = "Allow access to R package repository"

      protocols {
        type = "Https"
        port = 443
      }

      protocols {
        type = "Http"
        port = 80
      }

      destination_fqdns = ["cran.rstudio.com"]
      terminate_tls     = false
      source_ip_groups  = [azurerm_ip_group.workload_avd_ip_group.id]
    }
  }
}
