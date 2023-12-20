# App Landing Zone - Subscription Vending Module #

This Terraform module is used to perform subscription vending for any new application landing zone subscriptions,
please review the steps below for deploying new application landing zone subscriptions.

Note: Please ensure you have staged/created the Management Group for this application landing zone, you will need to add this MG name into the yaml file for subscription association. 

Managed by: AWCS team 

1. Ensure the Application Owner has provided details and requirements for the new application workload:
Confirm if the requirements have been set, is the workload production or dev/test? 
Has there been approval for this subscription to be created?

2. Clone the repo and create a feature branch:
Navigate to the cloned repository directory.
Create your feature branch: Git checkout -b "feature/jira-ticket-number-title"

3. Create the new yaml file for the new subscription:
**Important** do not remove any yaml files, these are existing subscriptions for existing application landing zones. 
Create a new yaml file inside of lzdata folder, called "landing_zone_*.yaml << add a new sequenced number each new yaml file, eg. landing_zone_0.yaml, landing_zone_1.yaml, landing_zone_2.yaml 

4. Stage and commit your changes:
Confirm your changed file: Git status
Commit if you are happy: Git commit -m "add a message with the change you made"

5. Push your changes:
After commiting your changes, complete a Git push

6. Confirm the TfSEC results, Fmt check, and Terraform Plan results:
Login to GitLab, Open the Subscription Vending Project, Open the Pipeline, Verify the results for:
 a. TFSEC Results
 b. TF Fmt Passed
 c. TF Plan results are as expected

7. If you are happy with the previous checks, create a Merge Request and add Platform Engineers for review
This step requires a review from a platform engineer and final approval for the merge request to be completed.  

If you are unsure of anything regarding this process, pleaser reach out to the AWCS team. 