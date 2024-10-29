# PFX Passwords
$PWD_Device = "MulF!l4CertJuly"
# Device Certificate File Path
$DV_FILE_PATH  = "\\itsupport\Programs\Certificates\DeviceCertificate.p12"
# Device Certificate Temp Folder Path
$TempFolder = "C:\Temp"
# Device Certificate URL
$FileURL = "https://download.bnmg.net/DeviceCertificate2024.p12"
# Get current computer personal certificates and store in an array.
$CurrentCerts = Get-ChildItem -Path Cert:\LocalMachine\My
# Old Device Certificate Thumbprint
# This is the original thumbprint of certificate that was deployed in 2023, this may need to be updated
$OLD_DV_THUMBPRINT = "BB002546709438328302A965AAA812B8A22564CA" 
# New Device Certificate Thumbprint
$NEW_DV_THUMBPRINT = "6CDCB91A620DFDA7ABE9C916B4152A5F0E1EC1BB"
# Create Temp Folder if it does not exist
if (-not (Test-Path $TempFolder)) {
    New-Item -ItemType Directory -Path $TempFolder
}
#### 
# Functions Area Begin
####

# Convert Password to Secure String
Function SecString($Pass){
    ConvertTo-SecureString -String $Pass -AsPlainText -Force
}
#Import PFX
Function ImportPFX($CertObject){
    Import-PfxCertificate -Password $CertObject.SecPassword -CertStoreLocation $CertObject.CertStore -FilePath $CertObject.File
}

####
# Functions Area End
####
$NewDeviceCert = $CurrentCerts | Where-Object { $_.Thumbprint -eq $NEW_DV_THUMBPRINT }
if ($NewDeviceCert -eq $null) {
    # Download the Device Certificate File
    Invoke-WebRequest -Uri $FileURL -OutFile "$TempFolder\DeviceCertificate2024.p12"
    # Device Certificate Object is created from File path and Password to the Local Machine Personal Store.
    $DV_Object = New-Object -TypeName PSObject -Property @{
        "SecPassword" = SecString($PWD_Device)
        "CertStore" = 'Cert:\LocalMachine\My'
        "File" = "$TempFolder\DeviceCertificate2024.p12"
    }
    # Import the Device Certificate to the Local Machine Personal Store
    ImportPFX($DV_Object)
} else {
    Write-Host "Device Certificate is already installed."
}
