<#
.SYNOPSIS
    This script fixes the issue where the SharePoint Migration Tool reports a "Scan File Failure:The item created time or modified time is not supported" error.
.DESCRIPTION
    This script reads a CSV file containing items that failed to scan due to the error "Scan File Failure:The item created time or modified time is not supported".
    For each item in the CSV file, the script sets the date created for the item to the last modified date to resolve the issue.
.PARAMETER None
    This script does not accept any parameters.
.EXAMPLE
    FixCombinedErrorReports.ps1
.NOTES
    Author: William Ford
    Date: 10/29/2024
    Version: 1.5
    Changelog: 
        - Version 1.0: Initial script creation
        - Version 1.5: Updated function to operate off of Error Code.
#>
# Define the function to fix the issue
function Fix-ScanFileFailure {
    param (
        [string]$source,
        [string]$itemName,
        [string]$message,
        [string]$errorCode
    )

    if ($errorCode -eq "0x01110011") {
        # Set the date created for the item to the last modified date
        $item = Get-Item $source
        $lastModified = $item.LastWriteTime
        $item.CreationTime = $lastModified
        Write-Output "Fixed: $itemName"
    } elseif ($errorCode -eq "0x0111000C"){
        $item = Get-Item $source
        $newName = $itemName -replace '[<>:"/\\|?*]', ''
        $newName = $newName.Trim()
        Rename-Item -Path $source -NewName $newName
        Write-Output "Renamed: $(Write-Host $itemName -ForegroundColor Red) to $(Write-Host $newName -ForegroundColor Green)"
    }
}

# Import the CSV file
$csvFilePath = "C:\Path\to\the\CombinedItemFailureReport.csv"
$items = Import-Csv -Path $csvFilePath

# Iterate through each item in the CSV
foreach ($item in $items) {
    Fix-ScanFileFailure -source $item.Source -itemName $item.'Item name' -message $item.Message -errorCode $item.'Error code'
}