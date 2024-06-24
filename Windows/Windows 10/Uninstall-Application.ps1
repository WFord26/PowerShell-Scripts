# Parameters
# $Application - The name of the application to uninstall. This is a required parameter.
# $TempFolder - The folder where the log file will be saved. This is an optional parameter. The default value is "C:\Temp".
.param(
    [Parameter(Mandatory=$true)]
    [string]$Application,
    [Parameter(Mandatory=$false)]
    [string]$TempFolder = "C:\Temp"
)

# Variables
$logfile = "$TempFolder\output.log"
# Wildcard search for the application
$Application = "*$Application*"
# Check if Application is already installed, if it is installed uninstall it.
$App = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq $Application }
if ($App -ne $null) {
    # Create the Temp folder
    if (-not (Test-Path $TempFolder)) {
        New-Item -ItemType Directory -Path $TempFolder
    }
    Write-Host "Uninstalling GlobalProtect"
    $App.Uninstall() | Out-File $logfile
}