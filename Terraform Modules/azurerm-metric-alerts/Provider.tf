provider "azurerm" {
  #alias not added due to TF bug
  subscription_id = "sub_id" 
  tenant_id       = "ten_id"

  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
}