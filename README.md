# PIMinfo-Powershell

Two separated powershell's 
- one to pull out info of AzureAD PIM (privileged identity management) roles from Tenant
- one to pull out info of Azure PIM  (privileged identity management) roles from Azure Resources

Code results one or more csv files. That means some "extra info".
- Azure AD --> one csv with all info that is collected 
- Azure --> multiple csv with all info that is collected (separated files management groups, subscriptions and resource groups. Plus separated files direct Roles and direct+inherited roles (yes, bit overwhelming..)

Requires Powershell AzureAD preview 2.0 (30.05.2022 - v2.0.2.149)
- and remember because it is preview it can change. And there is limitations (like API returns only 200 results, whitch is one reason for loops)

There is still few things in code that are "under construction". So that explains few extra parameter reservations.

And I know.. this code is not optimized + some parts of the code.. just bare with it..


AzureAD is bit more straightforward - And remember Privileged role assignments are unique Id:s in each azure tenant.

![image](https://user-images.githubusercontent.com/57322488/170950501-e390e409-21ff-4118-a494-b4b179035011.png)


But getting Roles from Azure is bit more comlicated

![image](https://user-images.githubusercontent.com/57322488/170955949-98374cbc-8d81-403b-91aa-f58a09421746.png)



First of all.. dont get confused with different ID strings and names of those strings.

- Get-AzureADMSPrivilegedResource -ProviderId 'AzureResources'  -Filter $FindString 
#picks up just desired resource  based on filter

- Get-AzureADMSPrivilegedRoleAssignment -ProviderId 'AzureResources' -ResourceId $ResResource.id 
#Gets role assignments from ResourceID from previous command -- result is mainly different ID information

- Get-AzureADMSPrivilegedRoleDefinition -ProviderId 'AzureResources' -ResourceId $ResResource.id -id $RoleAssign.RoleDefinitionId
#Gets more readable Roledefinition info based on ResourceID and Roleassignment RoledefinitionId

- Get-AzureADObjectByObjectId -ObjectIds $RoleAssign.SubjectId
#Gets more readable Roledefinition info from AzureAD based on Roleassignment SubjectID (AzureAD ObjectID)

Resulting csv:s can be used to figure out current roles. And use filtered info as input to clean up current environment.

It is also possible to maintain Roles with powershell.. But maybe more about that later.
