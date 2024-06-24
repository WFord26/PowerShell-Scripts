<#
.SYNOPSIS
    This script adds a migration user as the OneDrive for Business owner for a list of users in a CSV file.
.DESCRIPTION
    This script adds a migration user as the OneDrive for Business owner for a list of users in a CSV file.
.PARAMETER url
    The SharePoint Admin URL.
.PARAMETER migrationUser
    The email address for the migration user.
.PARAMETER site 
    The SharePoint Site base URL. For example, contoso.
.PARAMETER csvFilePath  
    The path to the CSV file containing the list of users.
.EXAMPLE
    .\AddMigrationUserAsODBOwner.ps1 -url https://contoso-admin.sharepoint.com -migrationUser migration@contoso.com -site contoso -csvFilePath C:\Users.csv
.NOTES
    File Name      : AddMigrationUserAsODBOwner.ps1
    Author         : William Ford
    Prerequisite   : SharePoint Online Management Shell
#>
param(
  [Parameter(
    Mandatory = $true,
    HelpMessage = "Enter your SharePoint Admin URL. For exampl https://contoso-admin.sharepoint.com"
  )]
  [string]$url,
  [Parameter(
      Mandatory = $true,
      HelpMessage = "Enter the email address for the migration user (e.g. mwiz@domain.com)"
  )]
  [string]$migrationUser,
  [Parameter(
    Mandatory = $true,
    HelpMessage = "Enter the path to the CSV file containing the list of users"
  )]
    [string]$csvFilePath
)

Function Get-UsersFromCSV {
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
Function ConnectTo-SharePoint {  
    process {
      # Check if EXO is installed and connect if no connection exists
      if ((Get-Module -ListAvailable -Name PnP.PowerShell) -eq $null)
      {
        Write-Host "PnPOnline Module is required, do you want to install it?" -ForegroundColor Yellow
        
        $install = Read-Host Do you want to install module? [Y] Yes [N] No 
        if($install -match "[yY]") 
        { 
          Write-Host "Installing PnP PowerShell module" -ForegroundColor Cyan
          Install-Module PnP.PowerShell -Repository PSGallery -AllowClobber -Force
        } 
        else
        {
            Write-Error "Please install PnP Online module."
        } 
      if ((Get-Module -ListAvailable -Name PnP.PowerShell) -ne $null) 
      {
          Import-Module Microsoft.Online.SharePoint.PowerShell
          Connect-SPOService -Url $url 
      }else{
        Write-Error "Please install PnP PowerShell module."
      }
    }
  }
}
Function AddMigrationUserODBOwnner {
    process {
        $site=$url -Replace '-admin.sharepoint.com', '' -replace 'https://',''
        $oneDrives = @()
        $usersUPNS = Get-UsersFromCSV -CsvFilePath $csvFilePath
        # replace @ and . with _ in the $usersUPNS
        $usersUPNS = $usersUPNS -replace '@', '_' -replace '\.', '_'
        $usersUPNS |  ForEach-Object {
            Set-SPOUser -Site "https://$site-my.sharepoint.com/personal/$_" -LoginName $migrationUser -IsSiteCollectionAdmin $true
    }
}
}

# Conneect to SPOline
#ConnectTo-SharePoint
Connect-SPOService -Url $url 

# Add Migration User as ODB Owner
AddMigrationUserODBOwnner

# Cl
$close = Read-Host Close PNP Online connection? [Y] Yes [N] No 

if ($close -match "[yY]") {
  Disconnect-PnPOnline -Confirm:$false | Out-Null
}