Param ($userupn)

Function ConnectAzuread {
	# just to reduce azureadconnectrequests
	if  ($userupn) {
		$aadconn = $userupn
	}
	elseif ($($(Get-AzureADCurrentSessionInfo -erroraction SilentlyContinue).account)) {
		$aadconn = $(Get-AzureADCurrentSessionInfo).account
	}
	else {
		Write-host "Please, give your Azure Accout that you want to use."
		$aadconn = read-host
	}
	Connect-AzureAD -AccountId $aadconn
	return $(Get-AzureADCurrentSessionInfo).TenantId
}


Function ConnectAzure {	
	# just to reduce azureconnectrequests
	if  ($aadconn) {
		$azconn = $aadconn
	}
	if  ($userupn) {
		$azconn = $userupn
	}
	elseif ($($(Get-AzContext -erroraction SilentlyContinue).account)) {
		$azconn = $(Get-AzContext).account
	}
	Else {
		write-host "Please, give your Azure Accout that you want to use."
		$azconn = read-host
	}
	Connect-AzAccount -AccountId $azconn
}


$TenantId = ConnectAzuread


# Set array
$PIMAzureADRoleResults = @()

$ResNameParent = ""
$ResName = ""
$Restype = "AzureAD"

#Get all AzureAD roles
$RoleAssigns = Get-AzureADMSPrivilegedRoleAssignment -ProviderId "aadRoles" -ResourceId $TenantId

#Loop through roles
foreach ($RoleAssign in $RoleAssigns) {
	# Get RoleSettings 
	$RoleSettings = Get-AzureADMSPrivilegedRoleSetting -ProviderId "aadRoles" -Filter "(ResourceId eq '$TenantId') and (RoledefinitionID eq '$($RoleAssign.RoleDefinitionId)')"
	

	# Get Roleinfo
	$Roleinfo = Get-AzureADMSPrivilegedRoleDefinition -ProviderId 'aadRoles' -ResourceId $TenantId -Id $RoleAssign.RoleDefinitionId
	$CurrRole = $Roleinfo.DisplayName
	Write-Host "Running $CurrRole"


	# Get ADObjInfo
	$ADObjInfo = Get-AzureADObjectByObjectId -ObjectIds $RoleAssign.SubjectId

	$item = [PSCustomObject]@{
		Resourcetype = $Restype
		ResourceName = $ResName
		DisplayName_RoleDef = $Roleinfo.DisplayName
		AssignmentState_RoleAssign = $RoleAssign.AssignmentState
		MemberType_RoleAssign = $RoleAssign.MemberType
		ResourceParent = $ResNameParent
		ObjectType_AdObjInfo = $ADObjInfo.ObjectType
		DisplayName_AdObjInfo = $ADObjInfo.DisplayName
		UserPrincipalName_AdObjInfo = $ADObjInfo.UserPrincipalName
		StartDateTime_RoleAssign = $RoleAssign.StartDateTime
		EndDateTime_RoleAssign = $RoleAssign.EndDateTime
		Description_AdObjInfo = $ADObjInfo.Description
		UserType_AdObjInfo = $ADObjInfo.UserType
		ServicePrincipalType_AdObjInfo = $ADObjInfo.ServicePrincipalType
		AlternativeNames_AdObjInfo = $ADObjInfo.AlternativeNames -join '£' -replace '(?<!\x0d)\x0a',''
		AppDisplayName_AdObjInfo = $ADObjInfo.AppDisplayName
		IsDefault_RoleSettings = $RoleSettings.IsDefault

		Id_PrivResource = $ResResource.Id
		ExternalId_PrivResource = $ResResource.ExternalId
		Type_PrivResource = $ResResource.Type
		DisplayName_PrivResource = $ResResource.DisplayName
		Status_PrivResource = $ResResource.Status
		RegisteredDateTime_PrivResource = $ResResource.RegisteredDateTime
		RegisteredRoot_PrivResource = $ResResource.RegisteredRoot
		RoleAssignmentCount_PrivResource = $ResResource.RoleAssignmentCount
		RoleDefinitionCount_PrivResource = $ResResource.RoleDefinitionCount
		Permissions_PrivResource = $ResResource.Permissions

		Id_RoleAssign = $RoleAssign.Id
		ResourceId_RoleAssign = $RoleAssign.ResourceId
		RoleDefinitionId_RoleAssign = $RoleAssign.RoleDefinitionId
		SubjectId_RoleAssign = $RoleAssign.SubjectId
		LinkedEligibleRoleAssignmentId_RoleAssign = $RoleAssign.LinkedEligibleRoleAssignmentId
		ExternalId_RoleAssign = $RoleAssign.ExternalId

		Id_RoleDef = $Roleinfo.Id
		ResourceId_RoleDef = $Roleinfo.ResourceId
		ExternalId_RoleDef = $Roleinfo.ExternalId
		SubjectCount_RoleDef = $Roleinfo.SubjectCount
		EligibleAssignmentCount_RoleDef = $Roleinfo.EligibleAssignmentCountEligibleAssignmentCount
		ActiveAssignmentCount_RoleDef = $Roleinfo.ActiveAssignmentCount

		ObjectId_AdObjInfo = $ADObjInfo.ObjectId
		DeletionTimestamp_AdObjInfo = $ADObjInfo.DeletionTimestamp
		AppId_AdObjInfo = $ADObjInfo.AppId
		SecurityEnabled_AdObjInfo = $ADObjInfo.SecurityEnabled

		Id_RoleSettings = $RoleSettings.Id
		ResourceId_RoleSettings = $RoleSettings.ResourceId
		RoleDefinitionId_RoleSettings = $RoleSettings.RoleDefinitionId
		LastUpdatedDateTime_RoleSettings = $RoleSettings.LastUpdatedDateTime
		LastUpdatedBy_RoleSettings = $RoleSettings.LastUpdatedBy
		AdeExpirationRule_RoleSettings = $RoleSettings.AdminEligibleSettings | ForEach-Object {if ($PSItem -match 'ExpirationRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		AdeMfaRule_RoleSettings = $RoleSettings.AdminEligibleSettings | ForEach-Object {if ($PSItem -match 'MfaRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		AdeAttributeConditionRule_RoleSettings = $RoleSettings.AdminEligibleSettings | ForEach-Object {if ($PSItem -match 'AttributeConditionRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		AdmExpirationRule_RoleSettings = $RoleSettings.AdminMemberSettings | ForEach-Object {if ($PSItem -match 'ExpirationRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		AdmMfaRule_RoleSettings = $RoleSettings.AdminMemberSettings | ForEach-Object {if ($PSItem -match 'MfaRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		AdmJustificationRule_RoleSettings = $RoleSettings.AdminMemberSettings | ForEach-Object {if ($PSItem -match 'JustificationRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		AdmAttributeConditionRule_RoleSettings = $RoleSettings.AdminMemberSettings | ForEach-Object {if ($PSItem -match 'AttributeConditionRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		UseAttributeConditionRule_RoleSettings = $RoleSettings.UserEligibleSettings | ForEach-Object {if ($PSItem -match 'AttributeConditionRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		UsmExpirationRule_RoleSettings = $RoleSettings.UserMemberSettings | ForEach-Object {if ($PSItem -match 'ExpirationRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		UsmMfaRule_RoleSettings = $RoleSettings.UserMemberSettings | ForEach-Object {if ($PSItem -match 'MfaRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		UsmJustificationRule_RoleSettings = $RoleSettings.UserMemberSettings | ForEach-Object {if ($PSItem -match 'JustificationRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		UsmTicketingRule_RoleSettings = $RoleSettings.UserMemberSettings | ForEach-Object {if ($PSItem -match 'TicketingRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		UsmApprovalRule_RoleSettings = $RoleSettings.UserMemberSettings | ForEach-Object {if ($PSItem -match 'ApprovalRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		UsmAcrsRule_RoleSettings = $RoleSettings.UserMemberSettings | ForEach-Object {if ($PSItem -match ' AcrsRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}
		UsmAttributeConditionRule_RoleSettings = $RoleSettings.UserMemberSettings | ForEach-Object {if ($PSItem -match 'AttributeConditionRule'){$PSItem -replace '(?<!\x0d)\x0a','' -replace '}}','}' -replace 'class AzureADMSPrivilegedRuleSetting {  RuleIdentifier: ',''}}


	}
	
	# Add PS Object to array
	$PIMAzureADRoleResults += $item

}

$PIMAzureADRoleResults | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\$Restype-PIMRoles-$(get-date -f yyyy-MM-dd-HHmm).csv"
$PIMAzureADRoleResults | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\$Restype-PIMRoles.csv"
