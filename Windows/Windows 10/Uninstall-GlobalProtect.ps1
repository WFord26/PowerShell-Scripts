# Variables
$TempFolder = "C:\Temp_GP"
$logfile = "$TempFolder\output.log"

# Check if Application is already installed, if it is installed uninstall it.
$App = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*GlobalProtect*" }
if ($App -ne $null) {
    # Create the Temp folder
    if (-not (Test-Path $TempFolder)) {
        New-Item -ItemType Directory -Path $TempFolder
    }
    # Close GlobalProtect
    Write-Host "Closing GlobalProtect"
    Stop-Process -Name "PanGPA" -Force
    Write-Host "Uninstalling GlobalProtect"
    $App.Uninstall() | Out-File $logfile
}

# Ask to reboot


# Variables
$TempFolder = "C:\Temp_GP"
$logfile = "$TempFolder\output.log"

# Check if Application is already installed, if it is installed uninstall it.
$App = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*GlobalProtect*" }
if ($App -ne $null) {
    # Create the Temp folder
    if (-not (Test-Path $TempFolder)) {
        New-Item -ItemType Directory -Path $TempFolder
    }
    Write-Host "Uninstalling GlobalProtect"
    $App.Uninstall() | Out-File $logfile
}