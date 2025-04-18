function Export-UserAndGroups{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$logfile,
        [Parameter(Mandatory=$false)]
        [string]$domain,
        [Parameter(Mandatory=$false)]
        [string]$outputFolder,
        [Parameter(Mandatory=$false)]
        [string]$hostname
    )

    # Get the hostname of the local machine
    if ($null -eq $hostname){
        $hostname = hostname
    }

    # Check if the domain is null
    if ($null -eq $domain){
        if (-not (Get-Module -Name ActiveDirectory)) {
            Write-Host "The Active Directory module is not installed."
            $domain = Read-Host "Enter the domain name: (Example: example.com)"
        } else{
            # Get Domain Name
            $domain = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName
        
            # Replace the DC= part of the domain name
            $domain = $domain -replace 'DC=', '' -replace ',', '.'
        }
    }

    # If the output folder is not specified, use C:\Temp\$($domain)_WinServer_Assessment
    if ($null -eq $outputFolder){
        # Define the Output folder
        $outputFolder = "C:\Temp\$($domain)_WinServer_Assessment"
    }

    # Find the Primary Domain Controller
    $primaryDomainController = (Get-ADDomainController -Discover -Service PrimaryDC).HostName
    $primaryDomainController = $primaryDomainController -replace ".$domain", ""


    # Create the RawData directory if it doesn't exist
    if (-not (Test-Path -Path "RawData")) {
        New-Item -Path "$(outputFolder)\RawData" -ItemType Directory
        if ($logfile) {
            Add-Content -Path $logfile -Value "Created RawData directory"
        }
    }

    Set-Location -Path $outputFolder
        
    # Get the Users and Groups
    # Get the Users
    if ($hostname -ne $primaryDomainController) {
        $domainUsers = Invoke-Command -ComputerName $primaryDomainController {Get-ADUser -Filter *}
    } else {
        $domainUsers = Get-ADUser -Filter *
    }
    $domainUsers | Select-Object -Property Name, SamAccountName, UserPrincipalName, DistinguishedName, Enabled, PasswordNeverExpires, PasswordExpired, PasswordLastSet, PasswordAge, PasswordExpires, LastLogonDate, LastLogonTimeStamp, AccountExpirationDate, AccountLockoutTime, AccountLockoutDuration, AccountLockoutThreshold, PSComputerName | Export-Csv -Path "domain_users_$($domain).csv" -NoTypeInformation
    if ($logfile) {
        Add-Content -Path $logfile -Value "Exported domain users to RawData\domain_users_$($domain).csv from PDC: $($primaryDomainController)"
    }

    Write-Host "Exporting domain groups for $($domain):" -nonewline
    # Get the Groups
    if ($hostname -ne $primaryDomainController) {
        $domainGroups = Invoke-Command -ComputerName $primaryDomainController {Get-ADGroup -Filter *}
    } else {
        $domainGroups = Get-ADGroup -Filter *
    }
    $domainGroups | Select-Object -Property Name, SamAccountName, DistinguishedName, GroupCategory, GroupScope, Members, PSComputerName | Export-Csv -Path "domain_groups_$($domain).csv" -NoTypeInformation
    if ($logfile) {
        Add-Content -Path $logfile -Value "Exported domain groups to RawData\domain_groups_$($domain).csv from PDC: $($primaryDomainController)"
    }
    write-host " Done." -ForegroundColor Green

    # Get the Group Membership
    Write-Host "Exporting group memberships for $($domain):" -nonewline
    $groupMemberships = @()
    foreach ($group in $domainGroups) {
        if ($hostname -ne $primaryDomainController) {
            $members = Invoke-Command -ComputerName $primaryDomainController {Get-ADGroupMember -Identity $using:group.SamAccountName}
        } else {
            $members = Get-ADGroupMember -Identity $group.SamAccountName
        }
        foreach ($member in $members) {
            $groupMemberships += [PSCustomObject]@{
                GroupName = $group.Name
                MemberName = $member.Name
                MemberSamAccountName = $member.SamAccountName
                EmailAddress = $member.UserPrincipalName
                MemberType = $member.ObjectClass
            }
        }
    }

    $groupMemberships | Export-Csv -Path "group_memberships_$($domain).csv" -NoTypeInformation
    if ($logfile) {
        Add-Content -Path $logfile -Value "Exported group memberships to RawData\group_memberships_$($domain).csv from PDC: $($primaryDomainController)"
    }
    write-host " Done." -ForegroundColor Green

}