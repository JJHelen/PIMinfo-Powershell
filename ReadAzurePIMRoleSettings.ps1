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


	# Get Roleinfo
	$ListofRolessets = Get-AzureADMSPrivilegedRoleSetting -ProviderId 'AzureResources' -Filter "ResourceId eq '$($ResResource.Id)'"

	foreach ($RoleSettings in $ListofRolessets) {

		$Roleinfo = Get-AzureADMSPrivilegedRoleDefinition -ProviderId 'AzureResources' -ResourceId $RoleSettings.ResourceId -id $RoleSettings.RoleDefinitionId
		$item = [PSCustomObject]@{
			Id_RoleSettings = $RoleSettings.Id
			IsDefault_RoleSettings = $RoleSettings.IsDefault
			LastUpdatedDateTime_RoleSettings = $RoleSettings.LastUpdatedDateTime
			LastUpdatedBy_RoleSettings = $RoleSettings.LastUpdatedBy
			ResourceId_RoleSettings = $RoleSettings.ResourceId
			DisplayName_ResResource = $ResResource.DisplayName
			RoleDefinitionId_RoleSettings = $RoleSettings.RoleDefinitionId
			DisplayName_Roleinfo= $Roleinfo.DisplayName
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
			$PIMRoleResults += $item
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

	$PIMRoleResultsMG | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\Az$Restype-PIMRoleSettings-$(get-date -f yyyy-MM-dd-HHmm).csv" 
	$PIMRoleResultsMG | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\Az$Restype-PIMRoleSettings.csv"
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

	$PIMRoleResultsSub | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\Az$Restype-PIMRoleSettings-$(get-date -f yyyy-MM-dd-HHmm).csv"
	$PIMRoleResultsSub | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\Az$Restype-PIMRoleSettings.csv"
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
	$PIMRoleResultsRG | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\Az$ResType-PIMRoleSettings-$(get-date -f yyyy-MM-dd-HHmm).csv"
	$PIMRoleResultsRG | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\Az$ResType-PIMRoleSettings.csv"
	Return $PIMRoleResultsRg
}

ConnectAzuread
ConnectAzure
$inherfilter = "noinherit"
$PIMAllRoleResults += GManagementGroups
$PIMAllRoleResults += GSubscritions
$PIMAllRoleResults += GResourceGroups
$PIMAllRoleResults | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\done\AzALL-PIMRoleSettings-$(get-date -f yyyy-MM-dd-HHmm).csv"
$PIMAllRoleResults | Export-Csv -Encoding 'UTF8' -NoTypeInformation -Force -Path ".\latest\AzALL-PIMRoleSettings.csv"

