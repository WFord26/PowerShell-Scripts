<#
.Synopsis
  Fixes issues with Azure Hybrid Joined Device stuck in Pending

.DESCRIPTION
  This script will do the following:
   - Leaves Azure AD
   - Creates backup directory
   - Copies all AAD auth tokens and deletes them
   - Stores Enrollments keys in a list array
   - Modifies text in array
   - Writes Keys that are backed up to host
   - Removes Keys that are needed/can't be deleted
   - Checks if any keys are to be deleted then, deletes keys from registry
   - Reboots Computer
   
.NOTES
  Name: AzureHybridPendingFix.ps1
  Author: W. Ford
  Version: 1.1
  DateCreated: Nov 2022
  Purpose/Change: updated registry keys to be kept, added check on Array list to see if it's null or not.
#>

#Backup Directory
$date=Get-Date -Format "MM-dd-yyyy.HH.mm"
$outDIR="C:\temp\IntuneCleanUp"
$dsregcmdFile="$outDIR\dsregcmd.$date.txt"
New-Item $outDIR\dsregcmd.$date.txt

#Checks if directory exists then creates it.
if (Test-Path $outDIR){
  Write-Host "Folder Exist"
  Write-Host $outDIR
} else {
  mkdir $outDIR\AADbackup.$date
}

#Export copy of current dsregcmd /status
dsregcmd /status >> $dsregcmdFile
#Force Azure AD Device Logout
dsregcmd /leave

#Copies all AAD.broker token folders to file location then removes them
Get-ItemProperty -Path "C:\Users\*\AppData\Local\Packages" | ForEach-Object {
  Copy-Item -Path "$_\Microsoft.AAD.BrokerPlugin*" -Destination $outDIR\AADbackup.$date -Recurse -Force | Out-Null
  Remove-Item -Path "$_\Microsoft.AAD.BrokerPlugin*" -Recurse -Force | Out-Null
  }

#Backs up Enrollments Registry keys
reg export HKLM\Software\Microsoft\Enrollments $outDIR\Enrollments.$date.reg

#Stores registry query for Enrollments in array list
[System.Collections.ArrayList]$regArray= reg query HKLM\SOFTWARE\Microsoft\Enrollments

#Replaces 'HKEY_LOCAL_MACHINE' with 'HKLM'
$regArray = $regArray -replace 'HKEY_LOCAL_MACHINE','HKLM'

#Write-host
Write-Host "Current Keys in Folder"
Write-Host $regArray

#Removes registry keys from array list that shouldn't be deleted
$regArray.Remove("HKLM\SOFTWARE\Microsoft\Enrollments\5281DB7A-989E-4CB9-A16F-6194722E17A8")
$regArray.Remove("HKLM\SOFTWARE\Microsoft\Enrollments\84741AD0-B358-49A9-83F8-F7E20AE12B3A")

#Checks if $regArray is null

if ($regArray){
  foreach ($reg in $regArray)
    {
      Write-Host "Deleting $reg"
      reg delete $reg /f
    }
} else {
  Write-Host "No Registry keys to delete."
}

#Reboots the computer
Restart-Computer -Force