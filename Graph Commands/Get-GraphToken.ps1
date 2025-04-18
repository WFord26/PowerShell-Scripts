function Get-GraphToken {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$TenantId,
        [Parameter(Mandatory = $false)]
        [string]$ClientId = "14d82eec-204b-4c2f-b7e8-296a70dab67e", # Microsoft Graph PowerShell client ID
        [Parameter(Mandatory = $false)]
        [string]$ClientSecret,
        [Parameter(Mandatory = $false)]
        [array]$Scope = @("https://graph.microsoft.com/.default")

    )

    # Import the Microsoft Authentication Library (MSAL) module if not already installed
    $module = Get-Module -Name MSAL.PS -ListAvailable
    if (-not $module) {
        Install-Module -Name MSAL.PS -Force
    } else {
        Write-Host "MSAL.PS module is already installed."
    }

    if ($ClientSecret) {
        $authParams = @{
            ClientId     = $ClientId
            TenantId     = $TenantId
            ClientSecret = $ClientSecret
            Scopes       = $Scope
        }
    } else {
        $authParams = @{
            ClientId = $ClientId
            TenantId = $TenantId
            Interactive = $true
            Scopes = $Scope
        }
    }
    
    # Get the access token
    $authResult = Get-MsalToken @authParams
    if ($authResult) {
        Write-Host "Access token retrieved successfully."
        # Format the token for use with the Graph API
        $accessToken = $authResult.AccessToken
    } else {
        Write-Host "Failed to retrieve access token." -ForegroundColor Red
    }
    return $accessToken
}