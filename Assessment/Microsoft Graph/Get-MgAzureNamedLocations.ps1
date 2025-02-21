# Connect to MgGraph with correct scopes
Connect-MgGraph -Scopes "Directory.Read.All", "Directory.ReadWrite.All", "Policy.Read.All"

function Get-MgAzureNamedLocations {
    # Get all named locations
    $namedLocations = Get-MgIdentityConditionalAccessNamedLocation | ForEach-Object {
        $location = $_
        
        # Convert the location details based on type
        $locationDetails = if ($location.AdditionalProperties.isTrusted) {
            @{
                Type = "IP ranges"
                IpRanges = $location.AdditionalProperties.ipRanges.cidrAddress -join "; "
                IsTrusted = $location.AdditionalProperties.isTrusted
            }
        } else {
            @{
                Type = "Countries/Regions"
                CountriesAndRegions = $location.AdditionalProperties.countriesAndRegions -join "; "
                IncludeUnknownCountriesAndRegions = $location.AdditionalProperties.includeUnknownCountriesAndRegions
            }
        }

        [PSCustomObject]@{
            DisplayName = $location.DisplayName
            CreatedDateTime = $location.CreatedDateTime
            ModifiedDateTime = $location.ModifiedDateTime
            Type = $locationDetails.Type
            Details = if ($locationDetails.Type -eq "IP ranges") {
                $locationDetails.IpRanges
            } else {
                $locationDetails.CountriesAndRegions
            }
            IsTrusted = $locationDetails.IsTrusted
            IncludeUnknownCountriesAndRegions = $locationDetails.IncludeUnknownCountriesAndRegions
        }
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
    $filePath = "C:\temp\$safeTenantName\NamedLocations-$now.csv"
    
    # Export the results to a CSV file
    $namedLocations | Export-Csv -Path $filePath -NoTypeInformation
}