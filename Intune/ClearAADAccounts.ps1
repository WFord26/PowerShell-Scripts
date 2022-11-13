<#
.Synopsis
  Clears out AAD Tokens

.DESCRIPTION
  This script will backup and delete all AAD authentication tokens clearing 
  all registered accounts from the computer and reboots it.
   
.NOTES
  Name: ClearAADAccounts.ps1
  Author: W. Ford
  Version: 1.1
  DateCreated: Nov 2022
  Purpose/Change: Added reboot
#>

#Backup Directory
$dirAAD="C:\temp\IntuneCleanUp\AADbackup"

#Checks if directory exists then creates it
if (Test-Path $dirAAD){
  Write-Host "Folder Exist"
  Write-Host $dirAAD
} else {
  md $dirAAD
}

#Copies all AAD.broker token folders to file location then removes them
Get-ItemProperty -Path "C:\Users\*\AppData\Local\Packages" | ForEach-Object {
  Copy-Item -Path "$_\Microsoft.AAD.BrokerPlugin*" -Destination $dirAAD -Recurse -Force | Out-Null
  Remove-Item -Path "$_\Microsoft.AAD.BrokerPlugin*" -Recurse -Force | Out-Null
}

#Reboots the computer
Restart-Computer -Force