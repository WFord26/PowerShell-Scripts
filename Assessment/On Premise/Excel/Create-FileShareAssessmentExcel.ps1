function Create-FileShareAssessmentExcel {
    [CmdletBinding()]
    param (
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
    $ExcelFile = ".\$($domain)_File_Share_Assessment.xlsx"

    # Clear Variables
    $DomainUsersCSV = $null
    $DomainGroupsCSV = $null
    $DomainGroupsMembersCSV = $null

    # Import Excel File
    $DomainUsersCSV = Import-CSV -Path "domain_users*.csv" 
    $DomainGroupsCSV = Import-CSV -Path "domain_groups*.csv"
    $DomainGroupsMembersCSV = Import-CSV -Path "group_memberships_*.csv"
    $FileSharesCSV = Get-ChildItem -Path "fileaudit_*.csv"
    $UnsupportedCharsCSV = Get-ChildItem -Path "unsupported_filenames_*.csv"


    # Export to Excel
    $DomainUsersCSV | Export-Excel -Path $ExcelFile -WorksheetName "Domain Users" -TableName "Domain Users" -ClearSheet -AutoSize -AutoFilter
    $DomainGroupsCSV | Export-Excel -Path $ExcelFile -WorksheetName "Domain Groups" -TableName "Domain Groups" -AutoSize -AutoFilter
    $DomainGroupsMembersCSV | Export-Excel -Path $ExcelFile -WorksheetName "Domain Groups Members" -TableName "Domain Groups Members" -AutoSize -AutoFilter
    foreach ($FileShare in $FileSharesCSV) {
        $importFileShareCSV = Import-CSV -Path $FileShare.FullName
        # Get Filename from CSV file name, removing fileaudit_ and .csv
        $shareName = $FileShare.Name.Split("\")[-1].Replace("fileaudit_","").Replace(".csv","")
        $importFileShareCSV | Export-Excel -Path $ExcelFile -WorksheetName $shareName -TableName $shareName -AutoSize -AutoFilter
    }
    foreach ($UnsupportedChar in $UnsupportedCharsCSV) {
        $importUnsupportedCharCSV = Import-CSV -Path $UnsupportedChar.FullName
        # Get Filename from CSV file name, removing unsupported_filenames_ and .csv
        $shareName = $UnsupportedChar.PSPath.Split("\")[-1].Replace("unsupported_filenames_","").Replace(".csv","")
        $importUnsupportedCharCSV | Export-Excel -Path $ExcelFile -WorksheetName "USC - $shareName" -TableName "USC - $shareName" -AutoSize -AutoFilter -Title "Unsupported Characters - $shareName" -TitleBold -TitleSize 16
    }
}