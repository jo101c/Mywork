resource "azurerm_application_insights" "nerdio" {
  name = lower(join("-", compact([
    local.service,
    local.deployment_region.short_name,
    local.environment,
    var.function,
    "appi",
  ])))
  location            = module.aa_infra.vars["shared_rg"].location
  resource_group_name = module.aa_infra.vars["shared_rg"].name
  workspace_id        = azurerm_log_analytics_workspace.nerdio.id
  application_type    = "web"

  tags = local.tags
}

resource "azurerm_log_analytics_workspace" "nerdio" {
  name = lower(join("-", compact([
    local.service,
    local.deployment_region.short_name,
    local.environment,
    var.function,
    "log",
  ])))
  location            = module.aa_infra.vars["shared_rg"].location
  resource_group_name = module.aa_infra.vars["shared_rg"].name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(local.tags, { "NMW_OBJECT_TYPE" = "LOG_ANALYTICS_WORKSPACE" })
}

# resource "azurerm_log_analytics_datasource_windows_event" "system_events" {
#   name                = "SystemEvents"
#   workspace_name      = azurerm_log_analytics_workspace.nerdio.name
#   resource_group_name = azurerm_log_analytics_workspace.nerdio.resource_group_name
#   event_log_name      = "Application"
#   event_types         = [
#     "Error",
#     "Warning",
#     ]
# }

# resource "azurerm_log_analytics_datasource_windows_event" "ts_local_session_manager_operational" {
#   name                = "TerminalServicesLocalSessionManagerOperational"
#   workspace_name      = azurerm_log_analytics_workspace.nerdio.name
#   resource_group_name = azurerm_log_analytics_workspace.nerdio.resource_group_name
#   event_log_name      = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"
#   event_types         = [
#     "Error",
#     "Warning",
#     "Information",
#     ]
# }

# resource "azurerm_log_analytics_datasource_windows_event" "ts_remote_connection_manager_admin" {
#   name                = "TerminalServicesRemoteConnectionManagerAdmin"
#   workspace_name      = azurerm_log_analytics_workspace.nerdio.name
#   resource_group_name = azurerm_log_analytics_workspace.nerdio.resource_group_name
#   event_log_name      = "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Admin"
#   event_types         = [
#     "Error",
#     "Warning",
#     "Information",
#     ]
# }

# resource "azurerm_log_analytics_datasource_windows_event" "fs_logix_apps_operational" {
#   name                = "MicrosoftFSLogixAppsOperational"
#   workspace_name      = azurerm_log_analytics_workspace.nerdio.name
#   resource_group_name = azurerm_log_analytics_workspace.nerdio.resource_group_name
#   event_log_name      = "Microsoft-FSLogix-Apps/Operational"
#   event_types         = [
#     "Error",
#     "Warning",
#     "Information",
#     ]
# }

# resource "azurerm_log_analytics_datasource_windows_event" "fs_logix_apps_admin" {
#   name                = "MicrosoftFSLogixAppsAdmin"
#   workspace_name      = azurerm_log_analytics_workspace.nerdio.name
#   resource_group_name = azurerm_log_analytics_workspace.nerdio.resource_group_name
#   event_log_name      = "Microsoft-FSLogix-Apps/Admin"
#   event_types         = [
#     "Error",
#     "Warning",
#     "Information",
#     ]
# }

# resource "azurerm_log_analytics_datasource_windows_performance_counter" "free_space_c" {
#   name                = "FreeSpaceC"
#   resource_group_name = azurerm_resource_group.example.name
#   workspace_name      = azurerm_log_analytics_workspace.example.name
#   object_name         = "LogicalDisk"
#   instance_name       = "C:"
#   counter_name        = "% Free Space"
#   interval_seconds    = 60
# }

# resource "azurerm_log_analytics_datasource_windows_performance_counter" "avg_queue_length_c" {
#   name                = "AvgQueueLengthC"
#   resource_group_name = azurerm_resource_group.example.name
#   workspace_name      = azurerm_log_analytics_workspace.example.name
#   object_name         = "LogicalDisk"
#   instance_name       = "C:"
#   counter_name        = "Avg. Disk Queue Length"
#   interval_seconds    = 30
# }

# resource "azurerm_log_analytics_datasource_windows_performance_counter" "curr_queue_length_c" {
#   name                = "CurrQueueLengthC"
#   resource_group_name = azurerm_resource_group.example.name
#   workspace_name      = azurerm_log_analytics_workspace.example.name
#   object_name         = "LogicalDisk"
#   instance_name       = "C:"
#   counter_name        = "Current Disk Queue Length"
#   interval_seconds    = 30
# }

# resource "azurerm_log_analytics_datasource_windows_performance_counter" "avg_disk_transfer_c" {
#   name                = "AvgDiskTransferC"
#   resource_group_name = azurerm_resource_group.example.name
#   workspace_name      = azurerm_log_analytics_workspace.example.name
#   object_name         = "LogicalDisk"
#   instance_name       = "C:"
#   counter_name        = "Avg. Disk sec/Transfer"
#   interval_seconds    = 60
# }

# resource "azurerm_log_analytics_datasource_windows_performance_counter" "avail_memory" {
#   name                = "AvailableMemory"
#   resource_group_name = azurerm_resource_group.example.name
#   workspace_name      = azurerm_log_analytics_workspace.example.name
#   object_name         = "Memory"
#   instance_name       = "*"
#   counter_name        = "Available Mbytes"
#   interval_seconds    = 30
# }

# resource "azurerm_log_analytics_datasource_windows_performance_counter" "page_faults" {
#   name                = "PafeFaults"
#   resource_group_name = azurerm_resource_group.example.name
#   workspace_name      = azurerm_log_analytics_workspace.example.name
#   object_name         = "Memory"
#   instance_name       = "*"
#   counter_name        = "Page Faults/sec"
#   interval_seconds    = 30
# }

#
# Solutions to enable Azure Defender
#
resource "azurerm_log_analytics_solution" "security" {
  solution_name         = "Security"
  location              = module.aa_infra.vars["shared_rg"].location
  resource_group_name   = module.aa_infra.vars["shared_rg"].name
  workspace_resource_id = azurerm_log_analytics_workspace.nerdio.id
  workspace_name        = azurerm_log_analytics_workspace.nerdio.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Security"
  }

  tags = local.tags
}

resource "azurerm_log_analytics_solution" "security_center" {
  solution_name         = "SecurityCenterFree"
  location              = module.aa_infra.vars["shared_rg"].location
  resource_group_name   = module.aa_infra.vars["shared_rg"].name
  workspace_resource_id = azurerm_log_analytics_workspace.nerdio.id
  workspace_name        = azurerm_log_analytics_workspace.nerdio.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityCenterFree"
  }

  tags = local.tags
}

resource "azurerm_log_analytics_solution" "sql_advanced_threat_protection" {
  solution_name         = "SQLAdvancedThreatProtection"
  location              = module.aa_infra.vars["shared_rg"].location
  resource_group_name   = module.aa_infra.vars["shared_rg"].name
  workspace_resource_id = azurerm_log_analytics_workspace.nerdio.id
  workspace_name        = azurerm_log_analytics_workspace.nerdio.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SQLAdvancedThreatProtection"
  }

  tags = local.tags
}

resource "azurerm_log_analytics_solution" "sql_vulnerability_assessment" {
  solution_name         = "SQLVulnerabilityAssessment"
  location              = module.aa_infra.vars["shared_rg"].location
  resource_group_name   = module.aa_infra.vars["shared_rg"].name
  workspace_resource_id = azurerm_log_analytics_workspace.nerdio.id
  workspace_name        = azurerm_log_analytics_workspace.nerdio.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SQLVulnerabilityAssessment"
  }

  tags = local.tags
}
