# Create Office Account
# Add License

param(
  [Parameter(
    Mandatory = $true,
    HelpMessage = "Enter path to your csv file."
  )]
  [string]$csvFile
)

$importedFile = Import-Csv -Path $csvFile
$importedFile | ForEach-Object {
    $NewPassword = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $NewPassword.Password = $_.Password
    New-AzureADUser -UserPrincipalName $_.UserPrincipalName -DisplayName $_.Name -PasswordProfile $NewPassword -AccountEnabled $True -MailNickName $_.NameSpaceRemoved -CompanyName "Request Foods"  -Surname $_.Lastname -GivenName $_.FirstName -UsageLocation "US"
    $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
    $License.SkuId = $_.SkuId
    $LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    $LicensesToAssign.AddLicenses = $License
    Set-AzureADUserLicense -ObjectId $_.UserPrincipalName -AssignedLicenses $LicensesToAssign
}

