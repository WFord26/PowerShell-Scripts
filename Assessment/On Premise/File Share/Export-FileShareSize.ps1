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