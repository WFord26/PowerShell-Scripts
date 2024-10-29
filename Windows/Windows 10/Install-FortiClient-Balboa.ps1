<#
.SYNOPSIS
    Install FortiClient
.DESCRIPTION
    This Script is for use in BALBOA UNITED environment.
    This script will download and install FortiClient EMS from the specified URL. 
    This script will also create a log file in the Temp directory.
.NOTES
    File Name      : Install-FortiClient-Balboa.ps1
    Author         : William Ford
    Prerequisite   : PowerShell V2
.LINK

.EXAMPLE
    Install-FortiClient-Balboa.ps1

#>

# Variables
$TempFolder = "C:\Temp_FortiClient"
$URL = "https://download.bnmg.net/ems/"
$MSI = "FortiClient.msi"
$MST = "FortiClient.mst"
$logfile = "$TempFolder\output.log"

# Check if FortiClient is already installed
$PreCheck = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "FortiClient" }
if ($PreCheck -ne $null) {
    Write-Host "FortiClient is already installed" -ForegroundColor Green
    exit
} else {

    # Variables
    $MSIPath = "$TempFolder\$MSI"
    $MSTPath = "$TempFolder\$MST"
    # Create Temp Directory
    New-Item -ItemType Directory -Force -Path $TempFolder

    # Download File
    Invoke-WebRequest -Uri "$URL$MSI" -OutFile "$TempFolder\$MSI"
    Write-Host "MSI File Downloaded to $MSIPath"
    Invoke-WebRequest -Uri "$URL$MST" -OutFile "$TempFolder\$MST"
    Write-Host "MST File Downloaded to $MSTPath"

    # Install MSI silently
    Write-Host "Installing FortiClient..."
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $MSIPath ALLUSERS=1 /q /norestart TRANSFORMS=$MSTPath /log $logfile " -Wait
}

# Check if MSI installed
$Installed = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "FortiClient" }
if ($Installed -eq $null) {
    Write-Host "FortiClient failed to be installed. Locate the Log file located at $logfile" -ForegroundColor Red
} else {
    Write-Host "FortiClient installed" -ForegroundColor Green
    # Remove Temp Directory
    Write-Host "Removing Temp Directory"
    Remove-Item -Path $TempFolder -Recurse -Force
}