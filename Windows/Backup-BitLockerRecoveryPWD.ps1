#region Backup and Encrypt
# Location of Backup File
$BackupFile = "\\SomeNetworkShare\" + $env:COMPUTERNAME + ".json"

# Encryption Key
# If password
$PWD = "SomePassword"
# If Key File
$keyFile = "C:\SomeFolder\SomeKeyFile.key"

try {
    # Get all the BitLocker Drives
    $Drives = Get-BitLockerVolume
    if ($null -eq $Drives) {
        Write-Error "BitLocker is not installed on this system"
    }
    # Create an Empty Array for Passwords to be saved. 
    $BitLockerNumericalPassword = @()
} catch {
    Write-Error "BitLocker is not installed on this system"
}

# Backup and Encrypt the BitLocker Information
try {
    # For Each Drive, get the numerical password
    foreach ($Drive in $Drives) {
        $BitLockerRecoveryPassword = Get-BitLockerVolume -MountPoint $Drive.MountPoint | Select-Object -ExpandProperty KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' } | Select-Object -ExpandProperty RecoveryPassword
        $BitLockerNumericalPassword = Get-BitLockerVolume -MountPoint $Drive.MountPoint | Select-Object -ExpandProperty KeyProtector | Where-Object { $_.KeyProtectorType -eq 'NumericalPassword' } | Select-Object -ExpandProperty NumericalPassword
        $mountPoint = $Drive.MountPoint

        # Create a Hash Table to store the BitLocker information
        $bitLockerInfo = @{
            MountPoint = $mountPoint
            NumericalPassword = $BitLockerNumericalPassword
            RecoveryPassword = $BitLockerRecoveryPassword
        }
        $BitLockerNumericalPassword += $bitLockerInfo

        # Clear the BitLocker Recovery Password
        $BitLockerRecoveryPassword = $null
    }
    if ($PWD) {
        # Create a consistent encryption key from the password
        $encPwd = [System.Text.Encoding]::UTF8.GetBytes($Pwd)
        # Ensure the key is exactly 16, 24, or 32 bytes long (AES key size requirement)
        if ($encPwd.Length -ne 16 -and $encPwd.Length -ne 24 -and $encPwd.Length -ne 32) {
            $sha = New-Object System.Security.Cryptography.SHA256Managed
            $encPwd = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Pwd))
        }
        # Export the BitLocker Information to a json file and encrypt it with a password
        $jsonFile = $BitLockerNumericalPassword | ConvertTo-Json

        # Clear the BitLocker Information
        $BitLockerNumericalPassword = $null

        # If Password is used
        $jsonFile | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $encPwd | Set-Content $BackupFile
    } elseif ($keyFile) {
        # If Key File is used
        $keyBytes = Get-Content $keyFile -AsByteStream
        # Ensure the key is exactly 16, 24, or 32 bytes long (AES key size requirement)
        if ($keyBytes.Length -ne 16 -and $keyBytes.Length -ne 24 -and $keyBytes.Length -ne 32) {
            $sha = New-Object System.Security.Cryptography.SHA256Managed
            $keyBytes = $sha.ComputeHash($keyBytes)
        }
        $jsonFile = $BitLockerNumericalPassword | ConvertTo-Json
        $jsonFile | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $keyBytes | Set-Content $BackupFile
    }

} catch {
    Write-Error "Failed to backup BitLocker information"
}
#endregion



#region Decrypt 
# Decrypt the BitLocker Backup File
try {
    # If Password was used for encryption
    if ($Pwd) {
        # Re-create the same encryption key from the password
        $encPwd = [System.Text.Encoding]::UTF8.GetBytes($Pwd)
        # Ensure the key is exactly 16, 24, or 32 bytes long (AES key size requirement)
    } elseif (Test-Path $keyFile) {
        # If Key File was used for encryption
        $keyBytes = Get-Content $keyFile -AsByteStream
        # Ensure the key is exactly 16, 24, or 32 bytes long (AES key size requirement)
        if ($keyBytes.Length -ne 16 -and $keyBytes.Length -ne 24 -and $keyBytes.Length -ne 32) {
            $sha = New-Object System.Security.Cryptography.SHA256Managed
            $keyBytes = $sha.ComputeHash($keyBytes)
        }
        $decryptedContent = Get-Content $BackupFile | ConvertTo-SecureString -Key $keyBytes | ConvertFrom-SecureString -AsPlainText
        $recoveryInfo = $decryptedContent | ConvertFrom-Json
        Write-Host "Successfully decrypted BitLocker backup using key file"
    }
        $keyBytes = Get-Content $keyFile -AsByteStream
        $decryptedContent = Get-Content $BackupFile | ConvertTo-SecureString -Key $keyBytes | ConvertFrom-SecureString -AsPlainText
        $recoveryInfo = $decryptedContent | ConvertFrom-Json
        Write-Host "Successfully decrypted BitLocker backup using key file"
} catch {
    Write-Error "Failed to decrypt the backup file: $_"
}
#endregion