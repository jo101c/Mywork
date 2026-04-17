locals {
  tags = {
    workload    = "Monitoring"
    environment = var.environment == "prod" ? "prod" : "nonprod"
    Owner       = "AWCS"
    Repository  = "company/azure/core-platform-landing-zones/modules/monitoring/action_groups"
  }
}