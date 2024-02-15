<#
.Synopsis
  Create MAC Authenticated Users in Active Directory

.DESCRIPTION
  This script will do the following.
    - Import a txt or csv file that has a header of mac into the terminal. 
    - For each object in the file it will
        - Checks if Object exist
        - If Object exists, then create an array with parameters for user accounts
        - Creates the AD User
        - Sets user group to defined group and sets it as primary
        - Removes User from Domain Users group.
   
.NOTES
  Name: AddMACAddressUser
  Author: W. Ford
  Version: 1.0
  DateCreated: sep 2023
  Purpose/Change: Adding Parameters

.PARAMETER FilePath
Enter the file location of your MACs text file, with list of MAC address you wish to add.

.PARAMETER Domain
Enter in your local Active Directory domain, like "@contoso.com" or "@contoso.local"

.PARAMETER TicketNumber
Enter in your local Active Directory domain, like "@contoso.com" or "@contoso.local"

.EXAMPLE
  .\AddMACAddressUser.ps1 -FilePath "C:\Temp\MACs.csv" -Domain "@Contoso.local"

#>

param(
  [Parameter(
    Mandatory = $false,
    HelpMessage = "Enter the location of the MAC address txt file."
  )]
  [string]$FilePath = "C:\Temp\MACs.txt",
  
  [Parameter(
    Mandatory = $false,
    HelpMessage = "Enter in your Active Directory Domain"
  )]
  [string]$Domain = "@mtnmanit.local",

   [Parameter(
    Mandatory = $true,
    HelpMessage = "Enter in a corresponding ticket number for this request"
  )]
  [string]$TicketNumber
)

$todaysDate = Get-Date

Import-Csv $FilePath -Encoding UTF8 | Foreach-Object {
    $MACAddressString = $_.mac.ToString()
    $MACAddress = $MACAddressString.ToUpper()
    # Runs Check to see if user is in AD already
    if($null -eq ([ADSISearcher] "(sAMAccountName=$MACAddress)").FindOne()){
            # If user is not in AD 
            # Creates a Secure String equal to the User name.
            $SecurePass = ConvertTo-SecureString -String $MACAddress -AsPlainText -Force
            # Creates an Array with parameters for user creation.
            $splat = @{
                name = $MACAddress
                samAccount = $MACAddress
                Surname = "Terminal"
                AccountPassword = $SecurePass
                Enabled = $true
                Path ="OU=Terminals,DC=mtnmanit,DC=local"
                UserPrincipalName = $MACAddress+$Domain
                PasswordNeverExpires = $true
                AllowReversiblePasswordEncryption  =$true
                CannotChangePassword = $true
                AccountExpirationDate = $todaysDate.AddDays(365)
                Description = "Date Added: $todaysDate, Created By: $Env:UserName, Ticket #: $ticketNumber "
            }
            # Creates the User in AD
            New-ADUser @splat
            # Set user group membership to predefined Security Group
            $group = get-adgroup "Terminals" -properties @("primaryGroupToken")
            Add-ADGroupMember -Identity $group -Members $MACAddress
            # Sets predefined group as Primary Group
            get-aduser $MACAddress | set-aduser -replace @{primaryGroupID=$group.primaryGroupToken}
            # Removes device from Domain Users group.
            remove-adgroupmember -Identity "Domain Users" -Member $MACAddress
            
        } else {
            Write-Host "User $MACAddress exists in AD" -ForegroundColor red
            Get-ADUser $MACAddress -Properties Name,Created,AccountExpirationDate,Description
        }

    }