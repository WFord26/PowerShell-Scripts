<#
.SYNOPSIS
    This script will set an external forwarding address for a list of users in a CSV file.
.DESCRIPTION
    This script will set an external forwarding address for a list of users in a CSV file.
    The CSV file should have two columns, UPN and Email. The UPN column should contain the user's UPN and the Email column should contain the external email address to forward to.
    The script will loop through each row in the CSV file and set the external forwarding address for the user specified in the UPN column to the email address specified in the Email column.
    If the forwarding address is set successfully, the script will output a success message. If the forwarding address cannot be set, the script will output an error message and log the error to a file.
.PARAMETER adminUPN
    The User Principal Name (UPN) of the admin account to connect to Exchange Online.
.PARAMETER csvPath
    The path to the CSV file containing the list of users and external email addresses to set forwarding for.
.EXAMPLE
    .\Set-ExternalForwarding.ps1 -adminUPN admin@contoso.com -csvPath C:\Users.csv
    This example will set an external forwarding address for each user in the Users.csv file using the admin account
.NOTES
    File Name      : Set-ExternalForwarding.ps1
    Author         : William Ford (wford@managedsolution.com)
    Prerequisite   : Exchange Online PowerShell v2 module
    Date           : 06/26/2024
#>
param (
    [Parameter(Mandatory=$true)]
    [string]$adminUPN,
    [Parameter(Mandatory=$true)]
    [string]$csvPath
)
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

Function Set-ExternalSMTPForwarding{
    <#
      .SYNOPSIS
          Set an external forwarding address for a list of users in a CSV file.
    #>
    
    # Import CSV from File
    $csv = Import-Csv $csvPath

    # Initialize an empty array to track errors
    $errorTrack = @()

    # Count Rows in $csv
    $rowCount = $csv.Count
    
    # For Each UPN in CSV loop through and set an external forwarding address from the email column in the csv
    foreach ($row in $csv) {
        $upn = $row.UPN
        $email = $row.Email
        Set-Mailbox -Identity $upn -ForwardingSmtpAddress $email
        # Check if the command was successful
        if ($?) {
            Write-Host "Forwarding set for $upn to $email" -ForegroundColor Green
        }
        else {
            Write-Host "Failed to set forwarding for $upn to $email" -ForegroundColor Red
            $errorTrack += $upn
        }
    }
    # Count Errors
    $errorCount = $errorTrack.Count
    # Check for errors
    if ($errorCount -gt 0) {
        # Log errors to a file
        $errorLogPath = "$PSScriptRoot\ForwardingErrors.txt"
        Write-Host "Errors occurred setting forwarding for $errorCount out of $rowCount users:" -ForegroundColor Red
        Write-Host "Check the error log at $errorLogPath" -ForegroundColor Red
    }
    else {
        # No errors
        Write-Host "All forwardings set successfully" -ForegroundColor Green
    }
}

# Connect to Exchange Online
Connect-EXO

# Set External Forwarding
Set-ExternalSMTPForwarding