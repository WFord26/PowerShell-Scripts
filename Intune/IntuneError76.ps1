<#
.Synopsis
  Part of the process to fix Error76

.DESCRIPTION
  This script will do the following:
   - Leaves Azure AD
   - Creates backup directory
   - Copies AAD Token authentication to backup location then deletes them
   - Exports Registry keys in Enrollments to backup location
   - Stores Enrollments keys in a list array
   - Modifies text in array
   - Writes Keys that are backed up to host
   - Removes Keys that are needed/can't be deleted
   - Writes to host keys that are being deleted
   - Deletes keys from registry
   - Reboots Computer
   
.NOTES
  Name: IntuneError76
  Author: W. Ford
  Version: 1.0
  DateCreated: Nov 2022
  Purpose/Change: Updated registry edit
#>

#Backup Directory
$dir="C:\temp\IntuneCleanUp"
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
Copy-Item -Path "$_\Microsoft.AAD.BrokerPlugin*" -Destination $dir\AADbackup -Recurse -Force | Out-Null
Remove-Item -Path "$_\Microsoft.AAD.BrokerPlugin*" -Recurse -Force | Out-Null
}

#Backs up Enrollments Registry keys
reg export HKLM\Software\Microsoft\Enrollments $dir\Enrollments.$date.reg

#Stores registry query for Enrollments in array list
[System.Collections.ArrayList]$regArray= reg query HKLM\SOFTWARE\Microsoft\Enrollments

#Replaces 'HKEY_LOCAL_MACHINE' with 'HKLM'
$regArray = $regArray -replace 'HKEY_LOCAL_MACHINE','HKLM'

#Write-host
Write-Host "Keys backed up to folder"
Write-Host $regArray

#Removes registry keys from array list that shouldn't be deleted
$regArray.Remove("HKLM\SOFTWARE\Microsoft\Enrollments\5281DB7A-989E-4CB9-A16F-6194722E17A8")
$regArray.Remove("HKLM\SOFTWARE\Microsoft\Enrollments\84741AD0-B358-49A9-83F8-F7E20AE12B3A")


#Write-host 
Write-Host "Keys to be deleted"
Write-Host $regArray

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