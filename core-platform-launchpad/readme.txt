## Launchpad Landing Zone Module ##

This Terraform module provides a standard method to deploy Azure Storage Accounts,
and Storage Containers for Azure landing zone workloads storing TF State files with seperation.

Managed by: AWCS team 

1. Azure Storage Account Creation:
The azurerm_storage_account resource block provisions storage accounts.
Each storage account is defined in the local.storage_accounts dictionary. For every entry here, a new storage account gets created.

2. Sleep Timer:
After creating each storage account, the time_sleep resource block introduces a delay. By default, this is 60 seconds.
This is a precautionary step to ensure any Azure-end delays don't hinder the subsequent creation of storage containers.

3. Azure Storage Container Creation:
The azurerm_storage_container resource block provisions storage containers.
Containers are created based on combinations derived from the local.container_combinations list, which pairs storage accounts with their intended container names.

4. Local Variables:

storage_accounts: This dictionary defines attributes for each storage account, including its location, resource group, and a list of containers to be created within.
container_combinations: This list derives pairs of storage account names and container names, aiding in automated container creation.

5. Variables:
These provide configurable parameters for the script. They include:
location: Azure region for resource creation.
account_tier, account_replication_type, create_duration, container_access_type: Settings for storage accounts and containers.

6. Terraform Backend Configuration:

This configuration dictates where Terraform's state file is stored. In this instance, it's set to be in an Azure Storage Account. Details like the resource group, storage account name, and container name for state storage are defined here.
Usage:

To deploy, create a feature branch, use terraform init followed by terraform plan/apply with merge request.
To add more storage accounts or containers, adjust the storage_accounts local dictionary. Add entries for new storage accounts or extend the containers list for existing ones.