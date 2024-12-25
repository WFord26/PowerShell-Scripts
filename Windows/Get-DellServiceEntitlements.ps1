<#
.SYNOPSIS
    Retrieves Dell warranty and service entitlement information for Dell computers using Dell's API.

.DESCRIPTION
    This script provides functionality to retrieve warranty and service entitlement information for Dell computers
    using Dell's API. It handles authentication token management and can process either local system information
    or a list of service tags from a CSV file.

.PARAMETER csv
    Switch parameter to indicate if processing multiple service tags from a CSV file.

.PARAMETER csvPath
    Path to the CSV file containing service tags. Required when csv parameter is true.
    CSV should have a column named "ServiceTag".

.FUNCTIONS
    Get-DellToken
        Authenticates with Dell API and retrieves an access token.
    
    Save-Credential
        Saves API credentials securely to the user's profile.
    
    Get-SavedCredential
        Retrieves saved API credentials.
    
    Check-DellToken
        Validates existing token or creates new one if needed.
    
    Get-DellWarranty
        Retrieves warranty information for a specific service tag.
    
    Get-SerialNumber
        Main function that orchestrates the warranty lookup process.

.EXAMPLE
    # Check warranty for local Dell computer
    Get-SerialNumber

.EXAMPLE
    # Check warranty for multiple service tags from CSV
    Get-SerialNumber -csv $true -csvPath "C:\ServiceTags.csv"

    Get-SerialNumber -csv $false 

.NOTES
    File Name      : Get-DellServiceEntitlements.ps1
    Author        : William Ford (wford@managedsolution.com)
    Created        : 12-13-2024
    Prerequisite   : Dell API Key and Client Secret
    Required Files : None
    Output        : Warranty information in JSON format

.LINK
    Dell API Documentation: https://developer.dell.com/

.REQUIREMENTS
    - PowerShell 5.1 or higher
    - Dell API credentials
    - Internet connectivity to access Dell API
#>

function Get-DellToken {
    param (
        [string]$apiKey,
        [string]$clientSecret
    )
    $tokenUrl = "https://apigtwb2c.us.dell.com/auth/oauth/v2/token"  # Replace with your token endpoint
    $authBody = @{
        "grant_type" = "client_credentials"
        "client_id" = $apiKey
        "client_secret" = $clientSecret
    }
    $getTime = Get-Date
    $authResponse = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $authBody -ContentType "application/x-www-form-urlencoded"
    # Check if authresponse is errored
    if ($null -ne $authResponse.error) {
        Write-Host "Error occurred: $($authResponse.error)"
        Exit
    }
    $getExpires = $getTime.AddSeconds($authResponse.expires_in)
    $Global:dellAuthToken = @{
        "token" = $authResponse.access_token
        "expires" = $getExpires
    }
    # Check for error in response
    if ($null -ne $authResponse.error) {
        Write-Host "Error occurred: $($authResponse.error)"
        Exit
    } else {
        Write-Host "Token created successfully"
    }
}

function Save-Credential {
    param (
        [string]$target,
        [string]$username,
        [SecureString]$password
    )

    # Create directory if it does not exist
    if (-Not (Test-Path "$env:USERPROFILE\.dell")) {
        New-Item -ItemType Directory -Path "$env:USERPROFILE\.dell"
    }
    # Save the credential to a file
    $credential = New-Object -TypeName PSCredential -ArgumentList $username, $password
    $credential | Export-Clixml -Path "$env:USERPROFILE\.dell\$target.xml"
}

function Get-SavedCredential {
    param (
        [string]$target
    )
    $credential = Import-Clixml -Path "$env:USERPROFILE\.dell\$target.xml"
    return $credential
}

function Check-DellToken {
    $credentialFile = "$env:USERPROFILE\.dell\apiCredential.xml"
    
    if (-Not (Test-Path $credentialFile)) {
        Write-Host "Credential file not found. Please enter your API Key and Secret."
        $userClientId = Read-Host "Enter API Key"
        $userClientSecret = Read-Host "Enter Client Secret" -AsSecureString
        Save-Credential -target "apiCredential" -username $userClientId -password $userClientSecret
    } else {
        $credential = Get-SavedCredential -target "apiCredential"
        $userClientId = $credential.UserName
        # Convert the secure string to plain text
        # $clientSecret = $credential.GetNetworkCredential().Password
        $userClientSecret = $credential.Password       
    }
    $plainClientSecret = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($userClientSecret))

    if ($global:dellAuthToken -eq $null) {
        Write-Host "Token does not exist, creating new Auth Token"
        Get-DellToken -apiKey $userClientId -clientSecret $plainClientSecret
    } else {
        if ($global:dellAuthToken.expires -lt (Get-Date)) {
            Write-Host "Token has expired, creating new Auth Token"
            Get-DellToken -apiKey $userClientId -clientSecret $plainClientSecret
        } else {
            Write-Host "Token is still valid until: $($global:dellAuthToken.expires)"
        }
    }
}

function Get-DellWarranty {
    [CmdletBinding()]
    param (
        [string]$serviceTag
    )
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Bearer "+ $($global:dellAuthToken.token))
    $warrantyUrl = "https://apigtwb2c.us.dell.com/PROD/sbil/eapi/v5/asset-entitlements?servicetags="+$serviceTag
    $warrantyResponse = Invoke-RestMethod -Uri $warrantyUrl -Method Get -Headers $headers
    $Script:warranty = $warrantyResponse 
}
function Get-SerialNumber{
    [CmdletBinding()]
    param (
        [bool]$csv,
        [string]$csvPath,
        [string]$serviceTag
    )
    # Check if Token exists if it does not or has expired, create a new one
    Check-DellToken
    if ($csv -eq $true) {
        if (-not (Test-Path $csvPath)) {
            Write-Host "CSV file not found at path: $csvPath"
            Exit
        }

        $csvContent = Import-Csv -Path $csvPath
        foreach ($row in $csvContent) {
            $serviceTag = $row.ServiceTag
            Get-DellWarranty -serviceTag $serviceTag
            $warranty | Out-File -FilePath "$($csvPath).json" -Append
        }
    } else {
        # Check if Dell Computer
        if ($null -ne $serviceTag) {
            Get-DellWarranty -serviceTag $serviceTag
            $warranty
        } else {
            if (-not ((Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty Manufacturer) -eq "Dell Inc.")) {
                Write-Host "This script is only for Dell computers"
                Exit
            }
            $serialNumber = Get-WmiObject Win32_BIOS | Select-Object -ExpandProperty SerialNumber
            Get-DellWarranty -serviceTag $serialNumber
            $warranty
        }
    }
}