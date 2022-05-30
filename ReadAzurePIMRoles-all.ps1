Connect-Azuread
Connect-AzAccount

# Set array
$PIMAllRoleResults = @()
$PIMRoleResults = @()
$PIMAllNiRoleResults = @()

$ResNameParent = ""
$ResNameMG = ""
$ResNameSub = ""
$ResNameRG = ""
$inherfilter = ""

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
			AppId_AdObjInfo = $ADObjInfo.AppId
			StartDateTime_RoleAssign = $RoleAssign.StartDateTime
			EndDateTime_RoleAssign = $RoleAssign.EndDateTime
			UserType_AdObjInfo = $ADObjInfo.UserType
			SecurityEnabled_AdObjInfo = $ADObjInfo.SecurityEnabled

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
			}
        #Write-Host $item
		#$item >> ".\PIMRoles-$Restype-$inherfilter-$(get-date -f yyyy-MM-dd).txt"
			
			            
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

  $PIMRoleResultsMG | Export-Csv -Encoding 'UTF8' -Force -Path ".\Azure$Restype-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"
  Return $PIMRoleResultsMG
}

Function GSubscritions {
  # Set array
  $PIMRoleResultsSub = @()

  # Get all Azure Subscriptions
  $Subs = Get-AzSubscription
  
  # Just want to test with set of subscriotions
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

  $PIMRoleResultsSub | Export-Csv -Encoding 'UTF8' -Force -Path ".\Azure$Restype-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"
  Return $PIMRoleResultsSub
}

Function GResourceGroups {
  # Set array
  $PIMRoleResultsRG = @()

  # Rerun subscription part, but only get resource groups. This can take long time (hours)
  # Get all Azure Subscriptions
  $Subs = Get-AzSubscription 
  
  # Just want to test with set of subscriotions
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
    $PIMRoleResultsRG | Export-Csv -Encoding 'UTF8' -Force -Path ".\Azure$ResType-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"
    Return $PIMRoleResultsRg
}

$inherfilter = "noinherit"
$PIMAllRoleResults += GManagementGroups
$PIMAllRoleResults += GSubscritions
$PIMAllRoleResults += GResourceGroups
$PIMAllRoleResults | Export-Csv -Encoding 'UTF8' -Force -Path ".\AzureALL-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"

$inherfilter = "inclinherit"
$PIMAllNiRoleResults += GManagementGroups
$PIMAllNiRoleResults += GSubscritions

# getting resource groups inherited info can take long time. -- and that means many hours
#$PIMAllNiRoleResults += GResourceGroups

$PIMAllNiRoleResults | Export-Csv -Encoding 'UTF8' -Force -Path ".\AzureALL-PIMRoles-$inherfilter-$(get-date -f yyyy-MM-dd-HHmm).csv"
