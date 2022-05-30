Connect-AzureAD

$TenantID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Set array
$PIMAzureADRoleResults = @()


$ADRoles = Get-AzureADMSPrivilegedRoleAssignment -ProviderId "aadRoles" -ResourceId $TenantID

$ResNameParent = ""
$ResName = ""
$Restype = "AzureAD"
#Loop through roles
foreach ($ADRole in $ADRoles) {

		# Get Roleinfo
		$Roleinfo = Get-AzureADMSPrivilegedRoleDefinition -ProviderId 'aadRoles' -ResourceId $TenantID -Id $ADRole.RoleDefinitionId
		$CurrRole = $Roleinfo.DisplayName
		Write-Host "Running $CurrRole"

		# Get ADObjInfo
		$ADObjInfo = Get-AzureADObjectByObjectId -ObjectIds $ADRole.SubjectId

		$item = [PSCustomObject]@{
			Resourcetype = $Restype
			ResourceParent = $ResNameParent
			ResourceName = $ResName
			DisplayName_Roleinfo = $Roleinfo.DisplayName
			AssignmentState_ADRole = $ADRole.AssignmentState
			MemberType_ADRole = $ADRole.MemberType
			StartDateTime_ADRole = $ADRole.StartDateTime
			EndDateTime_ADRole = $ADRole.EndDateTime
			DisplayName_AdObjInfo = $ADObjInfo.DisplayName
			ObjectType_AdObjInfo = $ADObjInfo.ObjectType
			UserPrincipalName_AdObjInfo = $ADObjInfo.UserPrincipalName
			SecurityEnabled_AdObjInfo = $ADObjInfo.SecurityEnabled

			Id_ADRole = $ADRole.Id
			ResourceId_ADRole = $ADRole.ResourceId
			RoleDefinitionId_ADRole = $ADRole.RoleDefinitionId
			SubjectId_ADRole = $ADRole.SubjectId
			LinkedEligibleRoleAssignmentId_ADRole = $ADRole.LinkedEligibleRoleAssignmentId
			ExternalId_ADRole = $ADRole.ExternalId

			Id_Roleinfo = $Roleinfo.Id
			ResourceId_Roleinfo = $Roleinfo.ResourceId
			ExternalId_Roleinfo = $Roleinfo.ExternalId
			SubjectCount_Roleinfo = $Roleinfo.SubjectCount
			EligibleAssignmentCount_Roleinfo = $Roleinfo.EligibleAssignmentCount
			ActiveAssignmentCount_Roleinfo = $Roleinfo.ActiveAssignmentCount

			ObjectId_AdObjInfo = $ADObjInfo.ObjectId
			DeletionTimestamp_AdObjInfo = $ADObjInfo.DeletionTimestamp
			UserType_AdObjInfo = $ADObjInfo.UserType
			AppId_AdObjInfo = $ADObjInfo.AppId
			
		}
    #Write-Host $item
		#$item >> ".\PIMRoles-$Restype.txt"
			
			            
		# Add PS Object to array
    $PIMAzureADRoleResults += $item
			
}

$PIMAzureADRoleResults | Export-Csv -Encoding 'UTF8' -Force -Path ".\$Restype-PIMRoles-$(get-date -f yyyy-MM-dd-HHmm).csv"

