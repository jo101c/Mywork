# AVD Application Nerdio
This code deploys the Nerdio application.

## Manual Steps

### Enterprise App API Permissions

The enterprise App API permissions need to be approved by a global admin after creation. You will need to get a global admin to approve them in Azure AD.

### SQL Server Azure AD Authentication Configuration
TODO

### Nerdio App Service Deployment
1. Deploy infrastructure via pipeline.
1. Email nme.support@getnerdio.com to get the latest Azure App package. 
```
Hi there,

We are deploying a new Nerdio setup via Terraform and require the App Service deployment package for manual deployment of the app service (Method 5: Manual Azure Cloud Shell Deployment).

https://nmw.zendesk.com/hc/en-us/articles/4731650896407-Update-the-Nerdio-Manager-Application

Are you able to provide the URL to download the package for Azure App Service for a new deployment? 

$sourceUri = "Obtain URL from Nerdio support (nme.support@getnerdio.com)"

Kind regards,

```
3. Deploy the app.zip via App Service `Advanced Tools` setting.
1. `Advanced Tools` > `go` > `Tools` > `Zip Push Deploy` Upload the `app.zip` file.
1. After upload navigate to the App Service > `WebJobs` and start the web job.
    * Web Job logs are found in the Kudu dashboard (`Advanced Tools`) > `Tools` > `WebJobs Dashboard`.
    * You can also restart the webjob via Kudu > `Site extensions` > restart

 