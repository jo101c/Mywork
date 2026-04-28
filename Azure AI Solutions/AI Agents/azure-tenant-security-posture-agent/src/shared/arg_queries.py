DEFENDER_RECOMMENDATIONS_QUERY = """
SecurityResources
| where type == 'microsoft.security/assessments'
| extend assessmentKey = name
| extend status = tostring(properties.status.code)
| extend displayName = tostring(properties.displayName)
| extend description = tostring(properties.metadata.description)
| extend severity = tostring(properties.metadata.severity)
| extend remediation = tostring(properties.metadata.remediationDescription)
| where status !in~ ('Healthy', 'NotApplicable')
| project subscriptionId, resourceId=tostring(properties.resourceDetails.id), resourceType=tostring(properties.resourceDetails.source), title=displayName, description, severity, remediation, assessmentKey
"""

PUBLIC_STORAGE_ACCESS_QUERY = """
Resources
| where type =~ 'microsoft.storage/storageaccounts'
| extend publicNetworkAccess = tostring(properties.publicNetworkAccess)
| extend allowBlobPublicAccess = tostring(properties.allowBlobPublicAccess)
| where publicNetworkAccess =~ 'Enabled' or allowBlobPublicAccess =~ 'true'
| project subscriptionId, resourceId=id, resourceType=type, title=name, description=strcat('Storage account public settings: publicNetworkAccess=', publicNetworkAccess, ', allowBlobPublicAccess=', allowBlobPublicAccess)
"""

KEY_VAULT_HARDENING_QUERY = """
Resources
| where type =~ 'microsoft.keyvault/vaults'
| extend publicNetworkAccess = tostring(properties.publicNetworkAccess)
| extend enablePurgeProtection = tostring(properties.properties.enablePurgeProtection)
| extend enableSoftDelete = tostring(properties.properties.enableSoftDelete)
| where publicNetworkAccess =~ 'Enabled' or enablePurgeProtection !~ 'true'
| project subscriptionId, resourceId=id, resourceType=type, title=name, description=strcat('Key Vault hardening gap: publicNetworkAccess=', publicNetworkAccess, ', purgeProtection=', enablePurgeProtection, ', softDelete=', enableSoftDelete)
"""

SQL_PUBLIC_ACCESS_QUERY = """
Resources
| where type =~ 'microsoft.sql/servers'
| extend publicNetworkAccess = tostring(properties.publicNetworkAccess)
| where publicNetworkAccess =~ 'Enabled'
| project subscriptionId, resourceId=id, resourceType=type, title=name, description='Azure SQL server has public network access enabled'
"""

APPSERVICE_PUBLIC_ACCESS_QUERY = """
Resources
| where type in~ ('microsoft.web/sites', 'microsoft.web/sites/slots')
| extend httpsOnly = tostring(properties.httpsOnly)
| extend publicNetworkAccess = tostring(properties.publicNetworkAccess)
| where httpsOnly !~ 'true' or publicNetworkAccess =~ 'Enabled'
| project subscriptionId, resourceId=id, resourceType=type, title=name, description=strcat('App Service security gap: httpsOnly=', httpsOnly, ', publicNetworkAccess=', publicNetworkAccess)
"""

COSMOS_PUBLIC_ACCESS_QUERY = """
Resources
| where type =~ 'microsoft.documentdb/databaseaccounts'
| extend publicNetworkAccess = tostring(properties.publicNetworkAccess)
| where publicNetworkAccess =~ 'Enabled'
| project subscriptionId, resourceId=id, resourceType=type, title=name, description='Cosmos DB account has public network access enabled'
"""

AKS_HARDENING_QUERY = """
Resources
| where type =~ 'microsoft.containerservice/managedclusters'
| extend apiServerAuthorizedIPRanges = tostring(properties.apiServerAccessProfile.authorizedIpRanges)
| extend enablePrivateCluster = tostring(properties.apiServerAccessProfile.enablePrivateCluster)
| extend disableLocalAccounts = tostring(properties.disableLocalAccounts)
| where enablePrivateCluster !~ 'true' or disableLocalAccounts !~ 'true'
| project subscriptionId, resourceId=id, resourceType=type, title=name, description=strcat('AKS hardening gap: privateCluster=', enablePrivateCluster, ', disableLocalAccounts=', disableLocalAccounts, ', authorizedIpRanges=', apiServerAuthorizedIPRanges)
"""

PUBLIC_IP_EXPOSURE_QUERY = """
Resources
| where type =~ 'microsoft.network/publicipaddresses'
| project subscriptionId, resourceId=id, resourceType=type, title=name, description='Public IP address present and potentially internet reachable'
"""

