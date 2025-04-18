# Import the Active Directory module
Import-Module ActiveDirectory

# Get all security groups
$groups = Get-ADGroup -Filter {GroupCategory -eq 'Security'}

# Initialize an array to store the results
$results = @()

# Loop through each group
foreach ($group in $groups) {
    # Get the members of the group
    $members = Get-ADGroupMember -Identity $group -Recursive | Where-Object { $_.objectClass -eq 'user' }
    
    # Loop through each member
    foreach ($member in $members) {
        # Get the user's details
        $user = Get-ADUser -Identity $member -Properties DisplayName, EmailAddress
        
        # Create a custom object with the required properties
        $result = [PSCustomObject]@{
            GroupName   = $group.Name
            UserName    = $user.DisplayName
            EmailAddress = $user.EmailAddress
            UPN = $user.UserPrincipalName
            Status = $user.Enabled
        }
        
        # Add the result to the array
        $results += $result
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\temp\SecurityGroupUsers.csv" -NoTypeInformation