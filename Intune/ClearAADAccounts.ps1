<#
.Synopsis
  Clears out AAD Tokens

.DESCRIPTION
  This script will backup and delete all AAD authentication tokens clearing 
  all registered accounts from the computer
   
.NOTES
  Name: ClearAADAccounts.ps1
  Author: W. Ford
  Version: 1.0
  DateCreated: Nov 2022
  Purpose/Change: Initial Script
#>



#Backup Directory
$dir="C:\temp\IntuneCleanUp"
md $dir\AADbackup

#Copies all AAD.broker token folders to file location then removes them
Get-ItemProperty -Path "C:\Users\*\AppData\Local\Packages" | ForEach-Object {
Copy-Item -Path "$_\Microsoft.AAD.BrokerPlugin*" -Destination $dir\AADbackup -Recurse -Force | Out-Null
Remove-Item -Path "$_\Microsoft.AAD.BrokerPlugin*" -Recurse -Force | Out-Null
}