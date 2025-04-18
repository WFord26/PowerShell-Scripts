# Define the registry path
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"

# Check if the PKCS key exists, if not, create it
if (-not (Test-Path $regPath)) {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms" -Name "PKCS" -Force
}

# Define the name and value for the DWORD
$dwordName = "ClientMinKeyBitLength"
$dwordValue = 2048  # Replace with the desired minimum key length in bits

# Set the DWORD value
New-ItemProperty -Path $regPath -Name $dwordName -Value $dwordValue -PropertyType DWORD -Force

# Output the result
Write-Output "Registry key and value have been set successfully."