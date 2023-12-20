locals {
  tags = {
    workload    = "Monitoring"
    environment = var.environment == "prod" ? "prod" : "nonprod"
    Owner       = "AWCS"
    Repository  = "flybuys/azure/core-platform-landing-zones/modules/monitoring/workspaces"
  }
}