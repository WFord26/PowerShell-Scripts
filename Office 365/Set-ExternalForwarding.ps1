<#
.SYNOPSIS
    This script will set or remove external forwarding address for a list of users in a CSV file.
.DESCRIPTION
    This script will set or remove external forwarding address for a list of users in a CSV file.

        TO ADD FORWARDING: The CSV file should have two columns, UPN and Email. The UPN column should contain the user's UPN and the Email column should contain the external email address to forward to.
        The script will loop through each row in the CSV file and set the external forwarding address for the user specified in the UPN column to the email address specified in the Email column.
        If the forwarding address is set successfully, the script will output a success message. If the forwarding address cannot be set, the script will output an error message and log the error to a file.

        TO REMOVE FORWARDING: The CSV file should have one column, UPN. The UPN column should contain the user's UPN.
        The script will loop through each row in the CSV file and remove the external forwarding address for the user specified in the UPN column.
        If the forwarding address is removed successfully, the script will output a success message. If the forwarding address cannot be removed, the script will output an error message and log the error to a file. 
.PARAMETER adminUPN
    The User Principal Name (UPN) of the admin account to connect to Exchange Online.
.PARAMETER csvPath
    The path to the CSV file containing the list of users and external email addresses to set forwarding for.
.PARAMETER removeForwarding
    A switch to indicate whether to remove external forwarding addresses. If this switch is present, the script will remove external forwarding addresses for the users in the CSV file. If the switch is not present, the script will set external forwarding addresses for the users in the CSV file.
.EXAMPLE
    .\Set-ExternalForwarding.ps1 -adminUPN admin@contoso.com -csvPath C:\Users.csv 
    This example will set an external forwarding address for each user in the Users.csv file using the admin account
.EXAMPLE
    .\Set-ExternalForwarding.ps1 -adminUPN admin@contoso.com -csvPath C:\Users.csv -removeForwarding $true
    This example will remove the external forwarding address for each user in the Users.csv file using the admin account admin@contoso.com
.NOTES
    File Name      : Set-ExternalForwarding.ps1
    Versionn       : 1.5
    Author         : William Ford (wford@managedsolution.com)
    Prerequisite   : Exchange Online PowerShell v2 module
    Change History : 1.0 - Initial Script
                     1.1 - Added error handling and logging
                     1.2 - Added option to remove forwarding addresses
                     1.3 - Added success logging
                     1.4 - Added CloseConnection function
                     1.5 - Added error handling for missing EXO module and Function to Remove Forwarding                     
    Created Date   : 06/26/2024
    Last Modified  : 06/27/2024
#>
param (
    [Parameter(Mandatory=$true)]
    [string]$adminUPN,
    [Parameter(Mandatory=$true)]
    [string]$csvPath,
    [Parameter(Mandatory=$false)]
    [switch]$removeForwarding=$false
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

Function Set-ExternalSMTPForwarding{
    <#
      .SYNOPSIS
          Set an external forwarding address for a list of users in a CSV file.
    #>
    
    # Import CSV from File
    $csv = Import-Csv $csvPath

    # Initialize an empty array to track errors
    $errorTrack = @()

    # Initialize an empty array to track successes
    $successTrack = @()

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
            $successTrack += $upn
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
Function Remove-ExternalSMTPForwarding{
    <#
      .SYNOPSIS
          Remove an external forwarding address for a list of users in a CSV file.
    #>
    
    # Import CSV from File
    $csv = Import-Csv $csvPath

    # Initialize an empty array to track errors
    $errorTrack = @()

    # Initialize an empty array to track successes
    $successTrack = @()

    # Count Rows in $csv
    $rowCount = $csv.Count
    
    # For Each UPN in CSV loop through and remove the external forwarding address
    foreach ($row in $csv) {
        $upn = $row.UPN
        Set-Mailbox -Identity $upn -ForwardingSmtpAddress $null
        # Check if the command was successful
        if ($?) {
            Write-Host "Forwarding removed for $upn" -ForegroundColor Green
            $successTrack += $upn
        }
        else {
            Write-Host "Failed to remove forwarding for $upn" -ForegroundColor Red
            $errorTrack += $upn
        }
    }
    # Count Errors
    $errorCount = $errorTrack.Count
    
    #Create a success log file
    $successLogPath = "$PSScriptRoot\ForwardingSuccess-$adminUPN-$((Get-Date -format "MMM-dd-yyyy").ToString()).txt"

    # Check for errors
    if ($errorCount -gt 0) {
        # Create an error log file.
        $errorLogPath = "$PSScriptRoot\ForwardingErrors-$adminUPN-$((Get-Date -format "MMM-dd-yyyy").ToString()).txt"
        # Log errors to a file
        $errorTrack | Out-File $errorLogPath

        Write-Host "Errors occurred removing forwarding for $errorCount out of $rowCount users." -ForegroundColor Red
        Write-Host "Check the error log at $errorLogPath" -ForegroundColor Red
        Write-Host "Check the success log at $successLogPath" -ForegroundColor Green
    }
    else {
        # No errors
        Write-Host "All forwardings removed successfully" -ForegroundColor Green
        Write-Host "Check the success log at $successLogPath" -ForegroundColor Green
    }
}

# Connect to Exchange Online
Connect-EXO

# Check if the removeForwarding switch is set
if ($removeForwarding) {
    # Remove External Forwarding
    Remove-ExternalSMTPForwarding
}
else {
    # Set External Forwarding
    Set-ExternalSMTPForwarding
}
CloseConnection
end