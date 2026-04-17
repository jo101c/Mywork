locals {
  tags = {
    workload    = "Networking"
    environment = var.environment == "prod" ? "prod" : "nonprod"
    Owner       = "AWCS"
    Repository  = "company/azure/core-platform-landing-zones/modules/networking"
  }
}