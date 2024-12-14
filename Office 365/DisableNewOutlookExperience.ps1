<#
.SYNOPSIS
    This script will close Outlook and set the registry key to disable the new Outlook experience.
.DESCRIPTION
    This script will close Outlook and set the registry key to disable the new Outlook experience.
.NOTES
    File Name      : DisableNewOutlookExperience.ps1
    Author         : William Ford
    Prerequisite   : PowerShell V2
    Date           : 12/4/2024
#>
# Check if PowerShell is running as an administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    exit
}
# Close Outlook
Stop-Process -Name OUTLOOK -Force

# Check if the registry key exists
# If it does not exist, create it
# Registry Key Location Computer\HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Outlook\Preferences
# Key UserNewOutlook
# Value needs to be 0
$regPath = "HKCU:\Software\Microsoft\Office\16.0\Outlook\Preferences"
$keyName = "UserNewOutlook"
$keyValue = 0

if (-not (Test-Path $regPath)) {
    echo "Creating registry path $regPath"
    New-Item -Path $regPath -Force
}

# Check if the registry key exists
# If it does not exist, create it
# If it does exist, update the value if need be.
if (-not (Test-Path "$regPath\$keyName")) {
    echo "Creating registry key $keyName"
    New-ItemProperty -Path $regPath -Name $keyName -Value $keyValue -PropertyType DWORD -Force
} else {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $keyName).$keyName
    if ($currentValue -ne $keyValue) {
        echo "Updating registry key $keyName"
        Set-ItemProperty -Path $regPath -Name $keyName -Value $keyValue
    }
}