Param ($userupn)

# Set array
$PIMAllRoleResults = @()
$PIMRoleResults = @()
$PIMAllNiRoleResults = @()

$ResNameParent = ""
$ResNameMG = ""
$ResNameSub = ""
$ResNameRG = ""
$inherfilter = ""

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

Function FindRoles{
	Write-Host "working with $ResName"

	#$PIMAllRoleResults = @()
	$PIMRoleResults = @()

	# Get Resourceinfo
	$ResResource = Get-AzureADMSPrivilegedResource -ProviderId 'AzureResources'  -Filter $FindString

	# Get List of Roleassignments
	If ($inherfilter -eq "noinherit") {
		$RoleAssignments = Get-AzureADMSPrivilegedRoleAssignment -ProviderId 'AzureResources' -ResourceId $ResResource.id -Filter "MemberType ne 'Inherited'"
	}
	Else { 
		$RoleAssignments = Get-AzureADMSPrivilegedRoleAssignment -ProviderId 'AzureResources' -ResourceId $ResResource.id
	}

	# Loop through all RoleAssignments
	foreach ($RoleAssign in $RoleAssignments) {
		# Get RoleSettings 
		$RoleSettings = Get-AzureADMSPrivilegedRoleSetting -ProviderId 'AzureResources' -Filter "(ResourceId eq '$($ResResource.id)') and (RoledefinitionID eq '$($RoleAssign.RoleDefinitionId)')"

		# Get Roleinfo
		$Roleinfo = Get-AzureADMSPrivilegedRoleDefinition -ProviderId 'AzureResources' -ResourceId $ResResource.id -id $RoleAssign.RoleDefinitionId

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
		$item >> ".\txt\PIMRoles-$Restype-$inherfilter-$(get-date -f yyyy-MM-dd).txt"
		
        
		# Add PS Object to array
        $PIMRoleResults += $item
		#$PIMAllRoleResults  += $item
	}
	Return $PIMRoleResults
}

Function GManagementGroups {
# Set array
$PIMRoleResultsMG = @()

# Get all management groups
$MgmtGroups = Get-AzManagementGroup
# Loop through all Management Groups
foreach ($MgmtGrp in $MgmtGroups) {
	$Restype = "ManagementGroup"
	$ResName = $MgmtGrp.displayname
	$ResNameMG = $MgmtGrp.displayname
	$ResId = $MgmtGrp.name
	$FindString = "ExternalId eq '/providers/Microsoft.Management/managementGroups/$ResId'"
	
	$PIMRoleResultsMG += FindRoles
}

$PIMRoleResultsMG | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\Azure$Restype-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"
$PIMRoleResultsMG | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\Azure$Restype-PIMRoles-$inherfilter.csv"
Return $PIMRoleResultsMG
}

Function GSubscritions {
# Set array
$PIMRoleResultsSub = @()

# Get all Azure Subscriptions
$Subs = Get-AzSubscription
# $currdir = Get-Location
# $Subs = import-csv -path $currdir\subscriptions.txt

# Loop through all Subscriptions
foreach ($Sub in $Subs) {
	$ResType = "Subscription"
	$ResNameSub = $sub.name
	$ResName = $sub.name
	$ResId = $sub.id
	$FindString = "ExternalId eq '/subscriptions/$ResId'"

	$PIMRoleResultsSub += FindRoles
}

$PIMRoleResultsSub | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\Azure$Restype-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"
$PIMRoleResultsSub | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\Azure$Restype-PIMRoles-$inherfilter.csv"
Return $PIMRoleResultsSub
}

Function GResourceGroups {
# Set array
$PIMRoleResultsRG = @()

# Get all Azure Subscriptions
$Subs = Get-AzSubscription
# $currdir = Get-Location
# $Subs = import-csv -path $currdir\subscriptions.txt

# Loop through all Subscriptions
foreach ($Sub in $Subs) {
	Set-AzContext $Sub.Id
	$ResNameSUB = $sub.name
	$ResIdSub = $Sub.id
	$ResNameParent = $sub.name
	$ResGroups = Get-AzResourceGroup
	
	Write-Host "Working with Sub $ResNameSUB ResourceGroups"

	foreach ($RG in $ResGroups) {
		$ResType = "ResourceGroup"
		$ResName = $RG.ResourceGroupName
		$ResNameRG = $RG.ResourceGroupName
		$ResIdRG = $RG.id
		$FindString = "ExternalId eq '/subscriptions/$ResIdSub/resourceGroups/$ResNameRG'"

		$PIMRoleResultsRG += FindRoles
		}
}
	$PIMRoleResultsRG | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\Azure$ResType-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"
	$PIMRoleResultsRG | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\Azure$ResType-PIMRoles-$inherfilter.csv"
	Return $PIMRoleResultsRg
}

ConnectAzuread
ConnectAzure
$inherfilter = "noinherit"
$PIMAllRoleResults += GManagementGroups
$PIMAllRoleResults += GSubscritions
$PIMAllRoleResults += GResourceGroups
$PIMAllRoleResults | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\AzureALL-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"
$PIMAllRoleResults | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\AzureALL-PIMRoles-$inherfilter.csv"

$inherfilter = "inclinherit"
$PIMAllNiRoleResults += GManagementGroups
$PIMAllNiRoleResults += GSubscritions
#$PIMAllNiRoleResults += GResourceGroups
$PIMAllNiRoleResults | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\AzureALL-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"
$PIMAllNiRoleResults | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\AzureALL-PIMRoles-$inherfilter.csv"
