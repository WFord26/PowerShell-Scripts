# Disable Bitlocker on a drive

$drive = "C:"
$volume = Get-WmiObject -Namespace "root\cimv2\security\microsoftvolumeencryption" -Class Win32_EncryptableVolume | Where-Object {$_.DriveLetter -eq $drive}

if ($volume -eq $null) {
    Write-Host "No Bitlocker volume found on drive $drive"
    exit
} else (
    $volume.DisableKeyProtectors()
    $volume.DecryptBitlocker()
    Write-Host "Bitlocker disabled on drive $drive"
)

# disable local GPO settings that require additional authentication at startup


Computer Configuration\Administrative Templates\Windows Components\BitLocker Drive Encryption\Operating System Drives\Require additional authentication at startup - Disabled

HKLM\SOFTWARE\Policies\Microsoft\FVE!UseAdvancedStartup 
HKLM\SOFTWARE\Policies\Microsoft\FVE!EnableBDEWithNoTPM 
HKLM\SOFTWARE\Policies\Microsoft\FVE!UseTPMKey 
HKLM\SOFTWARE\Policies\Microsoft\FVE!UseTPMPIN 
HKLM\SOFTWARE\Policies\Microsoft\FVE!UseTPMKeyPIN 
HKLM\SOFTWARE\Policies\Microsoft\FVE!UseTPM