# Export all the security groups in Active Directory to a CSV file
# Export the membership of each security group to a CSV file



# Import the Active Directory module
Import-Module ActiveDirectory

# Get Domain Name
$domain = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName

# Replace the DC= part of the domain name
$domain = $domain -replace 'DC=', '' -replace ',', '.'

# Export all AD users to a CSV file
Get-ADUser -Filter * -Properties * | Export-Csv -Path "C:\Temp\01 - $domain - Users.csv" -NoTypeInformation

# Get all the security groups in Active Directory
$groups = Get-ADGroup -Filter {GroupCategory -eq 'Security'} -Properties Name, GroupCategory, GroupScope


# Create C:\Temp if it doesn't exist
if (-not (Test-Path -Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory
}


# Export the security groups to a CSV file
$groups | Export-Csv -Path "C:\Temp\02 - $domain - SecurityGroups.csv" -NoTypeInformation

# Loop through each security group
foreach ($group in $groups) {
    # Get the members of the security group
    $members = Get-ADGroupMember -Identity $group.Name

    # Export the members of the security group to a CSV file
    $members | Select-Object @{Name='GroupName';Expression={$group.Name}}, Name, SamAccountName | Export-Csv -Path "C:\Temp\Security Groups\$($domain)-$($group.Name)_Members.csv" -NoTypeInformation
}


# Combine all the membership CSV files into one CSV file
Get-ChildItem -Path "C:\Temp" -Filter "*_Members.csv" | ForEach-Object {
    Import-Csv -Path $_.FullName | Export-Csv -Path "C:\Temp\02 - $domain - SecurityGroupMembers.csv" -Append -NoTypeInformation
}

