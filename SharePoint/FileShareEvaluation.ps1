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
function FileShareEvaluation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$domain,

        [Parameter(Mandatory=$true)]
        [string]$sharedFoldersCSV
    )
    $hostname = hostname
    # Import the CSV file with the shared folders
    $shares = Import-Csv -Path $sharedFoldersCSV
    foreach ($share in $shares) {
        $share
        $sharePath = $share.Path
        # Break the share path into the server and share name
        #Count the number of backslashes in the share path
        $backslashCount = ($sharePath -split '\\').Count -1
        $shareName = $sharePath.Split('\')[$($backslashCount)]

        if ($hostname -ne $share.PSComputerName){
            $folders = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
                Get-ChildItem -Path $using:sharePath -Directory
            }
        } else {
            $folders = Get-ChildItem -Path $sharePath -Directory
        }

        $results = foreach ($folder in $folders) {
            if ($hostname -ne $share.PSComputerName){
                $folderSize = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
                    (Get-ChildItem -Path $using:folder.FullName -Recurse -Force | Measure-Object -Property Length -Sum).Sum
                }
            } else {
                $folderSize = (Get-ChildItem -Path $folder.FullName -Recurse -Force | Measure-Object -Property Length -Sum).Sum
            }
            if ($error) {
                Write-Host "An error occurred while calculating the $folder.FullName folder size."
                continue
            }else{
                if ($hostname -ne $share.PSComputerName){
                    $folderSizeInGB = $folderSize / (1024*1024*1024)
                    $files = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
                        Get-ChildItem -Path $using:folder.FullName -File -Recurse
                    }
                    $folders = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
                        Get-ChildItem -Path $using:folder.FullName -Directory -Recurse
                    }
                    $folderCount = $folders.Count
                    $fileCount = $files.Count
                } else {
                    $folderSizeInGB = $folderSize / (1024*1024*1024)
                    $files = Get-ChildItem -Path $folder.FullName -File -Recurse
                    $folders = Get-ChildItem -Path $folder.FullName -Directory -Recurse
                    $folderCount = $folders.Count
                    $fileCount = $files.Count
                }
            }
            [PSCustomObject]@{
                FolderName = $folder.Name
                FolderSizeGB = $folderSizeInGB
                TotalFolders = $folderCount
                TotalFiles = $fileCount
            }
        }
        if ($hostname -ne $share.PSComputerName){
            $rootFiles = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
                Get-ChildItem -Path $using:sharePath -File
            }
            $rootFolders = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
                Get-ChildItem -Path $using:sharePath -Directory
            }
            $rootFolderSize = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
                (Get-ChildItem -Path $using:sharePath -Recurse -Force | Measure-Object -Property Length -Sum).Sum
            }
            $rootFolderSizeInGB = $rootFolderSize / (1024*1024*1024)
            $rootFolderCount = $rootFolders.Count
            $rootFileCount = $rootFiles.Count
            $results +=[PSCustomObject]@{
                FolderName = 'Root'
                FolderSizeGB = $rootFolderSizeInGB
                TotalFolders = $rootFolderCount
                TotalFiles = $rootFileCount
            }
        } else {
            $rootFiles = Get-ChildItem -Path $sharePath -File
            $rootFolders = Get-ChildItem -Path $sharePath -Directory
            $rootFolderSize = (Get-ChildItem -Path $sharePath -Recurse -Force | Measure-Object -Property Length -Sum).Sum
            $rootFolderSizeInGB = $rootFolderSize / (1024*1024*1024)
            $rootFolderCount = $rootFolders.Count
            $rootFileCount = $rootFiles.Count
            $results +=[PSCustomObject]@{
                FolderName = 'Root'
                FolderSizeGB = $rootFolderSizeInGB
                TotalFolders = $rootFolderCount
                TotalFiles = $rootFileCount
            }
        }
        # Get the sum of FolderSizeGB, TotalFolders, and TotalFiles

        # Get the sum of FolderSizeGB
        $totalFolderSizeGB = ($results | Measure-Object -Property FolderSizeGB -Sum).Sum
        # Get the sum of TotalFolders
        $totalFolders = ($results | Measure-Object -Property TotalFolders -Sum).Sum
        # Get the sum of TotalFiles
        $totalFiles = ($results | Measure-Object -Property TotalFiles -Sum).Sum
        # Add a Total line item to the results
        $results += [PSCustomObject]@{
                FolderName = 'Total'
                FolderSizeGB = $totalFolderSizeGB
                TotalFolders = $totalFolders
                TotalFiles = $totalFiles
            }

        $results | Export-Csv -Path "03 - $domain - $shareName - FileAudit.csv" -NoTypeInformation

        # Export the permissions for each folders subfolders. For each folder build a folders array from all the subfolders. Then get the ACL for each folder and export to a CSV file.
        $folderPermissions = foreach ($folder in $folders) {
            if ($hostname -ne $share.PSComputerName){
                $folders = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
                    Get-ChildItem -Path $using:folder.FullName -Directory -Recurse
                } else {
                    $folders = Get-ChildItem -Path $folder.FullName -Directory -Recurse
                }
            foreach ($subfolder in $folders) {
                if ($hostname -ne $share.PSComputerName){
                    $acl = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
                        Get-Acl -Path $using:subfolder.FullName
                    }
                } else {
                    $acl = Get-Acl -Path $subfolder.FullName
                }
                foreach ($access in $acl.Access) {
                    [PSCustomObject]@{
                        FolderName = $subfolder.FullName
                        IdentityReference = $access.IdentityReference
                        FileSystemRights = $access.FileSystemRights
                        AccessControlType = $access.AccessControlType
                    }
                }
            }
        }
        # Create a CSV file with the folder permissions
        $folderPermissions | Export-Csv -Path "03 - $domain - $shareName - FolderPermissions.csv" -NoTypeInformation
    }
}