# Introduction 
This module is used for deploying Azure Alert Rules into the Angle Auto Tenant. The way alert rules are deployed via this module is by using a for_each loop against the criterea's inside of locals.tf. 

The for_each loop in the resource blocks will loop through each locals criteria block and create additional alert rules for each. 

# Getting Started

1.	Reference this module in your repo
2.	Adjust locals.tf for the alert rule types needed to deploy
3.  Modify variables.tf resource scopes for the resouces requiring the alert rule
4.  Adjust variables.tf according to the resources you are deploying