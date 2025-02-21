<#
.SYNOPSIS
    A script to automate the process of updating ConnectWise Manage configurations with Dell Service Entitlements.

.DESCRIPTION
    This script provides functionality to update ConnectWise Manage device configurations with Dell warranty and service information.
    It includes functions for:
    - Authenticating with Dell's API
    - Managing secure credentials
    - Retrieving Dell warranty information
    - Updating ConnectWise Manage configurations with Dell service entitlements
    - Processing both single and multiple device updates

.PARAMETER cwServer
    The URL of your ConnectWise Manage server.

.PARAMETER cwCompany
    Your ConnectWise Manage company name.

.EXAMPLE
    cwm-Automagically -cwServer "manage.company.com" -cwCompany "MyCompany"

.NOTES
    File Name      : cwm-Automagically.ps1
    Author         : William Ford
    Date           : 12/14/2024
    Prerequisite   : PowerShell 5.1 or later
                    ConnectWiseManageAPI module
                    Dell API credentials
                    ConnectWise Manage API credentials

.FUNCTIONALITY
    - Secure storage of API credentials
    - Dell warranty information retrieval
    - ConnectWise Manage configuration updates
    - Batch processing via CSV
    - Automated service tag and serial number management
    - Vendor notes updating
    - Purchase date and warranty expiration date synchronization
    - Manufacturer information updates

.LINK
    https://developer.connectwise.com/
    https://developer.dell.com/

.INPUTS
    Can accept single device names or CSV files containing multiple device configurations.

.OUTPUTS
    Updates ConnectWise Manage configurations with Dell warranty and service information.
#>

function Get-DellToken {
    param (
        [string]$apiKey,
        [string]$clientSecret
    )
    try {
        Write-Host "Obtaining Dell token" -ForegroundColor Yellow
        $tokenUrl = "https://apigtwb2c.us.dell.com/auth/oauth/v2/token"  # Replace with your token endpoint
        $authBody = @{
            "grant_type" = "client_credentials"
            "client_id" = $apiKey
            "client_secret" = $clientSecret
        }
        $getTime = Get-Date
        $authResponse = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $authBody -ContentType "application/x-www-form-urlencoded"
        $getExpires = $getTime.AddSeconds($authResponse.expires_in)
        $dellAuthToken = @{
            "token" = $authResponse.access_token
            "expires" = $getExpires
        }
        $dellAuthToken | Export-Clixml -Path "$env:USERPROFILE\.dell\dellAuthToken.xml"
        Write-Host "Token created successfully" -ForegroundColor Green
    } catch {
        Write-Host "Error obtaining Dell token: $_" -ForegroundColor Red
        exit
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

function Test-DellToken {
    $credentialFile = "$env:USERPROFILE\.dell\apiCredential.xml"
    
    if (-Not (Test-Path $credentialFile)) {
        Write-Host "Credential file not found. Please enter your API Key and Secret."
        $userClientId = Read-Host "Enter API Key"
        $userClientSecret = Read-Host "Enter Client Secret" -AsSecureString
        Save-Credential -target "apiCredential" -username $userClientId -password $userClientSecret
    } else {
        $credential = Get-SavedCredential -target "apiCredential"
        $userClientId = $credential.UserName
        $userClientSecret = $credential.Password       
    }
    $dellAuthTokenFile = "$env:USERPROFILE\.dell\dellAuthToken.xml"
    if (-Not (Test-Path $dellAuthTokenFile)) {
        Write-Host "Token does not exist, creating new Auth Token" -ForegroundColor Orange
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($userClientSecret)
        $plainClientSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        Get-DellToken -apiKey $userClientId -clientSecret $plainClientSecret
        } else {
            $dellAuthTokenImport = Import-Clixml -Path $dellAuthTokenFile
            if ($dellAuthTokenImport.expires -lt (Get-Date)) {
                Write-Host "Token has expired, creating new Auth Token"
                $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($userClientSecret) 
                $plainClientSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
                Get-DellToken -apiKey $userClientId -clientSecret $plainClientSecret
            } else {
                Write-Host "Token is still valid until: $($dellAuthTokenImport.expires)"
            }
        }
}

function Get-DellWarranty {
    [CmdletBinding()]
    param (
        [string]$serviceTag
    )
    $dellAuthToken = Import-Clixml -Path "$env:USERPROFILE\.dell\dellAuthToken.xml"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Bearer "+ $($dellAuthToken.token))
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
    Test-DellToken
    if ($csv -eq $true) {
        if (-not (Test-Path $csvPath)) {
            Write-Host "CSV file not found at path: $csvPath"
            Exit
        }

        $script:csvContent = Import-Csv -Path $csvPath
        foreach ($row in $script:csvContent) {
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
function Show-CWMBanner {
    Write-Host @"

░█████╗░░█████╗░███╗░░██╗███╗░░██╗███████╗░█████╗░████████╗░██╗░░░░░░░██╗██╗░██████╗███████╗
██╔══██╗██╔══██╗████╗░██║████╗░██║██╔════╝██╔══██╗╚══██╔══╝░██║░░██╗░░██║██║██╔════╝██╔════╝
██║░░╚═╝██║░░██║██╔██╗██║██╔██╗██║█████╗░░██║░░╚═╝░░░██║░░░░╚██╗████╗██╔╝██║╚█████╗░█████╗░░
██║░░██╗██║░░██║██║╚████║██║╚████║██╔══╝░░██║░░██╗░░░██║░░░░░████╔═████║░██║░╚═══██╗██╔══╝░░
╚█████╔╝╚█████╔╝██║░╚███║██║░╚███║███████╗╚█████╔╝░░░██║░░░░░╚██╔╝░╚██╔╝░██║██████╔╝███████╗
░╚════╝░░╚════╝░╚═╝░░╚══╝╚═╝░░╚══╝╚══════╝░╚════╝░░░░╚═╝░░░░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░╚══════╝

░█████╗░██╗░░░██╗████████╗░█████╗░███╗░░░███╗░█████╗░░██████╗░██╗░█████╗░░█████╗░██╗░░░░░██╗░░░░░██╗░░░██╗
██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗████╗░████║██╔══██╗██╔════╝░██║██╔══██╗██╔══██╗██║░░░░░██║░░░░░╚██╗░██╔╝
███████║██║░░░██║░░░██║░░░██║░░██║██╔████╔██║███████║██║░░██╗░██║██║░░╚═╝███████║██║░░░░░██║░░░░░░╚████╔╝░
██╔══██║██║░░░██║░░░██║░░░██║░░██║██║╚██╔╝██║██╔══██║██║░░╚██╗██║██║░░██╗██╔══██║██║░░░░░██║░░░░░░░╚██╔╝░░
██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝██║░╚═╝░██║██║░░██║╚██████╔╝██║╚█████╔╝██║░░██║███████╗███████╗░░░██║░░░
╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░╚═╝░░░░░╚═╝╚═╝░░╚═╝░╚═════╝░╚═╝░╚════╝░╚═╝░░╚═╝╚══════╝╚══════╝░░░╚═╝░░░
                           
Powered by Managed Solution
"@
}
function Start-CWMQuickStart {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$cwServer,
        [Parameter(Mandatory = $true)]
        [string]$cwCompany
    )
    # Store credentials in a secure file
    $credPath = $env:USERPROFILE+"\.cwm"
    $credXml = $credPath + "\cwApiCredentials.xml"
    # Check if folder exists, if not create it
    if (!(Test-Path $credPath)) {
        New-Item -ItemType Directory -Path $credPath
    }

    # If credentials file doesn't exist, create it
    if (!(Test-Path $credXML)) {
        $credentials = @{
            pubkey = Read-Host -Prompt 'Enter your public key'
            privatekey = Read-Host -Prompt 'Enter your private key' -AsSecureString
            clientid = Read-Host -Prompt 'Enter your ClientID: Your ClientID found at https://developer.connectwise.com/ClientID'
        }
        Write-Host "Storing credentials in $credXml"
        $credentials | Export-Clixml -Path $credXml
    }

    # Read secure credentials
    $secureCredentials = Import-Clixml -Path $credXml
    $CWMConnectionInfo = @{
        # This is the URL to your manage server.
        Server = $cwServer
        # This is the company entered at login
        Company = $cwCompany
        # Import secured keys
        pubkey = $secureCredentials.pubkey
        privatekey = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureCredentials.privatekey))
        # Your ClientID found at https://developer.connectwise.com/ClientID
        clientid = $secureCredentials.clientid
    }
    # Install/Update/Load the module
    if(Get-InstalledModule 'ConnectWiseManageAPI' -ErrorAction SilentlyContinue){ 
        # Update the module
        Write-Host "Updating ConnectWiseManageAPI module"
        Update-Module 'ConnectWiseManageAPI' 
    } else { 
        # Install the module
        Write-Host "Installing ConnectWiseManageAPI module"
        Install-Module 'ConnectWiseManageAPI'
    }
    Import-Module 'ConnectWiseManageAPI'

    # Connect to your Manage server
    Write-Host "Connecting to $cwServer"
    Connect-CWM @CWMConnectionInfo -Force
}
function Update-CWMVendorNote {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [object]$cwmDevice,
        [Parameter(Mandatory = $true)]
        [object]$dellSupport
    )
    # Build Vendor note from dellEntitlements.entitlements array. Count the number of entitlements and loop through them to build the note.
    # Clear the vendorNote array
    $vendorNote = @()
    $entitlementsCount = $entitlements.Count
    for ($i = 0; $i -lt $entitlementsCount; $i++) {
        $vendorNote += "Entitlement #$($i + 1)`n" +
                    "Service Level: $($entitlements[$i].serviceLevelDescription)`n" + 
                    "Warranty Type: $($entitlements[$i].serviceLevelCode)`n" + 
                    "Start Date: $($entitlements[$i].startDate)`n" + 
                    "End Date: $($entitlements[$i].endDate)`n" +
                    "`n"
    }
    # Check if vendorNotes is null, if it is add the note, if not combine the existing note with the new note
    if ($null -eq $cwmDevice.vendorNotes) {
        Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation add -Path "vendorNotes" -Value ($vendorNote -join '') 
    } else {
        # Check if the vendorNote is the same as the existing note
        if ($cwmDevice.vendorNotes -eq $vendorNote) {
            Write-Host "Vendor note is the same as the existing note"
        } else {
            # Combine the existing note with the new note
            $vendorNote = $cwmDevice.vendorNotes + $vendorNote
            Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation replace -Path "vendorNotes" -Value ($vendorNote -join '')
        }
    }
}
function Update-CWMPurchaseDate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [object]$cwmDevice,
        [Parameter(Mandatory = $true)]
        [object]$dellSupport
    )
    # Get the warranty expiration date and ship date
    $purchaseDate = $dellSupport.entitlements[0].startDate
    # Count the number of characters after the period
    $numPurchasetotal = $purchaseDate.Length - $purchaseDate.IndexOf('.') - 2
    # Remove the milliseconds part using -replace
    if ($numPurchasetotal -eq 3) {
        $purchaseDate = $purchaseDate -replace '\.\d{3}Z', 'Z'
    } else {
        $purchaseDate = $purchaseDate -replace '\.\d{2}Z', 'Z'
    }
    # Check if purchaseDate is null, if it is add the purchase date, if not replace the purchase date
    if ($null -eq $cwmDevice.purchaseDate) {
        Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation add -Path "purchaseDate" -Value $purchaseDate
        # Error handling for 400 response
        if ($Error[0].Exception.Message -match "400") {
            Write-Host "Error updating purchase date for $($cwmDevice.name) with value: $purchaseDate" -ForegroundColor Red
        }
    } else {
        Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation replace -Path "purchaseDate" -Value $purchaseDate
        # Error handling for 400 response
        if ($Error[0].Exception.Message -match "400") {
            Write-Host "Error updating purchase date for $($cwmDevice.name) with value: $purchaseDate" -ForegroundColor Red
        }
    }
}
function Update-CWMWarrantyExpirationDate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [object]$cwmDevice,
        [Parameter(Mandatory = $true)]
        [object]$dellSupport
    )
    # Get the warranty expiration date.
    $warrantyExpirationDate = $dellSupport.entitlements[0].endDate
    # Get the number of characters after the period.
    $numWarrantyTotal = $warrantyExpirationDate.Length - $warrantyExpirationDate.IndexOf('.') - 2
    # Remove the milliseconds part using -replace
    # Use the $numWarrantyTotal to determine the number of characters to remove
    $warrantyExpirationDate = $warrantyExpirationDate -replace "\.\d{$($numWarrantyTotal)}Z", 'Z'

    # Check if warrantyExpirationDate is null, if it is add the warranty expiration date, if not replace the warranty expiration date
    if ($null -eq $cwmDevice.warrantyExpirationDate) {
        Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation add -Path "warrantyExpirationDate" -Value $warrantyExpirationDate -ErrorAction SilentlyContinue
        # If response is an error write the offending value to screen in red
        if ($Error[0].Exception.Message -match "400") {
            Write-Host "Error updating warranty expiration date for $($cwmDevice.name) with value: $warrantyExpirationDate" -ForegroundColor Red
        }
    } else {
        Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation replace -Path "warrantyExpirationDate" -Value $warrantyExpirationDate -ErrorAction SilentlyContinue
        # If response is an error write the offending value to screen in red
        if ($Error[0].Exception.Message -match "400") {
            Write-Host "Error updating warranty expiration date for $($cwmDevice.name) with value: $warrantyExpirationDate" -ForegroundColor Red
        }
    }
}
function Update-CWMManufacturer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [object]$cwmDevice,
        [Parameter(Mandatory = $true)]
        [object]$dellSupport
    )

    # Create the manufacturer object
    $manufacturerName = @{
        name=$dellSupport.productLobDescription
    }
    # Check if manufacturer is null, if it is add the manufacturer, if not replace the manufacturer
    if ($null -eq $cwmDevice.manufacturer) {
        Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation add -Path "manufacturer" -Value $manufacturerName
    } else {
        Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation replace -Path "manufacturer" -Value $manufacturerName
    }
}
function WantToTryAgain {
    Write-Host "Would you like to try again?"
    $choice = Read-Host "Enter yes or no"
    if ($choice -eq 'yes') {
        Update-CWMConfig
    } else {
        Write-Host "Exiting"
        Disconnect-CWM
        exit
    }
}
function Update-CWMConfig {
    Write-Host "What would you like to do today?"
    Start-Sleep -Seconds 1
    Write-Host "1. Update a single ConnectWise Manage configuration with Dell Service Entitlements"
    Write-Host "2. Update multiple ConnectWise Manage configurations with Dell Service Entitlements"
    Write-Host "3. Exit"
    $choice = Read-Host "Enter your choice"
    if ($choice -notmatch '^[1-3]$') {
        Write-Host "Invalid choice. Please enter 1, 2, or 3."
        Update-CWMConfig
        return
    }
    switch ($choice) {
        1 {
            Write-Host "You have chosen to update a single ConnectWise Manage configuration with Dell Service Entitlements"
            Start-Sleep -Seconds 1
            Write-Host "Please enter the name of the configuration you would like to update"
            $configName = Read-Host "Enter the name of the configuration"
            $cwmDevice = Get-CWMCompanyConfiguration -condition "type/name like 'Switch' or type/name like 'managed worksatation' and name = '$configName' and status/id = 1" -pageSize 1
            # Check if the configuration exists
            if ($null -eq $cwmDevice) {
                Write-Host "Configuration not found"
                WantToTryAgain
            } 
            # Check if $cwmDevice.tagNumber and $cwmDevice.serialNumber are null
            if ($null -eq $cwmDevice.tagNumber -and $null -eq $cwmDevice.serialNumber) {
                Write-Host "Tag number and serial number not found"
                WantToTryAgain
            }
            # Check what type of device it is
            if ($cwmDevice.type.name -eq 'Switch' -and $null -ne $cwmDevice.tagNumber) {
                Write-Host "Device type is a switch"
                $dellSupport = Get-SerialNumber -csv $false -serviceTag $cwmDevice.tagNumber
            } elseif ($cwmDevice.type.name -eq 'Managed Workstation' -and $null -ne $cwmDevice.serialNumber) {
                Write-Host "Device type is a managed workstation"
                $dellSupport = Get-SerialNumber -csv $false -serviceTag $cwmDevice.serialNumber
                $deviceID = $dellSupport.id
                if ($null -eq $cwmDevice.tagNumber) {  
                    Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation add -Path 'tagNumber' -Value $deviceID -Verbose
                } else {
                    Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation replace -Path 'tagNumber' -Value $deviceID -Verbose
                }
            } else {
                Write-Host "Device type not found"
                WantToTryAgain
            }
            Update-CWMVendorNote -cwmDevice $cwmDevice -dellSupport $dellSupport
            Update-CWMPurchaseDate -cwmDevice $cwmDevice -dellSupport $dellSupport
            Update-CWMWarrantyExpirationDate -cwmDevice $cwmDevice -dellSupport $dellSupport
            Update-CWMManufacturer -cwmDevice $cwmDevice -dellSupport $dellSupport
            Write-Host "Configuration updated successfully"
        }
        2 {
            Write-Host "You have chosen to update multiple ConnectWise Manage configurations with Dell Service Entitlements"
            Start-Sleep -Seconds 1
            Write-Host "Please enter the path to the CSV file containing the configurations you would like to update"
            $csvPath = Read-Host "Enter the path to the CSV file"
            if (-not (Test-Path $csvPath)) {
                Write-Host "CSV file not found at path: $csvPath"
                WantToTryAgain
            }
            $script:csvContent = Import-Csv -Path $csvPath
            # Check if CSV file has the correct headers
            if ($script:csvContent[0].PSObject.Properties.Name -notcontains 'Configuration Name') {
                Write-Host "CSV file does not contain the 'Configuration Name' header"
                WantToTryAgain
            }
            foreach ($row in $script:csvContent) {
                $configName = $row.'Configuration Name'
                $cwmDevice = Get-CWMCompanyConfiguration -condition "type/name like 'Switch' or type/name like 'managed worksatation' and name = '$configName' and status/id = 1"
                # Check if the configuration exists
                if ($null -eq $cwmDevice) {
                    Write-Host "Configuration not found: " + $configName
                }
                # Check if multiple configurations have the same name
                if ($cwmDevice.Count -gt 1) {
                    Write-Host "Multiple configurations found with the same name"
                    $cwmDeviceCount = $cwmDevice.Count
                    for ($i = 0; $i -lt $cwmDeviceCount; $i++) {
                        $cwmDeviceId = $cwmDevice[$i].id
                        $cwmMultipleDevice = Get-CWMCompanyConfiguration -id $cwmDeviceId
                        if ($null -eq $cwmMultipleDevice) {
                            Write-Host "Configuration not found ID: " + $cwmDeviceId
                        } 
                        # Check if $cwmDevice.tagNumber and $cwmDevice.serialNumber are null
                        if ($null -eq $cwmMultipleDevice.tagNumber -and $null -eq $cwmMultipleDevice.serialNumber) {
                            Write-Host "Tag number and serial number not found for ID: " + $cwmDeviceId
                        }
                        # Check what type of device it is
                        if ($cwmMultipleDevice.type.name -eq 'Switch' -and $null -ne $cwmMultipleDevice.tagNumber) {
                            Write-Host "Device type is a switch"
                            $dellSupport = Get-SerialNumber -csv $false -serviceTag $cwmMultipleDevice.tagNumber
                            Update-CWMVendorNote -cwmDevice $cwmMultipleDevice -dellSupport $dellSupport
                            Update-CWMPurchaseDate -cwmDevice $cwmMultipleDevice -dellSupport $dellSupport
                            Update-CWMWarrantyExpirationDate -cwmDevice $cwmMultipleDevice -dellSupport $dellSupport
                            Update-CWMManufacturer -cwmDevice $cwmMultipleDevice -dellSupport $dellSupport
                            Write-Host "Configuration - " + $cwmMultipleDevice.name + " updated successfully"
                        } elseif ($cwmMultipleDevice.type.name -eq 'Managed Workstation' -and $null -ne $cwmMultipleDevice.serialNumber) {
                            Write-Host "Device type is a managed workstation"
                            $dellSupport = Get-SerialNumber -csv $false -serviceTag $cwmMultipleDevice.serialNumber
                            $deviceID = $dellSupport.id
                            if ($null -eq $cwmMultipleDevice.tagNumber) {  
                                Update-CWMCompanyConfiguration -id $cwmMultipleDevice.id -Operation add -Path 'tagNumber' -Value $deviceID -Verbose
                            } else {
                                Update-CWMCompanyConfiguration -id $cwmMultipleDevice.id -Operation replace -Path 'tagNumber' -Value $deviceID -Verbose
                            }
                            Update-CWMVendorNote -cwmDevice $cwmMultipleDevice -dellSupport $dellSupport
                            Update-CWMPurchaseDate -cwmDevice $cwmMultipleDevice -dellSupport $dellSupport
                            Update-CWMWarrantyExpirationDate -cwmDevice $cwmMultipleDevice -dellSupport $dellSupport
                            Update-CWMManufacturer -cwmDevice $cwmMultipleDevice -dellSupport $dellSupport
                            Write-Host "Configuration - " + $cwmMultipleDevice.name + " updated successfully"
                        }  else {
                        Write-Host "Device type not found"
                        }
                    }
                } else {
                    if ($null -eq $cwmDevice) {
                        Write-Host "Configuration not found: " + $configName
                    } 
                    # Check if $cwmDevice.tagNumber and $cwmDevice.serialNumber are null
                    if ($null -eq $cwmDevice.tagNumber -and $null -eq $cwmDevice.serialNumber) {
                        Write-Host "Tag number and serial number not found: " + $configName
                    }
                    # Check what type of device it is
                    if ($cwmDevice.type.name -eq 'Switch' -and $null -ne $cwmDevice.tagNumber) {
                        Write-Host "Device type is a switch"
                        $dellSupport = Get-SerialNumber -csv $false -serviceTag $cwmDevice.tagNumber
                        Update-CWMVendorNote -cwmDevice $cwmDevice -dellSupport $dellSupport
                        Update-CWMPurchaseDate -cwmDevice $cwmDevice -dellSupport $dellSupport
                        Update-CWMWarrantyExpirationDate -cwmDevice $cwmDevice -dellSupport $dellSupport
                        Update-CWMManufacturer -cwmDevice $cwmDevice -dellSupport $dellSupport
                        Write-Host "Configuration updated successfully"
                    } elseif ($cwmDevice.type.name -eq 'Managed Workstation' -and $null -ne $cwmDevice.serialNumber) {
                        Write-Host "Device type is a managed workstation"
                        $dellSupport = Get-SerialNumber -csv $false -serviceTag $cwmDevice.serialNumber
                        $deviceID = $dellSupport.id
                        if ($null -eq $cwmDevice.tagNumber) {  
                            Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation add -Path 'tagNumber' -Value $deviceID -Verbose
                        } else {
                            Update-CWMCompanyConfiguration -id $cwmDevice.id -Operation replace -Path 'tagNumber' -Value $deviceID -Verbose
                        }
                        Update-CWMVendorNote -cwmDevice $cwmDevice -dellSupport $dellSupport
                        Update-CWMPurchaseDate -cwmDevice $cwmDevice -dellSupport $dellSupport
                        Update-CWMWarrantyExpirationDate -cwmDevice $cwmDevice -dellSupport $dellSupport
                        Update-CWMManufacturer -cwmDevice $cwmDevice -dellSupport $dellSupport
                        Write-Host "Configuration updated successfully"
                    } else {
                        Write-Host "Device type not found for: " + $configName
                    }
                }
            }
        }
        3 {
            Write-Host "Exiting"
            Disconnect-CWM
            exit
        }
    }

}

function Start-CWMAutomagically {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$cwServer,
        [Parameter(Mandatory = $true)]
        [string]$cwCompany
    )
    Show-CWMBanner
    # Write a loading message that has dots that appear one at a time
    Start-CWMQuickStart -cwServer $cwServer -cwCompany $cwCompany
    Write-Host "Loading." -NoNewline
    Start-Sleep -Seconds 1
    Write-Host "." -NoNewline
    Start-Sleep -Seconds 1
    Write-Host "." -NoNewline
    Start-Sleep -Seconds 1
    Write-Host "."
    Start-Sleep -Seconds 1
    Write-Host "Welcome to the ConnectWise Automagically script"
    Start-Sleep -Seconds 1
    Write-Host "This script will help you automate the process of updating your ConnectWise Manage configuration with Dell Service Entitlements"
    Start-Sleep -Seconds 1
    Write-Host "Let's get started"
    Start-Sleep -Seconds 1
    Update-CWMConfig
    WantToTryAgain
}