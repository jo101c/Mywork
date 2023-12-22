# Each criteria will be looped and deployed as a new Alert rule

locals {
  #SQL DB Alert rules
  criteria_sql = {
    cpu = {
      alert_name       = "SQL CPU DB Alert"
      metric_namespace = "Microsoft.Sql/servers/databases"
      metric_name      = "cpu_percent"
      aggregation      = "Maximum"
      operator         = "GreaterThan"
      threshold        = "80"
    }
    disk = {
      alert_name       = "SQL Disk Capacity Alert"
      metric_namespace = "Microsoft.Sql/servers/databases"
      metric_name      = "storage_percent"
      aggregation      = "Maximum"
      operator         = "GreaterThan"
      threshold        = "85"
    }
    deadlock = {
      alert_name       = "SQL Deadlock Alert"
      metric_namespace = "Microsoft.Sql/servers/databases"
      metric_name      = "deadlock"
      aggregation      = "Count"
      operator         = "GreaterThanOrEqual"
      threshold        = "1"
    }
    failedconnection = {
      alert_name       = "SQL Failed Connections Alert"
      metric_namespace = "Microsoft.Sql/servers/databases"
      metric_name      = "connection_failed"
      aggregation      = "Count"
      operator         = "GreaterThanOrEqual"
      threshold        = "2"
    }
    memory = {
      alert_name       = "SQL Memory Alert"
      metric_namespace = "Microsoft.Sql/servers/databases"
      metric_name      = "sqlserver_process_memory_percent"
      aggregation      = "Minimum"
      operator         = "LessThanOrEqual"
      threshold        = "20"
    }
  }
 
 #VM Alert rules
  criteria_vm = {
    cpu = {
      alert_name       = "VM CPU Alert"
      metric_namespace = "microsoft.compute/virtualmachines"
      metric_name      = "Percentage CPU"
      aggregation      = "Maximum"
      operator         = "GreaterThan"
      threshold        = "80"
    }
    memory = {
      alert_name       = "VM Memory Alert"
      metric_namespace = "microsoft.compute/virtualmachines"
      metric_name      = "Available Memory Bytes"
      aggregation      = "Minimum"
      operator         = "LessThan"
      threshold        = "4"
    }
  }
}