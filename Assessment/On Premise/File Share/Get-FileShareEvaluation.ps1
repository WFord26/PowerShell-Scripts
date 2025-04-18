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
function Get-FileShareEvaluation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$domain,
        [Parameter(Mandatory=$true)]
        [string]$sharedFoldersCSV
    )

    # Get the hostname of the local machine
    $hostname = hostname
    
    # Import the CSV file with the shared folders
    $shares = Import-Csv -Path $sharedFoldersCSV

    foreach ($share in $shares) {
        # Evaluate the size of the file share
        # Write-Host "Evaluating file share size $($share.Name)"
        # Export-FileShareSize -domain $domain -share $share -hostname $hostname

        # Evaluate the permissions of the file share
        Write-Host "Evaluating file share permissions $($share.Name)"
        Export-FileSharePermissions -domain $domain -share $share -hostname $hostname -workers 100

        # Evaluate the files with unsupported files names
        Write-Host "Evaluating file share unsupported file names $($share.Name)"
        Export-FileShareUnsupportedFileNames -domain $domain -share $share -hostname $hostname
    }    
}