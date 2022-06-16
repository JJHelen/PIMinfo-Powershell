Param ($userupn, $changefile='SetPIM-Change-these-resource-role-settings.csv')

Function ConnectAzuread {
	# just to reduce azureadconnectrequests
	if  ($userupn) {
		$aadconn = $userupn
	}
	elseif ($($(Get-AzureADCurrentSessionInfo -erroraction silentylycontinue).account)) {
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
	elseif ($($(Get-AzContext).account -erroraction silentylycontinue)) {
		$azconn = $(Get-AzContext).account
	}
	Else {
		write-host "Please, give your Azure Accout that you want to use."
		$azconn = read-host
	}
	Connect-AzAccount -AccountId $azconn
}

Function BuildPimSettings ($PimRule) {
<# This function builds up needed RuleSets based on select-pimsettings.txt. When you use list powershells, those will list current settings in correct format to use in txt file.
 Robust, but it does the trick.. And easy way to get familiar of setting options and make this code much better
 Few pointers- and I do hope that i have documented these correctly -- so dont take these too seriously
	AdeExpirationRule -- sets Elible permanent assignment (and/or maximum eligble assignment time)  (portal: assignment->eligble permanent assignment)
	AdmExpirationRule -- sets Actice permanent assignment (and/or maximum Acitve assignment time) (portal: assignment->permanent active assignment)
	AdmMfaRule -- sets Elibgle MFA requirement (portal: assignment->eligble permanent assignment)
	AdmJustificationRule -- sets AdminAdd justification requirement (portal: assignment->Justification)
	UsmExpirationRule -- sets eligble to active maximum activation time (Portal:assignment->eligble permanent)
	UsmMfaRule -- sets eligble to active mfa requirement (portal: activation - MFA)
	UsmJustificationRule -- sets eligble to active justification requirement (portal: activation - Justification)
	UsmTicketingRule -- sets eligble to active Ticketing requirement(portal: activation - Ticketing)
	UsmApprovalRule -- sets eligble to active approvers requirement(portal: activation - Approvers)
	
#>
$PIMAdeSetting = @()
$PIMAdmSetting = @()
$PIMUseSetting = @()
$PIMUsmSetting = @()

	$PIMAdeSetting1 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMAdeSetting1.RuleIdentifier = $($PimRule.AdeExpirationRule_RoleSettings).split(' ')[0]
		$PIMAdeSetting1.Setting = $PimRule.AdeExpirationRule_RoleSettings -replace 'ExpirationRule  Setting: ',''
	$PIMAdeSetting2 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMAdeSetting2.RuleIdentifier = $($PimRule.AdeMfaRule_RoleSettings).split(' ')[0]
		$PIMAdeSetting2.Setting = $PimRule.AdeMfaRule_RoleSettings -replace 'MfaRule  Setting: ',''
	$PIMAdeSetting3 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMAdeSetting3.RuleIdentifier = $($PimRule.AdeAttributeConditionRule_RoleSettings).split(' ')[0]
		$PIMAdeSetting3.Setting = $PimRule.AdeAttributeConditionRule_RoleSettings -replace 'AttributeConditionRule  Setting: ',''
	$PIMAdeSetting += $PIMAdeSetting1
	$PIMAdeSetting += $PIMAdeSetting2
	$PIMAdeSetting += $PIMAdeSetting3
		
	$PIMAdmSetting1 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMAdmSetting1.RuleIdentifier = $($PimRule.AdmExpirationRule_RoleSettings).split(' ')[0]
		$PIMAdmSetting1.Setting = $PimRule.AdmExpirationRule_RoleSettings -replace 'ExpirationRule  Setting: ',''
	$PIMAdmSetting2 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMAdmSetting2.RuleIdentifier = $($PimRule.AdmMfaRule_RoleSettings).split(' ')[0]
		$PIMAdmSetting2.Setting = $PimRule.AdmMfaRule_RoleSettings -replace 'MfaRule  Setting: ',''
	$PIMAdmSetting3 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMAdmSetting3.RuleIdentifier = $($PimRule.AdmJustificationRule_RoleSettings).split(' ')[0]
		$PIMAdmSetting3.Setting = $PimRule.AdmJustificationRule_RoleSettings -replace 'JustificationRule  Setting: ',''
	$PIMAdmSetting4 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMAdmSetting4.RuleIdentifier = $($PimRule.AdmAttributeConditionRule_RoleSettings).split(' ')[0]
		$PIMAdmSetting4.Setting = $PimRule.AdmAttributeConditionRule_RoleSettings -replace 'AttributeConditionRule  Setting: ',''
	$PIMAdmSetting += $PIMAdmSetting1
	$PIMAdmSetting += $PIMAdmSetting2
	$PIMAdmSetting += $PIMAdmSetting3
	$PIMAdmSetting += $PIMAdmSetting4
	$PIMUseSetting1 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMUseSetting1.RuleIdentifier = $($PimRule.UseAttributeConditionRule_RoleSettings).split(' ')[0]
		$PIMUseSetting1.Setting = $PimRule.UseAttributeConditionRule_RoleSettings -replace 'AttributeConditionRule  Setting: ',''
	$PIMUseSetting += $PIMUseSetting1
	$PIMUsmSetting1 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMUsmSetting1.RuleIdentifier = $($PimRule.UsmExpirationRule_RoleSettings).split(' ')[0]
		$PIMUsmSetting1.Setting = $PimRule.UsmExpirationRule_RoleSettings -replace 'ExpirationRule  Setting: ',''
	$PIMUsmSetting2 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMUsmSetting2.RuleIdentifier = $($PimRule.UsmMfaRule_RoleSettings).split(' ')[0]
		$PIMUsmSetting2.Setting = $PimRule.UsmMfaRule_RoleSettings -replace 'MfaRule  Setting: ',''
	$PIMUsmSetting3 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMUsmSetting3.RuleIdentifier = $($PimRule.UsmJustificationRule_RoleSettings).split(' ')[0]
		$PIMUsmSetting3.Setting = $PimRule.UsmJustificationRule_RoleSettings -replace 'JustificationRule  Setting: ',''
	$PIMUsmSetting4 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMUsmSetting4.RuleIdentifier = $($PimRule.UsmTicketingRule_RoleSettings).split(' ')[0]
		$PIMUsmSetting4.Setting = $PimRule.UsmTicketingRule_RoleSettings -replace 'TicketingRule  Setting: ',''
	$PIMUsmSetting5 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMUsmSetting5.RuleIdentifier = $($PimRule.UsmApprovalRule_RoleSettings).split(' ')[0]
		$PIMUsmSetting5.Setting = $PimRule.UsmApprovalRule_RoleSettings -replace 'ApprovalRule  Setting: ',''
	$PIMUsmSetting6 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMUsmSetting6.RuleIdentifier = $($PimRule.UsmAcrsRule_RoleSettings).split(' ')[0]
		$PIMUsmSetting6.Setting = $PimRule.UsmAcrsRule_RoleSettings -replace 'AcrsRule  Setting: ',''
	$PIMUsmSetting7 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
		$PIMUsmSetting7.RuleIdentifier = $($PimRule.UsmAttributeConditionRule_RoleSettings).split(' ')[0]
		$PIMUsmSetting7.Setting = $PimRule.UsmAttributeConditionRule_RoleSettings -replace 'AttributeConditionRule  Setting: ',''
	$PIMUsmSetting += $PIMUsmSetting1
	$PIMUsmSetting += $PIMUsmSetting2
	$PIMUsmSetting += $PIMUsmSetting3
	$PIMUsmSetting += $PIMUsmSetting4
	$PIMUsmSetting += $PIMUsmSetting5
	$PIMUsmSetting += $PIMUsmSetting6
	$PIMUsmSetting += $PIMUsmSetting7

Return $PIMAdeSetting, $PIMAdmSetting, $PIMUseSetting, $PIMUsmSetting

}

Function Checkruleexists ($checkrule, $rulelist) {
	if ($checkrule -in $rulelist){
		Return $true
	}
	Else {
		Return $false
	}
	
}


ConnectAzuread $userupn
ConnectAzure $userupn
$currdir = Get-Location

#List of Roles to change - Two first columns can be picked from List powershells results.
# (RoleSettingsToUse,DisplayName_RoleDef,DisplayName_Resource,Id_PrivResource) note DisplayName_Resource does not work yet!!
$Changethese = import-csv -path $currdir\$changefile


#Read List of PIM settings option, First column is used as reference whitch to pick. Delimeter must be something else than, Because comma is used inside RoleSettings
#(Rulename;AdeExpirationRule_RoleSettings;AdeMfaRule_RoleSettings;AdeAttributeConditionRule_RoleSettings;AdmExpirationRule_RoleSettings;AdmMfaRule_RoleSettings;AdmJustificationRule_RoleSettings;AdmAttributeConditionRule_RoleSettings;UseAttributeConditionRule_RoleSettings;UsmExpirationRule_RoleSettings;UsmMfaRule_RoleSettings;UsmJustificationRule_RoleSettings;UsmTicketingRule_RoleSettings;UsmApprovalRule_RoleSettings;UsmAcrsRule_RoleSettings;UsmAttributeConditionRule_RoleSettings)
$PIMSetRules = import-csv -path $currdir\SetPIM-Rolesettings-selection.csv -Delimiter ';'

# Loop through Resources/Roles you want to set up
foreach ($Changeobj in $Changethese) {
	write-host "Setting RoleSettings for $($Changeobj.DisplayName_RoleDef) in Resource $($Changeobj.DisplayName_Resource) ID $($Changeobj.Id_PrivResource)"
	write-host "at line $($Changeobj.count)"
	write-host ""

	$RoleName = $Changeobj.DisplayName_RoleDef
	$ResID = $Changeobj.Id_PrivResource
	$RuleSetToUse = $Changeobj.RoleSettingsToUse
	$PimRuletoUse = $PIMSetRules | Where Rulename -eq $RuleSetToUse
	
	If (Checkruleexists -checkrule $RuleSetToUse -rulelist $PIMSetRules.Rulename) {
		$SetRoleSettings = BuildPimSettings -PimRule $PimRuletoUse
	# Find correct RoleDefenitionID
	$PimRoleID = Get-AzureADMSPrivilegedRoleDefinition -ProviderId 'AzureResources' -ResourceId $ResID | where DisplayName -eq $RoleName

	# Find RoleSettingsID to use
	$PIMSetId = Get-AzureADMSPrivilegedRoleSetting -ProviderId 'AzureResources' -Filter "(ResourceId eq '$($PimRoleID.ResourceId)') and (RoledefinitionID eq '$($PimRoleID.Id)')"


	"$Changeobj # $RoleName is set to use $RuleSetToUse" >> .\done\changed-these-resource-role-settings-$(get-date -f yyyy-MM-dd).txt 
	Set-AzureADMSPrivilegedRoleSetting -ProviderId "AzureResources" -Id $($PIMSetId.Id) -ResourceId $($PimRoleID.ResourceId) -RoleDefinitionId $($PimRoleID.Id) -AdminEligibleSettings $($SetRoleSettings[0]) -AdminMemberSettings $($SetRoleSettings[1]) -UserEligibleSettings $($SetRoleSettings[2]) -UserMemberSettings $($SetRoleSettings[3])
	

	}
	Else {
		$errorinfo = "wanted ruleset $RuleSetToUse does not exists."
		"$errorinfo # $Changeobj # $RuleSetToUse does not exist" >> .\done\failed-these-resource-role-settings-$(get-date -f yyyy-MM-dd).txt 
	}


}
# Copy used textfiles to Done folder with Date/time information
copy $currdir\SetPIM-Rolesettings-selection.csv .\Done\used-these-pimsettings-$(get-date -f yyyy-MM-dd-HHmm).csv
Copy $currdir\changefile .\Done\Wanted-to-change-these-resource-role-settings-$(get-date -f yyyy-MM-dd-HHmm).csv
