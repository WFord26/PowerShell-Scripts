<#
.SYNOPSIS
  Sets all mailboxes listed in file to shared

.DESCRIPTION
  REQUIREMENTS
  ** Needs -adminUPN for script to run **
  This script will do the following:
  - Use user provided file with parameter or use default file, .\UsersToShared.txt
  - Checks if EXO is installed, installs if not.
  - Converts list to shared accounts
  - Copies UPNs that fail into an array
  - Displays mailboxes that failed to convert
  - Ask if you want to log out of Exchange Online


.EXAMPLE
  .\ConvertToShared.ps1 -adminUPN admin@contoso.com -fileDIR .\UsersToShared.txt
  
  This example will convert all mailboxes listed in UsersToShared.txt to shared mailboxes.

.NOTES
  Version:        1.0
  Author:         w ford
  Creation Date:  nov 2022
  Purpose/Change: Initial Script
#>
param(
  [Parameter(
    Mandatory = $true,
    HelpMessage = "Enter the Exchange Online or Global admin username"
  )]
  [string]$adminUPN,

  [Parameter(
    Mandatory = $false,
    HelpMessage = "Enter path to save the txt file"
  )]
  [string]$fileDIR = ".\UsersToShared.txt"
)
[System.Collections.ArrayList]$failedUPN = ""
Function Connect-EXO {
    <#
      .SYNOPSIS
          Connects to EXO when no connection exists. Checks for EXO v2 module
    #>
    
    process {
      # Check if EXO is installed and connect if no connection exists
      if ($null -eq (Get-Module -ListAvailable -Name ExchangeOnlineManagement))
      {
        Write-Host "Exchange Online PowerShell v2 module is requied, do you want to install it?" -ForegroundColor Yellow
        
        $install = Read-Host Do you want to install module? [Y] Yes [N] No 
        if($install -match "[yY]") 
        { 
          Write-Host "Installing Exchange Online PowerShell v2 module" -ForegroundColor Cyan
          Install-Module ExchangeOnlineManagement -Repository PSGallery -AllowClobber -Force
        } 
        else
        {
            Write-Error "Please install EXO v2 module."
        }
      }
  
  
      if ($null -ne (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) 
      {
          # Check if there is a active EXO sessions
          $psSessions = Get-PSSession | Select-Object -Property State, Name
          If (((@($psSessions) -like '@{State=Opened; Name=ExchangeOnlineInternalSession*').Count -gt 0) -ne $true) {
              Connect-ExchangeOnline -UserPrincipalName $adminUPN
          }
      }
      else{
        Write-Error "Please install EXO v2 module."
      }
    }
  }
Function CloseConnection {
    <#
      .SYNOPSIS
          Closes all Exchange Online sessions
    #>
    
    process {
      # Check if there is a active EXO sessions
      $psSessions = Get-PSSession | Select-Object -Property State, Name
      If (((@($psSessions) -like '@{State=Opened; Name=ExchangeOnlineInternalSession*').Count -gt 0) -ne $true) {
          Get-PSSession | Remove-PSSession
      }
    }
  }
function ConvertToShared {
    <#
      .SYNOPSIS
          Converts mailboxes to shared mailboxes
    #>
    
    process {
      # Check if file exists
    if (Test-Path $fileDIR) {
        Write-Host "File Exist"
    } else {
        Write-Host "File does not exist, please check path"
        # ask user for file path, with helper text.
        while (-not (Test-Path $fileDIR)) {
            $fileDIR = Read-Host "Enter path to file with UPNs"
        }
      }
      # Import File and convert to shared mailbox
      Get-Content "$fileDIR" | ForEach-Object {
        # Check if mailbox exists and convert to shared
        # If mailbox does not exist, add to failedUPN array
        Set-Mailbox $_ -Type Shared -ErrorAction SilentlyContinue
        # Check if mailbox was converted
        if ($?){
          Write-Host "$_ was converted to shared mailbox" -ForegroundColor Green
        } else {
          Write-Host "$_ failed to convert to shared mailbox" -ForegroundColor Red
          $failedUPN.Add($_)
          }    
      }
    }
}
#Connects to ExchangeOnline
Connect-EXO
ConvertToShared
CloseConnection