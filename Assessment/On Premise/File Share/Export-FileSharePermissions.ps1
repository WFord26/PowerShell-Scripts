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
            Write-Host " - Starting $folder" -ForegroundColor Green
            # Get all the subfolders in the folder, use Invoke-Command if the folder is on a remote machine
            $uncPath = "\\$($share.PSComputerName)\$($folder.FullName.Replace(':', '$'))"
            
            # Get all the subfolders in the folder
            $folderShare = Get-ChildItem -Path $uncPath -Directory -Recurse

            # Create an array to store the folder permissions
            $folderPermissions = @()
            
            # Create an array to store the jobs
            $jobs = @()

            # Set checkpoint size (number of folders to process before saving to temp file)
            $checkpointSize = 1000
            $checkpointCount = 0
            $checkpointIndex = 0
            $tempFilePath = ".\RawData\temp_$($shareName)_$($folder.Name)_checkpoint"

            # Loop through each subfolder and get the ACL
            $totalFolders = $folderShare.Count
            $currentFolder = 0

            foreach ($subfolder in $folderShare) {
                $currentFolder++
                $checkpointCount++
                
                $percentComplete = [math]::Round(($currentFolder / $totalFolders) * 100, 2)
                Write-Progress -Activity "Processing folders" -Status "$percentComplete% Complete" -PercentComplete $percentComplete -CurrentOperation "Processing $($subfolder.FullName)"
                
                while ((Get-Job -State Running).Count -ge $workers) {
                    Start-Sleep -Seconds 1
                    Get-Job -State Completed | ForEach-Object {
                        $folderPermissions += Receive-Job -Job $_ -Wait
                        Remove-Job -Job $_
                    }

                    # Check if we've hit the checkpoint size
                    if ($folderPermissions.Count -ge $checkpointSize) {
                        $checkpointIndex++
                        $tempFile = "${tempFilePath}_${checkpointIndex}.csv"
                        $folderPermissions | Export-Csv -Path $tempFile -NoTypeInformation -Append
                        $folderPermissions = @()
                    }
                }
                
                $jobs += Start-Job -ScriptBlock {
                    param($subfolderPath)
                    try {
                        $acl = Get-Acl -Path $subfolderPath -ErrorAction Stop
                        $acl.Access | ForEach-Object {
                            [PSCustomObject]@{
                                SharePath = $sharePath
                                # Get the subfolder path without the share path
                                FolderName = $subfolderPath.Substring($sharePath.Length)+1
                                IdentityReference = $_.IdentityReference
                                FileSystemRights = $_.FileSystemRights
                                AccessControlType = $_.AccessControlType
                            }
                        }
                    }
                    catch {
                        Write-Warning "Error getting ACL for path: $subfolderPath"
                        Write-Warning $_.Exception.Message
                    }
                } -ArgumentList $subfolder.FullName
            }

            Write-Progress -Activity "Processing folders" -Completed

            # Process remaining jobs
            $jobs | ForEach-Object {
                $folderPermissions += Receive-Job -Job $_ -Wait
                Remove-Job -Job $_ -Force
            }

            # Combine all checkpoint files into final result
            $folderPermissions = @()
            Get-ChildItem -Path "RawData" -Filter "temp_$($shareName)_$($folder.Name)_checkpoint*.csv" | ForEach-Object {
                $folderPermissions += Import-Csv -Path $_.FullName
                Remove-Item -Path $_.FullName -Force
            }
            # Ensure the RawData directory exists
            if (-not (Test-Path -Path "RawData")) {
                New-Item -ItemType Directory -Path "RawData"
            }
            
            # Export the folder permissions to a CSV file
            $folderPermissions | Export-Csv -Path "RawData\permissions_$($shareName)_$($folder.Name).csv" -NoTypeInformation
            Write-Host "  - Completed - $folderPermissions - RawData\permissions_$($shareName)_$($folder.Name).csv" -ForegroundColor Green
    }
}