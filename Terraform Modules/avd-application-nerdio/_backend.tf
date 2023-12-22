terraform {
  backend "azurerm" {
    use_azuread_auth = true
    subscription_id  = "fdfe3f14-ae45-4661-9b51-9d1ede013935" # Terraform - State Files
    # The below settings are set in the pipeline
    # TODO: Improve the pipeline to allow setting options below in TF.
    # resource_group_name = ""
    # storage_account_name = ""
    # container_name = """
  }
}
