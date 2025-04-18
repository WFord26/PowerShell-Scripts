#### FUNCTIONS ####

function Export-FileSharePermissions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, HelpMessage="The domain name of the server where the share is located.")]
        [string]$domain,
        [Parameter(Mandatory=$true, HelpMessage="The hostname of the server where the share is located. If the share is on the local machine, use 'localhost'.")]
        [string]$hostname,
        [Parameter(Mandatory=$false, HelpMessage="Number of workers to use for parallel processing. Default is 50.")]
        [string]$workers,
        [Parameter(Mandatory=$true, HelpMessage="The share object to export permissions for.")]
        [array]$share
    )
    # Get the share path and share name
    $sharePath = $share.Path
    $shareName = $share.Name

    # Check if $workers is null
    if ($workers -eq $null) {
        $workers = 50
    }

    # Check if the share is on the local machine or a remote machine. If the share is on a remote machine, use Invoke-Command to get the folders.
    if ($hostname -ne $share.PSComputerName){
        $folders = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
            Get-ChildItem -Path $using:sharePath -Directory
        }
    } else {
        $folders = Get-ChildItem -Path $sharePath -Directory
    }
    
    # Export the permissions for each folders subfolders. For each folder build a folders array from all the subfolders. Then get the ACL for each folder and export to a CSV file.
    foreach ($folder in $folders) {
        Write-Host "|-- Starting $folder" -NoNewline
        # Get all the subfolders in the folder, use Invoke-Command if the folder is on a remote machine
        $uncPath = "\\$($share.PSComputerName)\$($folder.FullName.Replace(':', '$'))"
        
        # Get all the subfolders in the folder
        $folderShare = Get-ChildItem -Path $uncPath -Directory -Recurse 

        # Create an array to store the folder permissions
        $folderPermissions = @()

        # Loop through each subfolder and get the ACL
        $totalFolders = $folderShare.Count
        $currentFolder = 0

        foreach ($subfolder in $folderShare) {
            $currentFolder++
            
            $percentComplete = [math]::Round(($currentFolder / $totalFolders) * 100, 2)
            Write-Progress -Activity "Processing folders" -Status "$percentComplete% Complete" -PercentComplete $percentComplete -CurrentOperation "Processing $($subfolder.FullName)"
            
            try {
                $acl = Get-Acl -Path $subfolder.FullName -ErrorAction Stop
                $acl.Access | ForEach-Object {
                    $folderPermissions += [PSCustomObject]@{
                        SharePath = $sharePath
                        # Get the subfolder path without the share path
                        FolderName = $subfolder.FullName.Substring($sharePath.Length + 1)
                        IdentityReference = $_.IdentityReference
                        FileSystemRights = $_.FileSystemRights
                        AccessControlType = $_.AccessControlType
                        IsInherited = $_.IsInherited
                    }
                }
            }
            catch {
                Write-Warning "Error getting ACL for path: $($subfolder.FullName)"
                Write-Warning $_.Exception.Message
            }
        }

        # Get ACL for the root Folder

        Write-Progress -Activity "Processing folders" -Completed

        # Ensure the RawData directory exists
        if (-not (Test-Path -Path "RawData")) {
            New-Item -ItemType Directory -Path "RawData"
        }
        
        # Export the folder permissions to a CSV file
        $folderPermissions | Export-Csv -Path "RawData\permissions_$($shareName)_$($folder.Name).csv" -NoTypeInformation
        Write-Host "  - Completed" -ForegroundColor Green
    }
}

function Export-FileShareSize {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$domain,
        [Parameter(Mandatory=$true)]
        [string]$hostname,
        [Parameter(Mandatory=$true)]
        [array]$share
    )
    
    $sharePath = $share.Path
    $shareName = $share.Name
    $results = @()

    if ($hostname -ne $share.PSComputerName) {
        $folders = Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
            Get-ChildItem -Path (, $using:sharePath) -Directory
        }
    } else {
        $folders = Get-ChildItem -Path $sharePath -Directory
    }

    Write-Host "Starting Shares on $($share.PSComputerName)"
    foreach ($folder in $folders) {
        try {
            Write-Host "|-- Starting $($folder.Name):" -NoNewline
            $uncPath = "\\$($share.PSComputerName)\$($folder.FullName.Replace(':', '$'))"
            $size = (Get-ChildItem -Path $uncPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $folderSizeInGB = [math]::Round($size / 1GB, 2)
            $files = @(Get-ChildItem -Path $uncPath -File -Recurse)
            $subfolders = @(Get-ChildItem -Path $uncPath -Directory -Recurse)
            $folderCount = $subfolders.Count
            $fileCount = $files.Count
            
            Write-Host " Completed Size: $folderSizeInGB GB" -ForegroundColor Green
            
            $results += [PSCustomObject]@{
                FolderName = $folder.Name
                FolderSizeGB = $folderSizeInGB
                TotalFolders = $folderCount
                TotalFiles = $fileCount
            }
        }
        catch {
            Write-Host " Error processing folder" -ForegroundColor Red
            Write-Warning $_.Exception.Message
            continue
        }
    }
    Write-Host "|- Starting Root:" -nonewline
    try {
        $preSum = ($results | Measure-Object -Property FolderSizeGB -Sum).Sum
        
        # Local operations
        $rootFiles = Get-ChildItem -Path $uncPath -File -ErrorAction Stop
        $rootFolders = Get-ChildItem -Path $uncPath -Directory -ErrorAction Stop
        $rootSize = (Get-ChildItem -Path $uncPath -Recurse -Force -ErrorAction Stop | 
                    Measure-Object -Property Length -Sum).Sum
        
        $rootFolderSizeInGB = [math]::Round([decimal]$rootSize / 1GB, 2)
        
        $results += [PSCustomObject]@{
            FolderName = 'Root'
            FolderSizeGB = $rootFolderSizeInGB - $preSum
            TotalFolders = $rootFolders.Count
            TotalFiles = $rootFiles.Count
        }
    }
    catch {
        Write-Warning "Error processing root folder: $_"
    }
    
    
    Write-Host " Completed Root Size: $($rootFolderSizeInGB)GB" -ForegroundColor Green
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

    $results | Export-Csv -Path ".\fileaudit_$($shareName).csv" -NoTypeInformation
    Write-Host "File share evaluation for $shareName complete."
    }  
function Export-FileShareUnsupportedFileNames {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$domain,
        [Parameter(Mandatory=$true)]
        [string]$hostname,
        [Parameter(Mandatory=$true)]
        [array]$share
    )

    # Define unsupported characters
    $unsupportedChars = '[~#%&*{}\\:<>?/|"]'

    foreach ($s in $share) {
        $sharePath = $s.Path

        if ($hostname -ne $s.PSComputerName) {
            Invoke-Command -ComputerName $s.PSComputerName -ScriptBlock {
                param ($sharePath, $unsupportedChars)
                Get-ChildItem -Path $sharePath -Recurse -File | Where-Object { $_.Name -match $unsupportedChars }
            } -ArgumentList $sharePath, $unsupportedChars -OutVariable files
        } else {
            $files = Get-ChildItem -Path $sharePath -Recurse -File | Where-Object { $_.Name -match $unsupportedChars }
        }

        # Convert $files into a table
        $files = $files | Select-Object -Property Name, Directory, FullName

        # Export Files to CSV
        $outputFilePath = "unsupported_filenames_$($s.Name).csv"
        $files | Export-Csv -Path $outputFilePath -NoTypeInformation

        Write-Output "Unsupported filenames have been saved to $outputFilePath"
    }
}
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
#### END FUNCTIONS ####

# Clear the screen
Clear-Host

# Check if long paths are enabled
if ((Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled').LongPathsEnabled -eq 0) {
    Write-Host "Long paths are not enabled. Enabling long paths..."
    # Enable long paths
    Set-ItemProperty 'HKLM:\System\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -value 1
} else {
    Write-Host "Long paths are enabled."
}

# Set the path to the CSV file with the shared folders
$sharedFoldersCSV = "C:\temp\share.csv"
$domain = "contoso.com"

Get-FileShareEvaluation -domain $domain -sharedFoldersCSV $sharedFoldersCSV
