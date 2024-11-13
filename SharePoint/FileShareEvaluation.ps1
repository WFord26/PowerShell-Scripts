<#
.SYNOPSIS
    This script evaluates the size of a file share and the number of files and folders in each folder.
.Description
    This script calculates the size of a file share in gigabytes and the number of files and folders in each folder.
    The script uses the Get-ChildItem cmdlet to get the folders in the file share, and then calculates the size of each folder and the number of files and folders in each folder.
    The script outputs the results to a CSV file.
.PARAMETER None
    This script does not accept any parameters.
.EXAMPLE
    FileShareEvaluation.ps1
.NOTES
    Author: William Ford
    Date: 10/29/2024
    Version: 1.1
    Revision History:
        1.0 - Initial version
        1.1 - Added error handling for calculating folder size.
#>
$sharePath = "\\server\share"  # Replace with the actual share path

$folders = Get-ChildItem -Path $sharePath -Directory

$results = foreach ($folder in $folders) {
    $folderSize = (Get-ChildItem -Path $folder.FullName -Recurse -Force | Measure-Object -Property Length -Sum).Sum
    if ($error) {
        Write-Host "An error occurred while calculating the $folder.FullName folder size."
        continue
    }else{
        $folderSizeInGB = $folderSize / 1024
        $files = Get-ChildItem -Path $folder.FullName -File -Recurse
        $folders = Get-ChildItem -Path $folder.FullName -Directory -Recurse
        $folderCount = $folders.Count
        $fileCount = $files.Count
    }
    [PSCustomObject]@{
        FolderName = $folder.Name
        FolderSizeGB = $folderSizeInGB
        TotalFolders = $folderCount
        TotalFiles = $fileCount
    }
}

$results | Export-Csv -Path "C:\temp\FileAudit.csv" -NoTypeInformation