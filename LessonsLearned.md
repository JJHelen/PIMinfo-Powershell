More or less same things that I have written below apply to Azure and AzureAD resources
- On AADRoles PrivilegedReosurcesID or ResourceID is allways TenantID

Azure Resources first you need 
PrivilegedReosurces Id (command Get-AzureADMSPrivilegedResource) Best way that I found was filtering with ExternalID string
  - ExternalID (following shows MG, Subscription and RG examples"
    - "/providers/Microsoft.Management/managementGroups/'managementgroupID'"
    - "/subscriptions/'SubscriptionID'"
    - "/subscriptions/'SubscriptionID'/resourceGroups/'ResourceGroupName'"
  - This ID is referenced as ResourceID in other xxx-AzureADMSPrivilegedxxxx commands

PrivilegedRoleDefinition ID -- Dont get fooled with idea that it is same as Azure Built-in-RBAC roles ID). It can be same -- or it might be different. 
  - This ID is referenced as RoleDefinitionID in other xxx-AzureADMSPrivilegedxxxx commands
  - ExternalID in this command includes Azure Built-in-RBAC roles ID.

PrivilegedRoleSettings Get command needs Filter, its the only way that I got it to work at this point. And SET needs RoleSettingsID (whitch is unique in each envrionment). 
  - And only way to find RoleDefinitionID is Described above
  - At this point I have not found any way to Get or Set notification settings -- I hope that this will be possible later
  - RoleSettings are List Type, the way I have extracted information gives base to build Set commands

PrivilegedRoleAssignments 
  - Activated Eligible roles have LinkedEligibleRoleAssignmentId (reference to RoleAssignmentID) to point out what is original EligibleAssignment

Using AzureADObjectByObjectID
  - To get more information you can get DisplayName, Description or even extract groupmembers 
  - for Applications use AppDisplayName, ServicePrincipalType and AlternativeNAmes (List type) etc.. to get more info than just ObjectID

Moretocome
