provider "azurerm" {
  #alias not added due to TF bug
  subscription_id = "7785f4d2-6931-457d-b4f9-f6cb5277ede5" # AA Tenant Prod Internal
  tenant_id       = "c26f31b3-b539-4fea-af9f-0673a4291ed0"

  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
}

# provider "azurerm" {
#   alias = "tech"
#   subscription_id = "3e925cf9-9e9e-46d7-b8b5-681a4c24d8c6" # Technology Tenant AFA PROD
#   tenant_id       = "dc372364-9226-48a1-93e3-d3eb929037d2"

#   features {
#     virtual_machine {
#       delete_os_disk_on_deletion = true
#     }
#   }
# }