<#
.SYNOPSIS
    This script generates a report of mailbox sizes for mailboxes in Exchange Online.
.DESCRIPTION
    This script generates a report of mailbox sizes for mailboxes in Exchange Online. The report includes the following information:
        - Display Name
        - Email Address
        - Mailbox Type
        - Last User Action Time
        - Total Size (GB)
        - Deleted Items Size (GB)
        - Item Count
        - Deleted Items Count
        - Mailbox Warning Quota (GB)
        - Max Mailbox Size (GB)
        - Mailbox Free Space (GB)
        - Archive Size (GB)
        - Archive Items Count
        - Archive Mailbox Free Space (GB)
        - Archive Deleted Items Count
        - Archive Warning Quota (GB)
        - Archive Quota (GB)
    The script requires the Exchange Online PowerShell v2 module to be installed. If the module is not installed, the script will prompt the user to install it.
.PARAMETER adminUPN
    The User Principal Name (UPN) of the admin account to connect to Exchange Online.
.PARAMETER sharedMailboxes
    Get (only) Shared Mailboxes or not. Default include them.
.PARAMETER sourceType
    Get all mailboxes or only a list of user mailboxes. Default is all mailboxes.
.PARAMETER archive
    Include Archive mailboxes.
.PARAMETER csvFilePath
    The path to the CSV file containing the list of users.
.PARAMETER path
    The path to save the exported report CSV file.
.EXAMPLE
    .\MailboxSizeReport.ps1 -adminUPN admin@contoso.com -sharedMailboxes include -sourceType all -archive -path 'C:\Reports\MailboxSizes.csv' 
    This example generates a report of mailbox sizes for all mailboxes in Exchange Online and saves the report to 'C:\Reports\MailboxSizes.csv'.

    .\MailboxSizeReport.ps1 -adminUPN admin@contoso.com -sharedMailboxes include -sourceType list -csvFilePath 'C:\Users.csv' -path 'C:\Reports\MailboxSizes.csv'
    This example generates a report of mailbox sizes for the users in the 'Users.csv' file and saves the report to 'C:\Reports\MailboxSizes.csv'.
.NOTES
    File Name: Get-MailboxSizeReport.ps1
    Author: William Ford (@WFord26)
    Date: 06/26/2024
    Prerequisite: Exchange Online PowerShell v2 module
#>

param(
  [Parameter(
    Mandatory = $true,
    HelpMessage = "Enter the Exchange Online or Global admin username"
  )]
  [string]$adminUPN,

  [Parameter(
    Mandatory = $false,
    HelpMessage = "Get (only) Shared Mailboxes or not. Default include them"
  )]
  [ValidateSet("no", "only", "include")]
  [string]$sharedMailboxes = "include",

  [Parameter(
    Mandatory = $true,
    HelpMessage = "Get all mailboxes or only a list of user mailboxes. Default is all mailboxes"
  )]
  [ValidateSet("all", "list")]
  [string]$sourceType = "all",

  [Parameter(
      Mandatory = $false,
      HelpMessage = "Include Archive mailboxes"
  )]
  [switch]$archive,
  [Parameter(
    Mandatory = $false,
    HelpMessage = "Enter the path to the CSV file containing the list of users"
  )]
    [string]$csvFilePath,

  [Parameter(
    Mandatory = $false,
    HelpMessage = "Enter path to save the exported report CSV file"
  )]
  [string]$path = ".\MailboxSizeReport-$((Get-Date -format "MMM-dd-yyyy").ToString()).csv"
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


# Get the users that will be included in the report from a CSV file
Function Get-UsersFromCSV {
    <#
      .SYNOPSIS
          Get the users from a CSV file.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string]$CsvFilePath
    )
    try {
        # Import the CSV file
        $users = Import-Csv -Path $CsvFilePath

        # Extract the UPN values from the CSV file
        $upns = $users.UPN

        # Return the UPN values
        return $upns
    }
    catch {
        Write-Error "Failed to get users from CSV file. $_"
    }
}
Function ConvertTo-Gb {
    <#
      .SYNOPSIS
          Convert mailbox size to Gb for uniform reporting.
    #>
    param(
      [Parameter(
        Mandatory = $true
      )]
      [string]$size
    )
    process {
      if ($size -ne $null) {
        $value = $size.Split(" ")
  
        switch($value[1]) {
          "GB" {$sizeInGb = ($value[0])}
          "MB" {$sizeInGb = ($value[0] / 1024)}
          "KB" {$sizeInGb = ($value[0] / 1024 / 1024)}
        }
  
        return [Math]::Round($sizeInGb,2,[MidPointRounding]::AwayFromZero)
      }
    }
  }
  Function Get-MailboxStats {
    <#
      .SYNOPSIS
          Get the mailbox size and quota
    #>
    process {
      # Clear $mailboxes array
      $mailboxes = @()
      # Get mailboxes from list or all users.
      if($sourceType -eq "list") {
        # test path, if path is not valid or doesn't exist, ask user to enter in path again.
        while (-not (Test-Path $csvFilePath)) {
          Write-Host "The path $csvFilePath is not valid or doesn't exist. Please enter a valid path." -ForegroundColor Red
          $csvFilePath = Read-Host "Enter the path to the CSV file containing the list of users"
        }
        # Get users from CSV
        $users = Get-UsersFromCSV -CsvFilePath $csvFilePath
        $users | ForEach-Object {
          $mailboxes += Get-EXOMailbox -UserPrincipalName $_
        }
      } else {
        $mailboxes = Get-Mailboxes
      }
      $i = 0
  
      $mailboxes | ForEach-Object {
  
        # Get mailbox size     
        $mailboxSize = Get-MailboxStatistics -identity $_.UserPrincipalName | Select-Object TotalItemSize,TotalDeletedItemSize,ItemCount,DeletedItemCount,LastUserActionTime
  
        if ($null -ne $mailboxSize) {
        
          # Get archive size if it exists and is requested
          $archiveSize = 0
          $archiveResult = $null
  
          if ($archive.IsPresent -and ($null -ne $_.ArchiveDatabase)) {
            $archiveResult = Get-EXOMailboxStatistics -UserPrincipalName $_.UserPrincipalName -Archive | Select-Object ItemCount,DeletedItemCount,@{Name = "TotalArchiveSize"; Expression = {$_.TotalItemSize.ToString().Split("(")[0]}}
            if ($null -ne $archiveResult) {
              $archiveSize = ConvertTo-Gb -size $archiveResult.TotalArchiveSize
            }else{
              $archiveSize = 0
            }
          }  
      
          [pscustomobject]@{
            "Display Name" = $_.DisplayName
            "Email Address" = $_.PrimarySMTPAddress
            "Mailbox Type" = $_.RecipientTypeDetails
            "Last User Action Time" = $mailboxSize.LastUserActionTime
            "Total Size (GB)" = ConvertTo-Gb -size $mailboxSize.TotalItemSize.ToString().Split("(")[0]
            "Deleted Items Size (GB)" = ConvertTo-Gb -size $mailboxSize.TotalDeletedItemSize.ToString().Split("(")[0]
            "Item Count" = $mailboxSize.ItemCount
            "Deleted Items Count" = $mailboxSize.DeletedItemCount
            "Mailbox Warning Quota (GB)" = ($_.IssueWarningQuota.ToString().Split("(")[0]).Split(" GB") | Select-Object -First 1
            "Max Mailbox Size (GB)" = ($_.ProhibitSendReceiveQuota.ToString().Split("(")[0]).Split(" GB") | Select-Object -First 1
            "Mailbox Free Space (GB)" = (($_.ProhibitSendReceiveQuota.ToString().Split("(")[0]).Split(" GB") | Select-Object -First 1) - (ConvertTo-Gb -size $mailboxSize.TotalItemSize.ToString().Split("(")[0])
            "Archive Size (GB)" = $archiveSize
            "Archive Items Count" = $archiveResult.ItemCount
            "Archive Mailbox Free Space (GB)*" = (ConvertTo-Gb -size $_.ArchiveQuota.ToString().Split("(")[0]) - $archiveSize
            "Archive Deleted Items Count" = $archiveResult.DeletedItemCount
            "Archive Warning Quota (GB)" = ($_.ArchiveWarningQuota.ToString().Split("(")[0]).Split(" GB") | Select-Object -First 1
            "Archive Quota (GB)" = ConvertTo-Gb -size $_.ArchiveQuota.ToString().Split("(")[0]
          }
  
          $currentUser = $_.DisplayName
          Write-Progress -Activity "Collecting mailbox status" -Status "Current Count: $i" -PercentComplete (($i / $mailboxes.Count) * 100) -CurrentOperation "Processing mailbox: $currentUser"
          $i++;
        }
      }
    }
  }
# Connect to Exchange Online
Connect-EXO
Write-Host "Connected to Exchange Online as $adminUPN" -ForegroundColor Green
# Get mailbox status
Get-MailboxStats | Export-CSV -Path $path -NoTypeInformation -Encoding UTF8

if ((Get-Item $path).Length -gt 0) {
  Write-Host "Report finished and saved in $path" -ForegroundColor Green
}else{
  Write-Host "Failed to create report" -ForegroundColor Red
}


# Close Exchange Online Connection
$close = Read-Host Close Exchange Online connection? [Y] Yes [N] No 

if ($close -match "[yY]") {
  Disconnect-ExchangeOnline -Confirm:$false | Out-Null
}
