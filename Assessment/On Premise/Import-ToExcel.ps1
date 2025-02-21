
# Import the Excel module if it doesn't exist install it.
if (-not (Get-Module -Name ImportExcel)) {
    Install-Module -Name ImportExcel -Scope CurrentUser -Force -AllowClobber
} else {
    Import-Module -Name ImportExcel
}

# Create a $env:TEMP excel file
$excelFile = "$env:TEMP\$($domain) - On Premise Assessment.xlsx"

# Remove the file if it exists. 
if (Test-Path -Path $excelFile) {
    Remove-Item -Path $excelFile -Force
}

# Run reports against the Primary Domain Controller (PDC)
#
# SECTION 1: Get the domain information
# Get the domain information
# Export the domain information to a CSV file
$domainInfo = Get-ADDomain -Server $primaryDomainController
Write-Host "Domain information for $($domain):"
$domainInfo | Format-List -Property DistinguishedName, DNSRoot, NetBIOSName, DomainMode, ForestMode, SchemaMaster, DomainController, PDCEmulator, RIDMaster, InfrastructureMaster, GlobalCatalog, PSComputerName | Format-Table -AutoSize
$domainInfo | Select-Object -Property DistinguishedName, DNSRoot, NetBIOSName, DomainMode, ForestMode, SchemaMaster, DomainController, PDCEmulator, RIDMaster, InfrastructureMaster, GlobalCatalog, PSComputerName | Export-Excel -Path $excelFile -WorksheetName "Domain" -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow

# SECTION 2: Get the domain users
# Get the domain users
# Export the domain users to a CSV file
if ($hostname -ne $primaryDomainController) {
    $domainUsers = Invoke-Command -ComputerName $primaryDomainController {Get-ADUser -Filter *}
} else {
    $domainUsers = Get-ADUser -Filter *
}
Write-Host "Domain users for $($domain):"
$domainUsers | Select-Object -Property Name, SamAccountName, UserPrincipalName, DistinguishedName, Enabled, PasswordNeverExpires, PasswordExpired, PasswordLastSet, PasswordAge, PasswordExpires, LastLogonDate, LastLogonTimeStamp, AccountExpirationDate, AccountLockoutTime, AccountLockoutDuration, AccountLockoutThreshold, PSComputerName | Export-Excel -Path $execelFile -WorksheetName "Domain User" -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow

# SECTION 3: Get the domain groups
# Get the domain groups
# Export the domain groups to a Excel file
if ($hostname -ne $primaryDomainController) {
    $domainGroups = Invoke-Command -ComputerName $primaryDomainController {Get-ADGroup -Filter *}
} else {
    $domainGroups = Get-ADGroup -Filter *
}
Write-Host "Domain groups for $($domain):"
$domainGroups | Select-Object -Property Name, SamAccountName, DistinguishedName, GroupCategory, GroupScope, Members, PSComputerName | Export-Excel -Path $excelFile -WorksheetName "Domain Groups" -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow

# SECTION 4: Get all group memberships
# Get all group memberships
# Export the group memberships to a excel file
$groupMemberships = @()
foreach ($group in $domainGroups) {
    if ($hostname -ne $primaryDomainController) {
        $members = Invoke-Command -ComputerName $primaryDomainController {Get-ADGroupMember -Identity $using:group.SamAccountName}
    } else {
        $members = Get-ADGroupMember -Identity $group.SamAccountName
    }
    foreach ($member in $members) {
        $groupMemberships += @{
            GroupName = $group.Name
            MemberName = $member.Name
            MemberType = $member.ObjectClass
        }
    }
}
Write-Host "Group memberships for $($domain):"
$groupMemberships | Export-Excel -Path $excelFile -WorksheetName "Group Memberships" -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow

# SECTION 5: Get the domain controllers
# Get the domain computers
# Export the domain computers to a Excel file
$domainControllers | Export-Excel -Path $excelFile -WorksheetName "Domain Controllers" -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow

# SECTION 6: Get the Servers Information that you are Assessing
# Get the servers information
# Export the servers information to a Excel file

# Add Disk Space Information
$serversInfo = Add-Member -InputObject $serversInfo -MemberType NoteProperty -Name "DiskSpace" -Value "" -Force


# Import CSV file for disk space for each server and load it into the serversInfo array
foreach ($server in $servers) {
    $diskSpace = Import-Csv -Path "$outputFolder\RawData\disk_space_$($server).csv"
    # Create a Combined Disk Space String
    # Example: C: 200/250 GB, D: 100/200 GB Free
    $diskSpaceString = ""
    foreach ($disk in $diskSpace) {
        # Convert Bytes to GB
        $disk.FreeSpace = [math]::Round($disk.FreeSpace / 1GB, 2)
        $disk.Size = [math]::Round($disk.Size / 1GB, 2)
        $diskSpaceString += "$($disk.DriveLetter): $($disk.FreeSpace)/$($disk.Size) GB Free, "
    }
}

$serversInfo | Export-Excel -Path $excelFile -WorksheetName "Servers Information" -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow

# SECTION 7: Export Shared Folders
# Import the shared folders CSV files
# Combine the shared folders into one Excel file
# Export the shared folders to a Excel file

# Get all the shared folders CSV files
$sharedFoldersFiles = Get-ChildItem -Path "$outputFolder\RawData" -Filter "shared_folders_*.csv"

# Create an empty array to store the shared folders
$sharedFolders = @()

# Loop through each shared folders CSV file
foreach ($file in $sharedFoldersFiles) {
    # Import the shared folders CSV file
    $sharedFolders += Import-Csv -Path $file.FullName
}

# Export the shared folders to a Excel file
$sharedFolders | Export-Excel -Path $excelFile -WorksheetName "Shared Folders" -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow

# SECTION 8: Import the File Audit CSV files
# Create seperate worksheets for each server
# Export the File Audit to a Excel file

# Get all the File Audit CSV files
$fileAuditFiles = Get-ChildItem -Path "$outputFolder\RawData" -Filter "file_audit_*.csv"
