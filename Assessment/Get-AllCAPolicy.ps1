# Create a csv of all Conditional Access Policies in Azure AD



function Get-AllCAPolicy {
    # Get a list of all Conditional Access Policies
    $caPolicies = Get-AzureADMSConditionalAccessPolicy

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
            "Grant Operator" = $caPolicy.GrantControls._Operator
            "Session Controls" = ($caPolicy.SessionControls | ConvertTo-Json -Compress)
        }
        $caPolicyResults += $caPolicyResult
    }

    # Replace the guid values with the actual names
    $caPolicyResults = $caPolicyResults | ForEach-Object {
        $_.PSObject.Properties | ForEach-Object {
            if ($_.Value) {
                $guids = $_.Value -split "`n"
                $names = $guids | Where-Object { $_ -match "^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$" } | ForEach-Object {
                    (Get-AzureADObjectByObjectId -ObjectIds $_).DisplayName
                }
                if ($names) {
                    $_.Value = $names -join "`n"
                }
            }
        }
        $_
    }
    # Get the Tenant Name and sanitize it for file path
    $tenantName = (Get-AzureADTenantDetail).DisplayName
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
# Connect to Azure AD
# Connect to Azure AD
Connect-AzureAD

# Get all Conditional Access Policies
Get-AllCAPolicy



