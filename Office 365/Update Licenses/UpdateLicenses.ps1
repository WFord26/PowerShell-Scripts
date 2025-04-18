<#
.Synopsis
    Add, Remove, or Replace Office 365 Licenses for users.

.DESCRIPTION
    This script allows you to manage Office 365 Licenses by adding, removing, or replacing them for all users or a single user.

.NOTES
    Name: UpdateLicense
    Author: W. Ford
    DateCreated: July 2022
    Version: 1.5
    Change Log: 
        1.0 - Initial Script
        1.1 - Added Logging
        1.2 - Added User Interaction
        1.3 - Added License Replacement Option
        1.4 - Added Error Logging
        1.5 - Added Set-License Function

.PARAMETER userFile
    The path to the file containing the list of users whose licenses need to be updated.

.EXAMPLE
    .\UpdateLicenses.ps1 -userFile 'C:\scripts\termination.txt'
    Update licenses for users listed in the file located at 'C:\scripts\termination.txt'
#>
param(
  [Parameter(
    Mandatory = $false,
    HelpMessage = "Enter path to your users TXT file. (Default .\users.txt)"
  )]
  [string]$userFile = ".\users.txt"
)
function InstallMSO {
    <#
    .SYNOPSIS
    Installs MSOnline and Imports Module. If it fails throws error and exit script.

    #>
    if ($null -eq (Get-Module -ListAvailable -Name MSOnline))
        {
        Write-Host "MSOnline Module is required, do you want to install it?" -ForegroundColor Yellow
            
        $install = Read-Host "Do you want to install module? [Y] Yes [N] No"
        if($install -match "[yY]") 
        { 
            Write-Host "Installing MSOnline module" -ForegroundColor Cyan
            Install-Module MSOnline -Repository PSGallery -AllowClobber -Force
        } 
        else
        {
            Write-Error "Please install MSOnline module."
            Exit
        }
        }
    if ($null -ne (Get-Module -ListAvailable -Name MSOnline))
        {
          if(-not (Get-MsolDomain -ErrorAction SilentlyContinue))
          {
            if ($Host.Version.Major -eq 7) {
              # Importing MSOnline module using -UseWindowsPowershell is necessary for compatibility with PowerShell 7
              Import-Module MSOnline -UseWindowsPowershell
            }
          }
        }
        else{
          Write-Error "Please install Msol module."
          Exit
        }
    
}
function ConnectToMSO {
    <#
    .SYNOPSIS
    Checks to see if conncted to MSOnline, shows what domain currently connected to. 
    Prompts user if they wish to proceed, and gives chance to correct login. 
    #>
    try
    {
        Get-MsolDomain -ErrorAction Stop > $null
    }
    catch 
    {
        Write-Output "Connecting to Office 365..."
        Connect-MsolService
    }
    # Gets Company Domain name currently connected to
    $companyDomainArray = Get-MsolDomain
    $companyDomain = $companyDomainArray[0].Name
    Write-Host "You are connected to MSOnline Services as:  $companyDomain" -ForegroundColor Green
    Write-Warning "DO YOU WISH TO PROCEED WITH CHANGES TO THIS TENANT? (Y/N)"
    $Response = Read-Host
        IF ($Response -ne "Y")
        {
            Write-Host "Signing out of MSOnline Services" -ForegroundColor Red
            Write-Host "..." -ForegroundColor Red
            # Sign out of MSOnline Service
            [Microsoft.Online.Administration.Automation.ConnectMsolService]::ClearUserSessionState()
            Write-Host "Logged out. Please enter your Administrator Credentials" -ForegroundColor Green
            Write-Output "Connecting to Office 365..."
            Connect-MsolService
            $companyDomainArray = Get-MsolDomain
            $companyDomain = $companyDomainArray[0].Name
            Write-Host "You are connected to MSOnline Services as:  $companyDomain" -ForegroundColor Green
        } else {
            Write-Host "Starting Script"
        }
}
function BuildLogFile {
    # Log File
    $date=Get-Date -Format "MM-dd-yyyy.HH.mm"
    $companyDomainArray = Get-MsolDomain
    $logPath=$env:TEMP
    $logPath="c:\"
    $logFile="UpdateLicense.log.$companyDomain.$date.txt"
    $logCombined="$logPath\$logFile"
    # Create Log File
    New-Item -Path $logPath -Name $logFile -ItemType "file" -Force
    Start-Transcript -Path $logCombined -Append
    Write-Host "`n-----------------------------------------------------------------------------------------`n"
    Write-Host "                   Office 365 License Removal Script"
    Write-Host "`n-----------------------------------------------------------------------------------------`n"
    pause
    Write-Host " "
}
function Write-Log {
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        [Parameter(Mandatory)]
        [ValidateSet('Info', 'Warning', 'Error')]
        [string]$Level
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] [$Level] $Message"

    # Write to text log file
    Add-Content -Path $logCombined -Value $logEntry

    # Write to Windows Event Log (optional)
    switch ($Level) {
        'Info' { [System.Diagnostics.EventLog]::WriteEntry('UpdateLicenses', $Message, [System.Diagnostics.EventLogEntryType]::Information) }
        'Warning' { [System.Diagnostics.EventLog]::WriteEntry('UpdateLicenses', $Message, [System.Diagnostics.EventLogEntryType]::Warning) }
        'Error' { [System.Diagnostics.EventLog]::WriteEntry('UpdateLicenses', $Message, [System.Diagnostics.EventLogEntryType]::Error) }
    }
}
function Show-Menu{
    <#
    .SYNOPSIS
    Displays a menu with options for updating Office 365 licenses.
    #>
    param (
        [string]$Title = 'Office 365 License Update Options'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to add licenses."
    Write-Host "2: Press '2' to remove licenses."
    Write-Host "3: Press '3' to replace licenses."
    Write-Host "Q: Press 'Q' to quit."
}
function Set-License{
    <#
    .Synopsis
    Sets the license for a user depending on the passed parameters.
    #>
    param(
        [Parameter(Mandatory), ValidateSet('add', 'remove', 'replace')]
        [string]$action,
        [Parameter(Mandatory)]
        [string]$userFile
    )
    $usersList = Get-Content $userFile
    if ($action -eq 'add') {
        $gridAddLicenses = $companyLicenses.AccountSkuId | Out-GridView -Title "Choose licenes to Add" -PassThru
        $gridAddJoined = ($gridAddLicenses -join ", ")
        Write-Warning "The following settings have been choosen:"
        Write-Output "Licenses to Add:    $gridAddJoined"
        Write-Output "For the users below."
        Write-Output "--------------------"
        Write-Output $usersList
        Write-Host " "
        Write-Host -nonewline "Do you want to proceed? (Y/N): "
        $Response = Read-Host
        IF ($Response -ne "Y") {
            Write-Warning "Backing Out"
            Break
        } else {
            Write-Warning "Starting Updates"
            $usersList | ForEach-Object {
                try {
                    Set-MsolUserLicense -UserPrincipalName $_ -AddLicenses $gridAddLicenses
                    Write-Log -Message "$_ had $gridAddJoined added." -Level 'Info'
                }
                catch {
                    $errorMessage = $_.Exception.Message
                    Write-Log -Message "Error updating licenses for $_. Error: $errorMessage" -Level 'Error'
                }
                Write-Output "$_ had $gridAddJoined added."
            }
            Write-Host "Updates completed!" -ForegroundColor Green
            Break
        }
    } elseif ($action -eq 'remove') {
        $gridRemoveLicenses = $companyLicenses.AccountSkuId | Out-GridView -Title "Choose licenes to Remove" -PassThru
        $gridRemovedJoined = ($gridRemoveLicenses -join ", ")
        Write-Warning "The following settings have been choosen:"
        Write-Output "Licenses to Remove: $gridRemovedJoined"
        Write-Output "For the users below."
        Write-Output "--------------------"
        Write-Output $usersList
        Write-Host " "
        Write-Host -nonewline "Do you want to proceed? (Y/N): "
        $Response = Read-Host
        IF ($Response -ne "Y") {
            Write-Warning "Backing Out"
            {Break}
        } else {
            Write-Warning "Starting Updates"
            $usersList | ForEach-Object {
                try {
                    Set-MsolUserLicense -UserPrincipalName $_ -RemoveLicenses $gridRemoveLicenses
                    Write-Log -Message "$_ had $gridRemovedJoined removed." -Level 'Info'
                }
                catch {
                    $errorMessage = $_.Exception.Message
                    Write-Log -Message "Error removing licenses for $_. Error: $errorMessage" -Level 'Error'
                }
                Write-Output "$_ had $gridRemovedJoined removed."
            }
            Write-Host "Updates completed!" -ForegroundColor Green
            {Break}
        }
    } elseif ($action -eq 'replace') {
        $gridAddLicenses = $companyLicenses.AccountSkuId | Out-GridView -Title "Choose licenes to Add" -PassThru
        $gridRemoveLicenses = $companyLicenses.AccountSkuId | Out-GridView -Title "Choose licenes to Remove" -PassThru
        $gridAddJoined = ($gridAddLicenses -join ", ")
        $gridRemovedJoined = ($gridRemoveLicenses -join ", ")
        Write-Warning "The following settings have been choosen:"
        Write-Output "Licenses to Add:    $gridAddJoined"
        Write-Output "Licenses to Remove: $gridRemovedJoined"
        Write-Output "For the users below."
        Write-Output "--------------------"
        Write-Output $usersList
        Write-Host " "
        Write-Host -nonewline "Do you want to proceed? (Y/N): "
        $Response = Read-Host
        IF ($Response -ne "Y") {
            Write-Warning "Backing Out"
            {Break}
        } else {
            Write-Warning "Starting Updates"
            $usersList | ForEach-Object {
                try {
                    Set-MsolUserLicense -UserPrincipalName $_ -AddLicenses $gridAddLicenses -RemoveLicenses $gridRemoveLicenses
                    Write-Output "$_ had $gridAddJoined added and had $gridRemoveJoined removed."
                }
                catch {
                    $errorMessage = $_.Exception.Message
                    Write-Log -Message "Error updating licenses for $_. Error: $errorMessage" -Level 'Error'
                }
                Write-Log -Message "$_ had $gridAddJoined added and had $gridRemoveJoined removed." -Level 'Info'
            }
            Write-Host "Updates completed!" -ForegroundColor Green
            {Break}
        }
    }
}
InstallMSO
ConnectToMSO
BuildLogFile
# Create License Array
$companyLicenses = Get-MsolAccountSku
# Looping Statement
do
 {
     Show-Menu
     $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' <# Add #> {
             'You chose option #1'
                Set-License -action 'add' -userFile $userFile
         } '2' <# Remove #> {
             'You chose option #2'
                Set-License -action 'remove' -userFile $userFile
         } '3'<# Replace #> {
             'You chose option #3'
                Set-License -action 'replace' -userFile $userFile
         } 'Q'<# QUIT #>{
            Write-Host 'Exiting Script'
            [Microsoft.Online.Administration.Automation.ConnectMsolService]::ClearUserSessionState()
            Get-PSSession | Remove-PSSession
            Stop-Transcript
            Exit
         } default {
             Write-Warning 'Incorrect selection.'
             pause
         }
     }
 }
 until ($selection -ieq 'q')
#Clean up session

Get-PSSession | Remove-PSSession
[Microsoft.Online.Administration.Automation.ConnectMsolService]::ClearUserSessionState()