# Import the CSV file
$csv = Import-Csv -Path "C:\Temp\Permissions.csv"

# SharePoint Admin URL
$sharepointAdminUrl = "https://yourtenant-admin.sharepoint.com"
Function Connect-TeamsAdmimnistration {
# Check if Microsoft Teams PowerShell module is installed
    if (-not (Get-Module -ListAvailable -Name MicrosoftTeams)) {
        Install-Module -Name MicrosoftTeams -Force -AllowClobber
    }
    # Import the Microsoft Teams module
    Import-Module MicrosoftTeams

    # Connect to Microsoft Teams
    Connect-MicrosoftTeams
}
Function Connect-SharePointAdmin {
    param (
        [Parameter(Mandatory=$true)]
        [string]$sharepointAdminUrl
    )
    # Check if SharePoint Online PowerShell module is installed
    if (-not (Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
        Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force -AllowClobber
    }   
    # Import the SharePoint Online module
    Import-Module Microsoft.Online.SharePoint.PowerShell

    # Connect to SharePoint Online
    Connect-SPOService -Url $sharepointAdminUrl
}

# Check if any entry in the CSV has the Permission "Visitor"
if ($csv | Where-Object { $_.site -like "*sharepoint.com*" }) {
    Connect-SharePointAdmin -sharepointAdminUrl $sharepointAdminUrl
}
Connect-TeamsAdmimnistration

# Loop through each entry in the CSV
foreach ($entry in $csv) {
    $email = $entry.Email
    $permission = $entry.Permission
    $site = $entry.Site

    if ($site -like "*sharepoint.com*") {
        $siteUrl = $site
        # Add user to SharePoint site
        $userSPO = Get-SPOUser -Site $siteUrl -LoginName $email -ErrorAction SilentlyContinue
        if ($permission -eq "Visitor") {
            Add-SPOUser -Site $siteUrl -LoginName $email -Group "Visitors"
        }elseif ($permission -eq "Owner") {
            Add-SPOUser -Site $siteUrl -LoginName $email -Group "Owners"
        } elseif ($permission -eq "Member") {
            Add-SPOUser -Site $siteUrl -LoginName $email -Group "Members"
        }
    } else {
        # Add user to Microsoft Teams
        if ($permission -eq "Owner") {
            Add-TeamUser -GroupId (Get-Team -MailNickName $site).GroupId -User $email -Role Owner
        } elseif ($permission -eq "Member") {
            Add-TeamUser -GroupId (Get-Team -MailNickName $site).GroupId -User $email -Role Member
        }
    }
}