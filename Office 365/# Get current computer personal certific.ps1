# Get current computer personal certificates and store in an array.
$CurrentCerts = Get-ChildItem -Path Cert:\LocalMachine\My
# Old Device Certificate Thumbprint
# This is the original thumbprint of certificate that was deployed in 2023, this may need to be updated
$OLD_DV_THUMBPRINT = "BB002546709438328302A965AAA812B8A22564CA" 
# New Device Certificate Thumbprint
$NEW_DV_THUMBPRINT = "6CDCB91A620DFDA7ABE9C916B4152A5F0E1EC1BB"

# Check if the new device certificate is installed on the computer  
$NewDeviceCert = $CurrentCerts | Where-Object { $_.Thumbprint -eq $NEW_DV_THUMBPRINT }
if ($null -eq $NewDeviceCert) {
    Write-Host "New Device Certificate is not installed on the computer." -ForegroundColor Red
    Write-Host "Please run the Device Certificate Deployment script first." -ForegroundColor Red    
    Exit-PSSession
    # Check if device has network access to file share \\itsupport\Programs\Certificates
} else {
    Write-Host "New Device Certificate is installed on the computer."
    # Check if the old device certificate is installed on the computer
    $OldDeviceCert = $CurrentCerts | Where-Object { $_.Thumbprint -eq $OLD_DV_THUMBPRINT }
    if ($null -ne $OldDeviceCert) {
        Write-Host "Old Device Certificate is installed on the computer."
        # Remove the old device certificate from the computer
        Remove-Item -Path Cert:\LocalMachine\My\$OLD_DV_THUMBPRINT
        Write-Host "Old Device Certificate has been removed from the computer."
    } else {
        Write-Host "Old Device Certificate is not installed on the computer."
    }
}