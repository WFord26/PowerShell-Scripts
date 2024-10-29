# Encrypt or decrypt a drive with Bitlocker on Windows 10/11
# Usage: .\Set-Bitlocker.ps1 -DriveLetter C -Encrypt -Password "password" -RecoveryKeyPath "C:\recovery.key"
# Usage: .\Set-Bitlocker.ps1 -DriveLetter C -Decrypt -Password "password"

param (
    [string]$DriveLetter,
    [switch]$Decrypt = $false,
    [string]$Password,
    [string]$RecoveryKeyPath
)

if ($Encrypt) {
    Write-Host "Encrypting drive $DriveLetter..."
    if ($RecoveryKeyPath) {
        $RecoveryKeyPath = $RecoveryKeyPath + ".BEK"
        Write-Host "Saving recovery key to $RecoveryKeyPath"
    }
    if ($Password) {
        $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        Enable-BitLocker -MountPoint $DriveLetter -EncryptionMethod XtsAes256 -PasswordProtector -Password $SecurePassword -RecoveryKeyPath $RecoveryKeyPath
    } else {
        Enable-BitLocker -MountPoint $DriveLetter -EncryptionMethod XtsAes256 -PasswordProtector -RecoveryKeyPath $RecoveryKeyPath
    }
} elseif ($Decrypt) {
    Write-Host "Decrypting drive $DriveLetter..."
    if ($Password) {
        $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        Disable-BitLocker -MountPoint $DriveLetter -Password $SecurePassword
    } else {
        Disable-BitLocker -MountPoint $DriveLetter
    }
} else {
    Write-Host "Please specify -Encrypt or -Decrypt"
}
