function Start-TeamsVoiceAssessment {

    # Install the Teams PowerShell module
    if (-not (Get-Module -Name MicrosoftTeams)) {
        Write-Host "Latest Teams Module not found. Installing Teams Module"
        Install-Module -Name MicrosoftTeams -Force -AllowClobber
    }
    
    # Import the Teams PowerShell module
    Import-Module MicrosoftTeams

    # Install the AzureAD PowerShell module
    if (-not (Get-Module -Name AzureAD)) {
        Write-Host "Latest AzureAD Module not found. Installing AzureAD Module"
        Install-Module -Name AzureAD -Force -AllowClobber
    }
    
    # Import the AzureAD PowerShell module
    Import-Module AzureAD

    # Install the ImportExcel PowerShell module
    if (-not (Get-Module -Name ImportExcel)) {
        Write-Host "Latest ImportExcel Module not found. Installing ImportExcel Module"
        Install-Module -Name ImportExcel -Force -AllowClobber
    }
    
    # Import the ImportExcel PowerShell module
    Import-Module ImportExcel

    # Connect to Teams
    Write-Host "Connecting to Teams" -NoNewline
    Connect-MicrosoftTeams -ErrorAction SilentlyContinue
    Write-Host " - Connected" -ForegroundColor Green

    # Connect to Azure AD
    Write-Host "Connecting to Azure AD" -NoNewline
    Connect-AzureAD
    Write-Host " - Connected" -ForegroundColor Green

    # Get the Tenant Name
    $tenantName = (Get-CsTenant).DisplayName
    Write-Host "Tenant Name: $($tenantName)"
    
    # Set Output Directory
    $outputDirectory = "C:\temp\$tenantName\TeamsVoiceAssessment"
    Write-Host "Output Directory:" -NoNewline
    Write-Host " $outputDirectory" -ForegroundColor Green
    
    # Create the Output Directory
    if (-not (Test-Path -Path $outputDirectory)) {
        New-Item -Path $outputDirectory -ItemType Directory
    }

    # Get the Teams Calling Line Identity
    $CallingLineIdArray = @()
    $CallingLineId = Get-CsCallingLineIdentity
    foreach ($line in $CallingLineId) {
        $CallingLineIdArray += [PSCustomObject]@{
            Identity = $line.Identity
            ResourceAccount = if ($($line.Identity) -eq "Global") { "Global" } else { (Get-CsOnlineUser -Identity $($line.ResourceAccount)).UserPrincipalName }
            Description = $line.Description
            ConfigID = $line.ConfigID
            ScopeClass = $line.Key.ScopeClass
            SchemeId = $line.Key.SchemeId
            AuthorityId = $line.Key.AuthorityId
            BlockIncomingPSTNCallerId = $line.BlockIncomingPSTNCallerId
        }
    }
    Write-Host "Calling Line Identity: $($CallingLineIdArray.Count)"   
    $CallingLineIdArray | Export-Csv -Path "$outputDirectory\CallingLineIdentity-$($tenantName).csv" -NoTypeInformation

    # Get Auto Attendants
    $autoAttendantArray = @()
    $AutoAttendant = Get-CsAutoAttendant
    foreach ($line in $AutoAttendant) {
        $autoAttendantArray += [PSCustomObject]@{
            Identity = $line.Name
            Id = $line.Id
            TimeZoneId = $line.TimeZoneId
            DefaultCallFlow = $line.DefaultCallFlow.name
            Operator = $line.Operator.name
            VoiceResponseEnabled = $line.VoiceResponseEnabled
            CallFlowsTotal = $line.CallFlows.Count
            ScheduleTotal = $line.Schedules.Count
            ScheduleName = $line.Schedules.Name
            CallHandlingAssociations = $line.CallHandlingAssociations.Name
            DirectoryLookupInclusionScope = $line.DirectoryLookupScope.InclusionScope
            DirectoryLookupExclusionScope = $line.DirectoryLookupScope.ExclusionScope
        }
    }
    Write-Host "Auto Attendants: $($autoAttendantArray.Count)"
    $AutoAttendantArray | Export-Csv -Path "$outputDirectory\AutoAttendant-$($tenantName).csv" -NoTypeInformation

    # Get Call Queues
    $CallQueue = Get-CsCallQueue 
    $CallQueueArray = @()
    foreach ($line in $CallQueue) {
        $CallQueueArray += [PSCustomObject]@{
            Name = $line.Name
            Id = $line.Identity
            RoutingMethod = $line.RoutingMethod
            DistributionMethod = $line.DistributionLists.Guid
            DistributionListsLastExpanded = $line.DistributionListsLastExpanded.date
            AgentsTotal = $line.Agents.Count
            AgentsAvailable = $line.Agents.ObjectId
            Agents = if($null -ne $line.Agents.ObjectId){($line.Agents.ObjectId | ForEach-Object { (Get-CsOnlineUser -Identity $_).UserPrincipalName }) -join "; "} else {""}
            AllowOptOut = $line.AllowOptOut
            ConfrenceMode = $line.ConferenceMode
            PresenseBasedRouting = $line.PresenceBasedRouting
            AgentsCapped = $line.AgentsCapped
            OverflowAction = $line.OverflowAction
            TimeoutThreshold = $line.TimeoutThreshold
            TimeoutAction = $line.TimeoutAction
            TimeoutActionTarget = if ($line.TimeoutActionTargetType -eq "Mailbox") {(Get-AzureADGroup -ObjectId $line.TimeoutActionTargetId).DisplayName} elseif ($line.TimeoutActionTargetType -eq "User") {(Get-AzureADUser -ObjectId $line.TimeoutActionTargetId).DisplayName} else {""}
            TimeoutActionTargetType = $line.TimeoutActionTarget.Type
            Language = $line.LanguageId
        }
    }
    Write-Host "Call Queues: $($CallQueueArray.Count)"
    $CallQueueArray | Export-Csv -Path "$outputDirectory\CallQueue-$($tenantName).csv" -NoTypeInformation

    # Get the Dial Plan
    $DialPlan = Get-CsDialPlan
    Write-Host "Dial Plan: $($DialPlan.Count)"
    $DialPlan | Export-Csv -Path "$outputDirectory\DialPlan-$($tenantName).csv" -NoTypeInformation

    # Get Teams Emergency Calling Policy
    $EmergencyCallingPolicy = Get-CsTeamsEmergencyCallingPolicy
    $EmergencyCallingPolicyArray = @()
    foreach ($line in $EmergencyCallingPolicy) {
        $EmergencyCallingPolicyArray += [PSCustomObject]@{
            Identity = $line.Identity
            Description = $line.Description
            NotificationGroup = $line.NotificationGroup.Split(";") -join "`n"
            NotificatiionDialOutNumber = $line.NotificationDialOutNumber
            ExternalLocaitonLookupMode = $line.ExternalLocationLookupMode
            NotificationMode = $line.NotificationMode
            EnhancedEmergencyServiceDisclaimer = $line.EnhancedEmergencyServiceDisclaimer
        }
    }
    Write-Host "Emergency Calling Policy: $($EmergencyCallingPolicyArray.Count)"
    $EmergencyCallingPolicyArray | Export-Csv -Path "$outputDirectory\EmergencyCallingPolicy-$($tenantName).csv" -NoTypeInformation

    # Get the External Access Policy
    $ExternalAccessPolicy = Get-CsExternalAccessPolicy
    Write-Host "External Access Policy: $($ExternalAccessPolicy.Count)"
    $ExternalAccessPolicy | Export-Csv -Path "$outputDirectory\ExternalAccessPolicy-$($tenantName).csv" -NoTypeInformation

    # Get Online Application Instance
    $OnlineApplicationInstance = Get-CsOnlineApplicationInstance
    Write-Host "Online Application Instance: $($OnlineApplicationInstance.Count)"
    $OnlineApplicationInstance | Export-Csv -Path "$outputDirectory\OnlineApplicationInstance-$($tenantName).csv" -NoTypeInformation

    # Get Group Policy Assignment
    $GroupPolicyAssignment = Get-CsGroupPolicyAssignment
    $GroupPolicyAssignmentArray = @()
    foreach ($line in $GroupPolicyAssignment) {
        $GroupPolicyAssignmentArray += [PSCustomObject]@{
            Priority = $line.Priority
            PolicyName = $line.PolicyName
            CreatedBy = (Get-AzureADUser -ObjectId $line.CreatedBy).DisplayName
            CreatedDateTime = $line.CreatedTime 
            GroupId = (Get-AzureADGroup -ObjectId $line.GroupId).DisplayName
            PolicyType = $line.PolicyType
        }
    Write-Host "Group Policy Assignment: $($GroupPolicyAssignment.Count)"
    $GroupPolicyAssignmentArray | Export-Csv -Path "$outputDirectory\GroupPolicyAssignment-$($tenantName).csv" -NoTypeInformation

    # Get Phone Number Assignment
    $PhoneNumberAssignment = Get-CsPhoneNumberAssignment
    $PhoneNumberAssignmentArray = @()
    foreach ($line in $PhoneNumberAssignment) {
        $PhoneNumberAssignmentArray += [PSCustomObject]@{
            ActivationState = $line.ActivationState
            AssignedPstnTargetId = (Get-CsOnlineUser -Identity $line.AssignedPstnTargetId).UserPrincipalName
            AssignmentCategory = $line.AssignmentCategory
            City = $line.City
            State = $line.isoSubdivision
            Type = $line.NumberType
            TelephoneNumber = $line.TelephoneNumber
            Assignment = $line.Capability -join "`n"
        }
    }
    Write-Host "Phone Number Assignment: $($PhoneNumberAssignmentArray.Count)"
    $PhoneNumberAssignmentArray | Export-Csv -Path "$outputDirectory\PhoneNumberAssignment-$($tenantName).csv" -NoTypeInformation


    # Get Online List Location
    $OnlineListLocation = Get-CsOnlineLisLocation
    Write-Host "Online List Location: $($OnlineListLocation.Count)"
    $OnlineListLocation | Export-Csv -Path "$outputDirectory\OnlineLisLocation-$($tenantName).csv" -NoTypeInformation

    # Get Online Lis Subnet
    $OnlineLisSubnet = Get-CsOnlineLisSubnet
    Write-Host "Online Lis Subnet: $($OnlineLisSubnet.Count)"
    $OnlineLisSubnet | Export-Csv -Path "$outputDirectory\OnlineLisSubnet-$($tenantName).csv" -NoTypeInformation


    # Get Trusted IP
    $TrustedIP = Get-CsTenantTrustedIPAddress
    Write-Host "Trusted IP: $($TrustedIP.Count)"
    $TrustedIP | Export-Csv -Path "$outputDirectory\TrustedIP-$($tenantName).csv" -NoTypeInformation

    # Combine all the CSV files into one Excel file
    Write-Host "Combining all CSV files into one Excel file"
    $excelFile = "$outputDirectory\TeamsVoiceAssessment-$($tenantName).xlsx"
    $csvFiles = Get-ChildItem -Path "$outputDirectory\*.csv"
    $csvFiles | ForEach-Object {
        $csvFile = $_.FullName
        $sheetName = $_.BaseName
        
        # Remove -$($TenantName) from the sheet name
        $sheetName = $sheetName -replace "-$($tenantName)", ""
        $sheetName = $sheetName -replace "_", " "

        # Import the CSV file into Excel
        $csvImport = Import-Csv -Path $csvFile
        $csvImport | Export-Excel -Path $excelFile -WorksheetName $sheetName -TableName $sheetName -AutoSize -AutoFilter -FreezeTopRow

        # Remove the CSV file
        Remove-Item -Path $csvFile
    }
    Write-Host "Excel file created: $excelFile"
    Invoke-Item -Path $excelFile
    Pause
    
    # Ask if they want to disconnect from Teams
    $disconnect = Read-Host "Do you want to disconnect from your Microsoft Connections? (Y/N)"
    if ($disconnect -eq "Y") {
        Write-Host "Disconnecting from Teams"
        Disconnect-MicrosoftTeams
        Disconnect-AzureAD
    }
}