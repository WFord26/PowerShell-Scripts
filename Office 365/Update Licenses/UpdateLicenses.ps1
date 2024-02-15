<#
.Synopsis
  Get the MFA status for all users or a single user.

.DESCRIPTION
  This script will allow you to Add, Remove, or Replace Office 365 Licenses.
   
.NOTES
  Name: UpdateLicense
  Author: W. Ford
  Version: 1.2
  DateCreated: jul 2022
  Purpose/Change: Assist Cloud team with License Replacement

 
.EXAMPLE
  .\UpdateLicenses.ps1 -userFile 'C:\scripts\termination.txt'

  Update licenses from users in file located at 'C:\scripts\termination.txt'

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
            
        $install = Read-Host Do you want to install module? [Y] Yes [N] No 
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
    $companyDomain = $companyDomainArray[0].Name
    $logPath="c:\"
    $logFile="UpdateLicense.log.$companyDomain.$date.txt"
    $logCombined="$logPath\$logFile"
    # Create Log File
    New-Item -Path $logPath -Name $logFile -ItemType "file"
    Start-Transcript -Append $logCombined
    Write-Host "`n-----------------------------------------------------------------------------------------`n"
    Write-Host "                   Office 365 License Removal Script"
    Write-Host "`n-----------------------------------------------------------------------------------------`n"
    pause
    Write-Host " "
}

function Show-Menu{
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
             ## User Interaction
             # User enters in location of User Text File
             # User chooses Licenses to Add
             $gridAddLicenses = $companyLicenses.AccountSkuId | Out-GridView -Title "Choose licenes to Add" -PassThru
             ## End
             # Creates a user list array
             $usersList = Get-Content $userFile
             # Converts to correct Format
             $gridAddJoined = ($gridAddLicenses -join ", ")

             # Confirms with User if they want to proceed.
             # Confirms Information
             Write-Warning "The following settings have been choosen:"
             Write-Output "Licenses to Add:    $gridAddJoined"
             Write-Output "For the users below."
             Write-Output "--------------------"
             Write-Output $usersList
             Write-Host " "
             # Confirm Yes or No
             Write-Host -nonewline "Do you want to proceed? (Y/N): "
             $Response = Read-Host
                 IF ($Response -ne "Y")
                 {
                     Write-Warning "Backing Out"
                     {Break}
                 } else {
                     Write-Warning "Starting Updates"
                     $usersList | ForEach-Object {
                         Set-MsolUserLicense -UserPrincipalName $_ -AddLicenses $gridAddLicenses -RemoveLicenses $gridRemoveLicenses
                         Write-Output "$_ had $gridAddJoined added."
                     }
                     Write-Host "Updates completed!" -ForegroundColor Green
                     {Break}
                 }
         } '2' <# Remove #> {
             'You chose option #2'
             ## User Interaction
             # User chooses licenses to remove
             $gridRemoveLicenses = $companyLicenses.AccountSkuId | Out-GridView -Title "Choose licenes to Remove" -PassThru
             ## End
             # Creates a user list array
             $usersList = Get-Content $userFile
             # Converts to correct Format
             $gridRemovedJoined = ($gridRemoveLicenses -join ", ")
             # Confirms with User if they want to proceed.
             # Confirms Information
             Write-Warning "The following settings have been choosen:"
             Write-Output "Licenses to Remove: $gridRemovedJoined"
             Write-Output "For the users below."
             Write-Output "--------------------"
             Write-Output $usersList
             Write-Host " "
             # Confirm Yes or No
             Write-Host -nonewline "Do you want to proceed? (Y/N): "
             $Response = Read-Host
                 IF ($Response -ne "Y")
                 {
                     Write-Warning "Backing Out"
                     {Break}
                 } else {
                     Write-Warning "Starting Updates"
                     $usersList | ForEach-Object {
                         Set-MsolUserLicense -UserPrincipalName $_ -RemoveLicenses $gridRemoveLicenses
                         Write-Output "$_ had $gridRemoveJoined removed."
                     }
                     Write-Host "Updates completed!" -ForegroundColor Green
                     {Break}
                 }
         } '3'<# Replace #> {
             'You chose option #3'
             ## User Interaction
             # User chooses Licenses to Add
             $gridAddLicenses = $companyLicenses.AccountSkuId | Out-GridView -Title "Choose licenes to Add" -PassThru
             # User chooses licenses to remove
             $gridRemoveLicenses = $companyLicenses.AccountSkuId | Out-GridView -Title "Choose licenes to Remove" -PassThru
             ## End
             # Creates a user list array
             $usersList = Get-Content $userFile
             # Converts to correct Format
             $gridAddJoined = ($gridAddLicenses -join ", ")
             $gridRemovedJoined = ($gridRemoveLicenses -join ", ")
             # Confirms with User if they want to proceed.
             # Confirms Information
             Write-Warning "The following settings have been choosen:"
             Write-Output "Licenses to Add:    $gridAddJoined"
             Write-Output "Licenses to Remove: $gridRemovedJoined"
             Write-Output "For the users below."
             Write-Output "--------------------"
             Write-Output $usersList
             Write-Host " "
             # Confirm Yes or No
             Write-Host -nonewline "Do you want to proceed? (Y/N): "
             $Response = Read-Host
                 IF ($Response -ne "Y")
                 {
                     Write-Warning "Backing Out"
                     {Break}
                 } else {
                     Write-Warning "Starting Updates"
                     $usersList | ForEach-Object {
                         Set-MsolUserLicense -UserPrincipalName $_ -AddLicenses $gridAddLicenses -RemoveLicenses $gridRemoveLicenses
                         Write-Output "$_ had $gridAddJoined added and had $gridRemoveJoined removed."
                     }
                     Write-Host "Updates completed!" -ForegroundColor Green
                     {Break}
                 }
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
 until ($selection -eq 'q')
#Clean up session

Get-PSSession | Remove-PSSession
[Microsoft.Online.Administration.Automation.ConnectMsolService]::ClearUserSessionState()