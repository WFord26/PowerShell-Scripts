function Get-MgAllCAPolicy {
    # Ensure Microsoft Graph connection
    try {
        $context = Get-MgContext
        if (-not $context) {
            Connect-MgGraph -Scopes "Policy.Read.All", "Directory.Read.All"
        }
    }
    catch {
        Write-Error "Failed to connect to Microsoft Graph. Error: $_"
        return
    }

    # Get a list of all Conditional Access Policies
    $caPolicies = Get-MgIdentityConditionalAccessPolicy
 
    # Create a new array to store the results
    $caPolicyResults = @()
 
    # Loop through each Conditional Access Policy
    foreach ($caPolicy in $caPolicies) {
        $caPolicyResult = [PSCustomObject]@{
            "DisplayName" = $caPolicy.DisplayName
            "State" = $caPolicy.State
            "Include Applications" = ($caPolicy.Conditions.Applications.IncludeApplications -join "`n")
            "Exclude Applications" = ($caPolicy.Conditions.Applications.ExcludeApplications -join "`n")
            "Included Users" = ($caPolicy.Conditions.Users.IncludeUsers -join "`n")
            "Excluded Users" = ($caPolicy.Conditions.Users.ExcludeUsers -join "`n")
            "Included Groups" = ($caPolicy.Conditions.Users.IncludeGroups -join "`n")
            "Excluded Groups" = ($caPolicy.Conditions.Users.ExcludeGroups -join "`n")
            "Included Roles" = ($caPolicy.Conditions.Users.IncludeRoles -join "`n")
            "Excluded Roles" = ($caPolicy.Conditions.Users.ExcludeRoles -join "`n")
            "Included Platforms" = ($caPolicy.Conditions.Platforms.IncludePlatforms -join "`n")
            "Excluded Platforms" = ($caPolicy.Conditions.Platforms.ExcludePlatforms -join "`n")
            "Included Locations" = ($caPolicy.Conditions.Locations.IncludeLocations -join "`n")
            "Excluded Locations" = ($caPolicy.Conditions.Locations.ExcludeLocations -join "`n")
            "Grant Controls" = ($caPolicy.GrantControls.BuiltInControls -join "`n")
            "Grant Options" = ($caPolicy.GrantControls.CustomAuthenticationFactors -join "`n")
            "Grant Operator" = $caPolicy.GrantControls.Operator
            "Session Controls" = ($caPolicy.SessionControls | ConvertTo-Json -Compress)
        }
        $caPolicyResults += $caPolicyResult
    }
 
    # Replace the guid values with actual names
    $caPolicyResults = $caPolicyResults | ForEach-Object {
        $_.PSObject.Properties | ForEach-Object {
            if ($_.Value) {
                $guids = $_.Value -split "`n"
                $names = $guids | Where-Object { $_ -match "^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$" } | ForEach-Object {
                    try {
                        $user = Get-MgUser -UserId $_ -ErrorAction SilentlyContinue
                        if ($user) { $user.DisplayName }
                        else {
                            $group = Get-MgGroup -GroupId $_ -ErrorAction SilentlyContinue
                            if ($group) { $group.DisplayName }
                        }
                    }
                    catch { $_ }
                }
                if ($names) {
                    $_.Value = $names -join "`n"
                }
            }
        }
        $_
    }

    # Get the Tenant Name and sanitize it for file path
    $tenantName = (Get-MgOrganization).DisplayName
    $safeTenantName = $tenantName -replace '[\\/:*?"<>|]', '_'
 
    # Get Date and Time
    $now = Get-Date -Format "yyyy-MM-dd-HH-mm"
 
    # Check if the folder exists
    $folder = "C:\temp\$safeTenantName\"
    if (-not (Test-Path $folder)) {
        New-Item -Path $folder -ItemType Directory
    }
 
    # Build the file path
    $filePath = "C:\temp\$safeTenantName\ConditionalAccessPolicies-$now.csv"
 
    # Export the results to a CSV file
    $caPolicyResults | Export-Csv -Path $filePath -NoTypeInformation
}