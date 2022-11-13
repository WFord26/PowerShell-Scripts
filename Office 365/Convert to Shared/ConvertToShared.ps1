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


EXAMPLE
  Get-MailboxSizeReport.ps1 -adminUPN johndoe@contoso.com -fileDIR c:\temp\users.txt

  To use file in the path: c:\temp\users.txt

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
Function ConnectTo-EXO {
    <#
      .SYNOPSIS
          Connects to EXO when no connection exists. Checks for EXO v2 module
    #>
    
    process {
      # Check if EXO is installed and connect if no connection exists
      if ((Get-Module -ListAvailable -Name ExchangeOnlineManagement) -eq $null)
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
  
  
      if ((Get-Module -ListAvailable -Name ExchangeOnlineManagement) -ne $null) 
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
#Connects to ExchangeOnline
ConnectTo-EXO
Get-Content "$fileDIR" | ForEach-Object {
    Set-Mailbox $_ -Type Shared -ErrorAction SilentlyContinue; $failedUPN.Add($_)
}
if($notMailboxes){
    Write-Host -ForegroundColor Red "Following UPNs are not Mailboxes"
    Write-Host -ForegroundColor Red $failedUPN
} else {
    Write-Host -InformationAction "All mailboxes covert successfully."
}
Pause
# Close Exchange Online Connection
$close = Read-Host Close Exchange Online connection? [Y] Yes [N] No 

if ($close -match "[yY]") {
  Disconnect-ExchangeOnline -Confirm:$false | Out-Null
}

#Clean UP Session
Get-PSSession | Remove-PSSession