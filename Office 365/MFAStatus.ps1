<#
.EXAMPLE
  Get-MFAStatus

  Get the MFA Status of all enabled and licensed users and check if there are an admin or not

.EXAMPLE
  Get-MFAStatus -UserPrincipalName 'johndoe@contoso.com','janedoe@contoso.com'

  Get the MFA Status for the users John Doe and Jane Doe

.EXAMPLE
  Get-MFAStatus -withOutMFAOnly

  Get only the licensed and enabled users that don't have MFA enabled

.EXAMPLE
  Get-MFAStatus -adminsOnly

  Get the MFA Status of the admins only

.EXAMPLE
  Get-MsolUser -Country "NL" | ForEach-Object { Get-MFAStatus -UserPrincipalName $_.UserPrincipalName }

  Get the MFA status for all users in the Country The Netherlands. You can use a similar approach to run this
  for a department only.

.EXAMPLE
  Get-MFAStatus -withOutMFAOnly | Export-CSV c:\temp\userswithoutmfa.csv -noTypeInformation

  Get all users without MFA and export them to a CSV file
#>
Function Get-MFAStatus {
[CmdletBinding(DefaultParameterSetName="Default")]
param(
  [Parameter(
    Mandatory = $false,
    ParameterSetName  = "UserPrincipalName",
    HelpMessage = "Enter a single UserPrincipalName or a comma separated list of UserPrincipalNames",
    Position = 0
    )]
  [string[]]$UserPrincipalName,

  [Parameter(
    Mandatory = $false,
    ValueFromPipeline = $false,
    ParameterSetName  = "AdminsOnly"
  )]
  # Get only the users that are an admin
  [switch]$adminsOnly = $false,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $false,
    ParameterSetName  = "AllUsers"
  )]
  # Set the Max results to return
  [int]$MaxResults = 10000,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $false,
    ParameterSetName  = "Licensed"
  )]
  # Check only the MFA status of users that have license
  [switch]$IsLicensed = $true,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true,
    ParameterSetName  = "withOutMFAOnly"
  )]
  # Get only the users that don't have MFA enabled
  [switch]$withOutMFAOnly = $false,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $false
  )]
  # Check if a user is an admin. Set to $false to skip the check
  [switch]$listAdmins
)



# Connect to Msol
if ($null -eq (Get-Module -ListAvailable -Name MSOnline))
{
  Write-Host "MSOnline Module is required, do you want to install it?" -ForegroundColor Yellow
      
  $install = Read-Host Do you want to install module? [Y] Yes [N] No 
  if($install -match "[yY]") 
  { 
    Write-Host "Installing MSOnline module" -ForegroundColor Cyan
    Install-Module MSOnline -Repository PSGallery -AllowClobber -Force
  } 
  else
  {
	  Write-Error "Please install MSOnline module."
  }
}

if ($null -ne (Get-Module -ListAvailable -Name MSOnline))
{
  if(-not (Get-MsolDomain -ErrorAction SilentlyContinue))
  {
    if ($Host.Version.Major -eq 7) {
      Import-Module MSOnline -UseWindowsPowershell
    }
    Connect-MsolService
  }
}
else{
  Write-Error "Please install Msol module."
}
  
# Get all licensed admins
$admins = $null

if (($listAdmins) -or ($adminsOnly)) {
  $admins = Get-MsolRole | %{$role = $_.name; Get-MsolRoleMember -RoleObjectId $_.objectid} | Where-Object {$_.isLicensed -eq $true} | select @{Name="Role"; Expression = {$role}}, DisplayName, EmailAddress, ObjectId | Sort-Object -Property EmailAddress -Unique
}

# Check if a UserPrincipalName is given
# Get the MFA status for the given user(s) if they exist
if ($PSBoundParameters.ContainsKey('UserPrincipalName')) {
  foreach ($user in $UserPrincipalName) {
		try {
      $MsolUser = Get-MsolUser -UserPrincipalName $user -ErrorAction Stop

      $Method = ""
      $MFAMethod = $MsolUser.StrongAuthenticationMethods | Where-Object {$_.IsDefault -eq $true} | Select-Object -ExpandProperty MethodType

      If (($MsolUser.StrongAuthenticationRequirements) -or ($MsolUser.StrongAuthenticationMethods)) {
        Switch ($MFAMethod) {
            "OneWaySMS" { $Method = "SMS token" }
            "TwoWayVoiceMobile" { $Method = "Phone call verification" }
            "PhoneAppOTP" { $Method = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $Method = "Authenticator app" }
        }
      }

      [PSCustomObject]@{
        DisplayName       = $MsolUser.DisplayName
        UserPrincipalName = $MsolUser.UserPrincipalName
        isAdmin           = if ($listAdmins -and $admins.EmailAddress -match $MsolUser.UserPrincipalName) {$true} else {"-"}
        MFAEnabled        = if ($MsolUser.StrongAuthenticationMethods) {$true} else {$false}
        MFAType           = $Method
				MFAEnforced       = if ($MsolUser.StrongAuthenticationRequirements) {$true} else {"-"}
        "Email Verification" = if ($MsolUser.StrongAuthenticationUserDetails.Email) {$MsolUser.StrongAuthenticationUserDetails.Email} else {"-"}
        "Registered phone" = if ($MsolUser.StrongAuthenticationUserDetails.PhoneNumber) {$MsolUser.StrongAuthenticationUserDetails.PhoneNumber} else {"-"}
      }
    }
		catch {
			[PSCustomObject]@{
				DisplayName       = " - Not found"
				UserPrincipalName = $User
				isAdmin           = $null
				MFAEnabled        = $null
			}
		}
  }
}
# Get only the admins and check their MFA Status
elseif ($adminsOnly) {
  foreach ($admin in $admins) {
    $MsolUser = Get-MsolUser -ObjectId $admin.ObjectId | Sort-Object UserPrincipalName -ErrorAction Stop

    $MFAMethod = $MsolUser.StrongAuthenticationMethods | Where-Object {$_.IsDefault -eq $true} | Select-Object -ExpandProperty MethodType
    $Method = ""

    If (($MsolUser.StrongAuthenticationRequirements) -or ($MsolUser.StrongAuthenticationMethods)) {
        Switch ($MFAMethod) {
            "OneWaySMS" { $Method = "SMS token" }
            "TwoWayVoiceMobile" { $Method = "Phone call verification" }
            "PhoneAppOTP" { $Method = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $Method = "Authenticator app" }
        }
      }
    
    [PSCustomObject]@{
      DisplayName       = $MsolUser.DisplayName
      UserPrincipalName = $MsolUser.UserPrincipalName
      isAdmin           = $true
      "MFA Enabled"     = if ($MsolUser.StrongAuthenticationMethods) {$true} else {$false}
      "MFA Default Type"= $Method
      "SMS token"       = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "OneWaySMS") {$true} else {"-"}
      "Phone call verification" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "TwoWayVoiceMobile") {$true} else {"-"}
      "Hardware token or authenticator app" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "PhoneAppOTP") {$true} else {"-"}
      "Authenticator app" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "PhoneAppNotification") {$true} else {"-"}
      "Email Verification" = if ($MsolUser.StrongAuthenticationUserDetails.Email) {$MsolUser.StrongAuthenticationUserDetails.Email} else {"-"}
      "Registered phone" = if ($MsolUser.StrongAuthenticationUserDetails.PhoneNumber) {$MsolUser.StrongAuthenticationUserDetails.PhoneNumber} else {"-"}
			MFAEnforced = if ($MsolUser.StrongAuthenticationRequirements) {$true} else {"-"}
    }
  }
}
# Get the MFA status from all the users
else {
  $MsolUsers = Get-MsolUser -EnabledFilter EnabledOnly -MaxResults $MaxResults | Where-Object {$_.IsLicensed -eq $isLicensed} | Sort-Object UserPrincipalName
    foreach ($MsolUser in $MsolUsers) {

      $MFAMethod = $MsolUser.StrongAuthenticationMethods | Where-Object {$_.IsDefault -eq $true} | Select-Object -ExpandProperty MethodType
      $Method = ""

      If (($MsolUser.StrongAuthenticationRequirements) -or ($MsolUser.StrongAuthenticationMethods)) {
        Switch ($MFAMethod) {
            "OneWaySMS" { $Method = "SMS token" }
            "TwoWayVoiceMobile" { $Method = "Phone call verification" }
            "PhoneAppOTP" { $Method = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $Method = "Authenticator app" }
        }
      }

      if ($withOutMFAOnly) {
        # List only the user that don't have MFA enabled
        if (-not($MsolUser.StrongAuthenticationMethods)) {

          [PSCustomObject]@{
            DisplayName       = $MsolUser.DisplayName
            UserPrincipalName = $MsolUser.UserPrincipalName
            isAdmin           = if ($listAdmins -and ($admins.EmailAddress -match $MsolUser.UserPrincipalName)) {$true} else {"-"}
            MFAEnabled        = $false
            MFAType           = "-"
						MFAEnforced       = if ($MsolUser.StrongAuthenticationRequirements) {$true} else {"-"}
            "Email Verification" = if ($MsolUser.StrongAuthenticationUserDetails.Email) {$MsolUser.StrongAuthenticationUserDetails.Email} else {"-"}
            "Registered phone" = if ($MsolUser.StrongAuthenticationUserDetails.PhoneNumber) {$MsolUser.StrongAuthenticationUserDetails.PhoneNumber} else {"-"}
          }
        }
      }else{
        [PSCustomObject]@{
          DisplayName       = $MsolUser.DisplayName
          UserPrincipalName = $MsolUser.UserPrincipalName
          isAdmin           = if ($listAdmins -and ($admins.EmailAddress -match $MsolUser.UserPrincipalName)) {$true} else {"-"}
          "MFA Enabled"     = if ($MsolUser.StrongAuthenticationMethods) {$true} else {$false}
          "MFA Default Type"= $Method
          "SMS token"       = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "OneWaySMS") {$true} else {"-"}
          "Phone call verification" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "TwoWayVoiceMobile") {$true} else {"-"}
          "Hardware token or authenticator app" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "PhoneAppOTP") {$true} else {"-"}
          "Authenticator app" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "PhoneAppNotification") {$true} else {"-"}
          "Email Verification" = if ($msoluser.StrongAuthenticationUserDetails.Email) {$msoluser.StrongAuthenticationUserDetails.Email} else {"-"}
          "Registered phone" = if ($msoluser.StrongAuthenticationUserDetails.PhoneNumber) {$msoluser.StrongAuthenticationUserDetails.PhoneNumber} else {"-"}
					MFAEnforced       = if ($MsolUser.StrongAuthenticationRequirements) {$true} else {"-"}
        }
      }
    }
  }
}