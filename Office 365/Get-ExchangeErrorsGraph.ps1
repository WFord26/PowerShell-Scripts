<#
.SYNOPSIS
    Identifies and reports Exchange service provisioning errors for users in a Microsoft 365 tenant using Microsoft Graph API.

.DESCRIPTION
    This script provides functions to authenticate to Microsoft Graph API and retrieve users who have Exchange service provisioning errors.
    It supports both interactive authentication and client credentials flow (app+secret).
    
    The script consists of three main functions:
    - Get-GraphHeaders: Creates proper headers for Graph API requests
    - Get-GraphToken: Obtains authentication token using MSAL.PS module
    - Get-ExchangeErrorsGraph: Main function that retrieves users with Exchange provisioning errors

.PARAMETER TenantId
    The Azure AD tenant ID where the users are located.

.PARAMETER ClientId
    Optional. The client/application ID to use for authentication. Defaults to the Microsoft Graph PowerShell client ID.

.PARAMETER ClientSecret
    Optional. The client secret for app-only authentication. If not provided, interactive authentication is used.

.PARAMETER export
    Optional switch. When specified, results are exported to C:\temp\ExchangeErrors.json.

.EXAMPLE
    Get-ExchangeErrorsGraph -TenantId "contoso.onmicrosoft.com"
    
    Authenticates interactively and displays users with Exchange provisioning errors.

.EXAMPLE
    Get-ExchangeErrorsGraph -TenantId "contoso.onmicrosoft.com" -ClientId "1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p" -ClientSecret "YourSecretHere" -export
    
    Authenticates with app credentials and exports results to C:\temp\ExchangeErrors.json.

.NOTES
    Author: William Ford
    Required Modules: MSAL.PS, Microsoft.Graph
    The script automatically installs required modules if they are not present.
    This script uses the beta endpoint of Microsoft Graph API which may change without notice.

.LINK
    https://docs.microsoft.com/en-us/graph/api/resources/serviceprovisioningerror
#>

Function Get-GraphHeaders {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$accessToken
    )
    # Define the authorization header
    $headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type"  = "application/json"
    }
    # Return the headers
    return $headers
}
function Get-GraphToken {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$TenantId,

        [Parameter(Mandatory = $false)]
        [string]$ClientId = "14d82eec-204b-4c2f-b7e8-296a70dab67e", # Microsoft Graph PowerShell client ID

        [Parameter(Mandatory = $false)]
        [string]$ClientSecret
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
            Scopes       = "https://graph.microsoft.com/.default"
        }
    } else {
        $authParams = @{
            ClientId = $ClientId
            TenantId = $TenantId
            Interactive = $true
            Scopes = "https://graph.microsoft.com/.default"
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
Function Get-ExchangeErrorsGraph {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$TenantId,
        [Parameter(Mandatory = $false)]
        [string]$ClientId,
        [Parameter(Mandatory = $false)]
        [string]$ClientSecret,
        [Parameter(Mandatory = $false)]
        [switch]$export
    )
    # Import the required module
    if ($null -eq (Get-Module -Name Microsoft.Graph -ErrorAction SilentlyContinue)) {
        Write-Host "Microsoft.Graph module not found. Installing..." -ForegroundColor Yellow
        Install-Module Microsoft.Graph -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
    } else {
        Write-Host "Microsoft.Graph module found." -ForegroundColor Green
    }

    try {
        if ($ClientSecret) {
            $MgToken = Get-GraphToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
        } else {
            # Get Graph Token
            $MgToken = Get-GraphToken -TenantId $TenantId 
        }
    } catch {
        Write-Host "Error getting Graph Token: $_" -ForegroundColor Red
        return
    }
    
    # Get Headers for Graph API
    try {
        $headers = Get-GraphHeaders -AccessToken $MgToken.AccessToken
    } catch {
        Write-Host "Error getting Graph Headers: $_" -ForegroundColor Red
        return
    }

    try {
        # Define the request URI
        $requestUri = "https://graph.microsoft.com/beta/users?$select=id,userPrincipalName,serviceProvisioningErrors"

        $response = Invoke-WebRequest -Uri $requestUri -Headers $headers -Method Get
        # Parse the response
        $result = $response.Content | ConvertFrom-Json
        $allUsers=@()
        if (!($result.'@odata.nextLink')){
            $allUsers += $result.value | Where-Object {$_.serviceProvisioningErrors -notlike $null}
        } else {
            do {
                write-host "Loading Page" -ForegroundColor Green
                $response = Invoke-WebRequest -Uri $result.'@odata.nextLink' -Headers $headers -Method Get
                $result = $response.Content | ConvertFrom-Json
                $allUsers += $result.value | Where-Object {$_.serviceProvisioningErrors -notlike $null}
            
                # Update the request URI to the next link, if it exists
                $uri = $result.'@odata.nextLink'
                Write-host "Getting to the next page.. Please"  -ForegroundColor Green
            } while ($null -ne $uri)
        }
    } catch {
        Write-Host "Error making API request: $_" -ForegroundColor Red
        return
    }

    if ($allUsers) {
        Write-Host "Found $($allUsers.Count) users with provisioning errors." -ForegroundColor Green
        # Check if any errors were found
        # Format the errors in a more readable way
        $formattedUsers = $allUsers | Select-Object -Property UserPrincipalName, 
            @{
            Name = "Errors"; 
            Expression = {
                $errorDetails = ([xml]$_.serviceProvisioningErrors.errorDetail).ServiceInstance.ObjectErrors.ErrorRecord.ErrorDescription
                if ($errorDetails -is [array]) {
                $errorDetails -join "`n"
                } else {
                $errorDetails
                }
            }
            }
        
        # Display the formatted results
        $formattedUsers | Format-Table -AutoSize -Wrap
        if ($export) {
            # Check if Path Exists
            if (!(Test-Path -Path "C:\temp")) {
                New-Item -Path "C:\" -Name "temp" -ItemType Directory -Force
            }
            # Check if File Exists
            if (Test-Path -Path "C:\temp\ExchangeErrors.json") {
                Remove-Item -Path "C:\temp\ExchangeErrors.json" -Force
            }
            Write-Host "Exporting results to C:\temp\ExchangeErrors.json" -ForegroundColor Green
            # Export to JSON
            $allUsers | Select-Object userPrincipalName, @{n="Errors";e={([xml]$_.serviceProvisioningErrors.errorDetail).ServiceInstance.ObjectErrors.ErrorRecord.ErrorDescription } } | ConvertTo-Json -Depth 10 | Out-File -FilePath "C:\temp\ExchangeErrors.json" -Force
        }
    } else {
        Write-Host "No users found with provisioning errors." -ForegroundColor Yellow
        if ($export) {
            Write-Host "Nothing to Export" -ForegroundColor Yellow
        }
    }
}