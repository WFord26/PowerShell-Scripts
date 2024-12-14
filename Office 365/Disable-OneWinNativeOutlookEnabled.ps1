<#
.SYNOPSIS
    This script disables the OneWinNativeOutlookEnabled property for all mailboxes in Exchange Online that are set to $True.

.DESCRIPTION
    This script disables the OneWinNativeOutlookEnabled property for all mailboxes in Exchange Online that are set to $True.
    Based on: https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/outlook-on-the-web/enable-disable-employee-access-new-outlook

.NOTES
    File Name      : Disable-OneWinNativeOutlookEnabled.ps1
    Author         : William Ford
    Prerequisite   : Exchange Online Management Module
    Version        : 1.0
    Date           : 12/4/2024

.EXAMPLE
    .\Disable-OneWinNativeOutlookEnabled.ps1
    This command will disable the OneWinNativeOutlookEnabled property for all mailboxes in Exchange Online that are set to $True.
#>

# Define the UPN of an Exchange Online administrator
$adminUPN = "admin@domain.com"

function EXO-Connect {
    param (
        [string]$UserPrincipalName
    )
    # Check if Exchange Online Management Module is installed
    if (-not (Get-Module -Name ExchangeOnlineManagement -ListAvailable)) {
        # Install the Exchange Online Management Module
        Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    }

    # Import the Exchange Online Management Module
    Import-Module ExchangeOnlineManagement

    # Connect to Exchange Online
    Connect-ExchangeOnline -UserPrincipalName $UserPrincipalName
}
Function Disable-OneWinNativeOutlookEnabled {
    # Store all mailboxes in a variable
    $mailboxes = Get-Mailbox -ResultSize Unlimited
    # Loop through all mailboxes
    foreach ($mailbox in $mailboxes) {
        # Check if the mailbox has the OneWinNativeOutlookEnabled property set to $true
        if ($mailbox.OneWinNativeOutlookEnabled -eq $true) {
            # Disable the OneWinNativeOutlookEnabled property
            Set-CASMailbox -Identity $mailbox.Identity -OneWinNativeOutlookEnabled $false
        }
    }
}

EXO-Connect -UserPrincipalName $adminUPN
Disable-OneWinNativeOutlookEnabled
# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
# End of script
```