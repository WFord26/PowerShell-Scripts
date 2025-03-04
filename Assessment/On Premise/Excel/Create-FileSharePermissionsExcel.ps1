function Create-FileSharePermissionsExcel {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$share,
        [Parameter(Mandatory = $true)]
        [string]$domain
    )
    # Check if ImportExcel module is installed, if not install it
    if (-not (Get-Module -Name ImportExcel -ListAvailable)) {
        Install-Module -Name ImportExcel -Scope CurrentUser -Force -AllowClobber
    } else {
        Write-Host "ImportExcel module is already installed"
    }
    # Import Module
    Import-Module -Name ImportExcel

    # Excel File
    $ExcelFile = ".\$($domain)_FS_Permissions_$share.xlsx"

    # Get All users Permissions files for $share
    $usersPermissionsFiles = Get-ChildItem -Path "Permissions\users_Permissions__$($share)_*.csv"

    # Loop through each file and get the data
    foreach ($file in $usersPermissionsFiles) {
        $usersPermissions = Import-Csv -Path $file.FullName
        # Check if the file is empty
        if ($usersPermissions.Count -eq 0) {
            continue
        } else{

            $foldername = $file.BaseName
            # Remove users_Permissions__$(share)_ from the filename
            $foldername = $foldername -replace "users_Permissions__$($share)_", ""

            # Add Member Type column
            $usersPermissions | Add-Member -MemberType NoteProperty -Name "Migrate" -Value "" -Force
            $usersPermissions | Export-Excel -Path $ExcelFile -WorksheetName $foldername -TableName $foldername -AutoSize -AutoFilter -Title "$foldername Users Permissions" -TitleBold -TitleSize 16 
        }
    }
}