# PIMinfo-Powershell

Two seperated powershell's 
-- one to pull out info of AzureAD PIM (priviledge identity management) roles from tenant
-- one to pull out onfo of Azure PIM  (priviledge identity management) roles from tenantroot group

Code results csv files.
-- Azure AD --> one csv with all info that is collected
-- Azure --> multiple csv with all info that is collected (separated files management groups, subscriptions and resource groups. Plus seperated files direct Roles and direct+inherited roles (yes, bit overhelming..)

Requires Powershell AzureAD preview 2.0 (30.05.2022 - v2.0.2.149)
-- and remember becaouse it is preview it can change

There is still few things in code that are "under construction". So that explains few extra parameter reservations.

And I know.. this code is not optimized

