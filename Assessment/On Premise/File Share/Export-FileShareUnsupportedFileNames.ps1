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
    if ($hostname -ne $share.PSComputerName) {
        Invoke-Command -ComputerName $share.PSComputerName -ScriptBlock {
            $files += Get-ChildItem -Path $sharePath -Recurse -File | Where-Object { $_.Name -match "[^a-zA-Z0-9\.\-_\s]" }
        }
        return
    }
    # Cycle through all files in the share and subfolders and return files with unsupported characters
    # Unsupported characters: ~, #, %, & , *, {, }, \, :, <, >, ?, /, |, "
    $sharePath = share.Path

    $unsupportedChars = '[~#%&*{}\\:<>?/|"]'
    $files += Get-ChildItem -Path $sharePath -Recurse -File | Where-Object { $_.Name -match $unsupportedChars }

    # Convert $files into a table
    $files = $files | Select-Object -Property Name, Directory, FullName
    
    # Export Files to CSV
    $files | Export-Csv -Path "unsupported_filenames_$($share.Name).csv" -NoTypeInformation
    }