function Get-UniqueFilePermissions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )
    # Create a new directory to store the permissions files
    if (-not (Test-Path "$Path\Permissions")) {
        Write-Host "Creating Permissions directory"
        New-Item -Path "$Path\Permissions" -ItemType Directory
    }

    # Get all the permissions files in the directory
    $permissionsFiles = Get-ChildItem -Path "$Path\RawData" -Recurse -File -Filter "permissions*.csv"

    # Create an array to store the combined permissions
    $combinedPermissions = @()

    foreach ($file in $permissionsFiles) {
        # Get the share name
        $rootFolder = $file.FullName.Split("\")[-1]
        $rootFolder = $rootFolder.Substring(12, $rootFolder.Length - 16)
                
        # Get the unique permissions
        $uniquePermissions = Import-Csv -Path $file | Sort-Object IdentityReference, FileSystemRights -Unique

        # Export the unique permissions to a new file
        $uniquePermissions | Export-Csv -Path "$Path\Permissions\unique_Permissions_$($rootFolder).csv" -NoTypeInformation
    }

    $uniquePermissionsFiles = Get-ChildItem -Path "$Path" -Recurse -File -Filter "unique_Permissions*.csv"

    # Import Group Memberships CSV
    $groupMemberships = Import-Csv -Path "$Path\group_memberships*.csv"

    

    # Get the unique permissions for each file, and get the members of the group
    foreach ($file in $uniquePermissionsFiles) {
        # Get the share name
        $rootFolder = $file.FullName.Split("\")[-1]
        $rootFolder = $rootFolder.Substring(18, $rootFolder.Length - 22)
        
        $uniquePermissionsCSV = Import-Csv -Path $file
        # Create an array to store the users permissions
        $usersPermissions = @()
        foreach ($permission in $uniquePermissionsCSV) {
            $group = $permission.IdentityReference
            $group = $group.Split("\")[-1]

            # Get the members of the group from the group memberships CSV (GroupName, MemberName, MemberSamAccountName, EmailAddress, MemberType) one row per user/computer
            $members = $groupMemberships | Where-Object { $_.GroupName -eq $group } | Select-Object -ExpandProperty MemberSamAccountName
            
            # Loop through the members and add the permissions to the usersPermissions array
            foreach ($member in $members) {
                
                $usersPermissions += [PSCustomObject]@{
                    Member = $member
                    Folder = $permission.FolderName
                    FileSystemRights = $permission.FileSystemRights
                    AccessControlType = $permission.AccessControlType
                }
            }
        }
        # Export the users permissions to a new file
        $usersPermissions | Export-Csv -Path "$Path\Permissions\users_Permissions_$($rootFolder).csv" -NoTypeInformation
    }
}