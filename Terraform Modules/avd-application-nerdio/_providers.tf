terraform {
  required_version = ">= 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
    }
  }
}

provider "azurerm" {
  subscription_id = local.subscription_id

  storage_use_azuread = true
  features {
    app_configuration {
      purge_soft_delete_on_destroy = local.is_prod ? false : true
      recover_soft_deleted         = true
    }
    key_vault {
      purge_soft_delete_on_destroy               = local.is_prod ? false : true
      purge_soft_deleted_certificates_on_destroy = local.is_prod ? false : true
      purge_soft_deleted_keys_on_destroy         = local.is_prod ? false : true
      purge_soft_deleted_secrets_on_destroy      = local.is_prod ? false : true
    }
  }
}

provider "azurerm" {
  alias = "internal_prod"

  subscription_id = "7785f4d2-6931-457d-b4f9-f6cb5277ede5" # Production
  tenant_id       = "c26f31b3-b539-4fea-af9f-0673a4291ed0"

  storage_use_azuread        = true
  skip_provider_registration = true
  features {
    app_configuration {
      purge_soft_delete_on_destroy = false
      recover_soft_deleted         = true
    }
    key_vault {
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
    }
  }
}

provider "azurerm" {
  alias = "internal_shared"

  # 7785f4d2-6931-457d-b4f9-f6cb5277ede5 = Internal Production
  # d4c8d3d1-72cd-4f3b-8f4b-04994b52c1ac = Internal Non-production
  subscription_id = local.is_prod ? "7785f4d2-6931-457d-b4f9-f6cb5277ede5" : "d4c8d3d1-72cd-4f3b-8f4b-04994b52c1ac"
  tenant_id       = "c26f31b3-b539-4fea-af9f-0673a4291ed0"

  storage_use_azuread        = true
  skip_provider_registration = true
  features {
    app_configuration {
      purge_soft_delete_on_destroy = false
      recover_soft_deleted         = true
    }
    key_vault {
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
    }
  }
}
