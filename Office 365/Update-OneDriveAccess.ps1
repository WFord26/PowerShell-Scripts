function Update-OneDriveAccess {
    <#
    .SYNOPSIS
    This function updates the access state of a user's OneDrive for Business site.
    .DESCRIPTION
    This function allows you to set the access state of a user's OneDrive for Business site to either "Unlock", "ReadOnly", or "NoAccess".
    It requires the user's email address and the desired state as parameters. The function also checks if the MSOnline module is installed and connects to the service if necessary.
    .PARAMETER UserEmail
    The email address of the user whose OneDrive access state you want to update.
    .PARAMETER State
    The desired access state for the user's OneDrive. Valid values are "Unlock", "ReadOnly", or "NoAccess".
    .PARAMETER SharePointUrl
    The SharePoint URL for the tenant. If not provided, the function will attempt to determine the default tenant domain.
    .EXAMPLE
    Update-OneDriveAccess -UserEmail "Jon.Doe@contoso.com" -State "Unlock" -SharePointUrl "https://contoso-my.sharepoint.com"
    This example sets the OneDrive access state for the user Jon Doe to "Unlock" using the specified SharePoint URL.
    .EXAMPLE
    Update-OneDriveAccess -UserEmail ""
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserEmail,
        [Parameter(Mandatory = $true)]
        [ValidateState("Unlock", "ReadOnly","NoAccess")]
        [string]$State,
        [Parameter(Mandatory = $false, HelpMessage = "SharePoint URL: https://<tenant>-my.sharepoint.com")]
        [string]$SharePointUrl
    )
    # Check if TenantDomain is provided, if not, use the default tenant domain
    if (-not $SharePointAdminUrl) {
        try {
            # Check if MSOL module is installed
            if (-not (Get-Module -ListAvailable -Name MSOnline)) {
                Write-Host "MSOnline module is not installed. Please install it first."
                return
            }
            # Import the MSOnline module
            Import-Module MSOnline -ErrorAction Stop
            # Connect to MSOnline service
            Connect-MSOlService
        } catch {
            Write-Host "Failed to connect to MSOnline service. Please check your credentials and network connection."
            Write-Host "Try running this command with the -SharePointUrl parameter to specify the SharePoint URL."
            return
        }
        # Get the tenant domain
        $tenant = (Get-MsolDomain | Where-Object {$_.IsDefault -eq $true}).Name
        $tenant = $tenant.Replace(".com", "").Replace(".co.uk", "").Replace(".net", "").Replace(".org", "").Replace(".edu", "").Replace(".gov", "")
        $OneDriveUrl = "https://$tenant-my.sharepoint.com/personal/"
    } else {
        # Check if $SharePointUrl is passed with /personal or /personal/
        if ($SharePointUrl -match "/personal/") {
            $OneDriveUrl = $SharePointUrl
        } elseif ($SharePointUrl -match "/personal") {
            $OneDriveUrl = $SharePointUrl + "/"
        } else {
            $OneDriveUrl = $SharePointUrl + "/personal/"
        }
    }
    # Set user one drive URL
    $UserOneDriveUrl = $OneDriveUrl + $UserEmail.Replace("@", "_").Replace(".", "_") 
    try {
        # Set SPOSite Access
        Get-SPOSite -Identity $UserOneDriveUrl -ErrorAction Stop | Set-SPOSite -LockState $State -ErrorAction Stop
        Write-Host "Set OneDrive access for $UserEmail to $State."
    } catch {
        Write-Host "Failed to set OneDrive access for $UserEmail. Please check the URL and try again."
        Write-Host $_.Exception.Message
        Write-Host "If the error is related to the URL, please check if the URL is correct and if the user has a OneDrive account."
    }     
}