<#
.SYNOPSIS
    Install GlobalProtect
.DESCRIPTION
    This Script is for use in Balboa environment.
    This will check the MD5 checksum of the downloaded file.
    This script will download and install GlobalProtect from the specified URL. 
    This script will also create a log file in the Temp directory.
.NOTES
    File Name      : Install-GlobalProtect-Balboa.ps1
    Author         : William Ford
    Prerequisite   : PowerShell V2
.LINK

.EXAMPLE
    Install-GlobalProtect-Balboa.ps1

#>

# Variables
$TempFolder = "C:\Temp\GP"
$URL = "https://download.bnmg.net/gp/"
$MSI = "GlobalProtect64.msi"
$logfile = "$TempFolder\output.log"
$MD5 = "08BB4C0D89573984DF6B077DDEA26518"

# Check if GlobalProtect is already installed
$PreCheck = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "GlobalProtect" }
if ($PreCheck -ne $null) {
    Write-Host "GlobalProtect is already installed" -ForegroundColor Green
    exit
} else {

    # Variables
    $MSIPath = "$TempFolder\$MSI"
    # Create Temp Directory
    New-Item -ItemType Directory -Force -Path $TempFolder

    # Download File
    Invoke-WebRequest -Uri "$URL$MSI" -OutFile "$TempFolder\$MSI"
    Write-Host "MSI File Downloaded to $MSIPath"

    #MD5 Checksum check
    $MD5download = Get-FileHash -Path $MSIPath -Algorithm MD5
    if ($MD5download.Hash -ne $MD5) {
        Write-Host "MD5 Checksum failed. Downloaded file is corrupt" -ForegroundColor Red
        # Remove Temp Directory
        Write-Host "Removing Temp Directory"
        Remove-Item -Path $TempFolder -Recurse -Force
        exit
    }else {
        Write-Host "MD5 Checksum passed"    
        # Install MSI silently
        Write-Host "Installing GlobalProtect..."
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $MSIPath ALLUSERS=1 /q /norestart /log $logfile PORTAL=alwayson.balboaunited.org" -Wait
    }
}

# Check if MSI installed
$Installed = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "GlobalProtect" }
if ($Installed -eq $null) {
    Write-Host "GlobalProtect failed to be installed. Locate the Log file located at $logfile" -ForegroundColor Red
} else {
    Write-Host "GlobalProtect installed" -ForegroundColor Green
    # Remove Temp Directory
    Write-Host "Removing Temp Directory"
    Remove-Item -Path $TempFolder -Recurse -Force
}