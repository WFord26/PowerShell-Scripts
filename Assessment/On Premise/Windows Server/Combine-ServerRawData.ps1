function Combine-ServerRawData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$logfile
    )
    # This function combines the raw data CSV files into a single CSV files
    # CSV file checks and combining
    $printerCSV = Get-ChildItem -Filter "RawData\printers*.csv"
    if ($null -ne $printerCSV) {
        $printerCSV | ForEach-Object {
            $printerData = Import-Csv -Path $_.FullName
            $printerData | Export-Csv -Path "RawData\combined-printers.csv" -Append -NoTypeInformation
            If ($logfile) {
                Add-Content -Path $logfile -Value "Combined printer data from $($_.FullName)"
            }
        }
    }
    $sharedFolderCSV = Get-ChildItem -Filter "RawData\shared_folders*.csv"
    if ($null -ne $sharedFolderCSV) {
        $sharedFolderCSV | ForEach-Object {
            $sharedFolderData = Import-Csv -Path $_.FullName
            $sharedFolderData | Export-Csv -Path "RawData\combined-shared_folders.csv" -Append -NoTypeInformation
            if ($logfile) {
                Add-Content -Path $logfile -Value "Combined shared folder data from $($_.FullName)"
            }
        }
    }
    $websitesCSV = Get-ChildItem -Filter "RawData\websites*.csv"
    if ($null -ne $websitesCSV) {
        $websitesCSV | ForEach-Object {
            $websitesData = Import-Csv -Path $_.FullName
            $websitesData | Export-Csv -Path "RawData\combined-websites.csv" -Append -NoTypeInformation
            if ($logfile) {
                Add-Content -Path $logfile -Value "Combined website data from $($_.FullName)"
            }
        }
    }
    $serverSoftwareCSV = Get-ChildItem -Filter "RawData\software*.csv"
    if ($null -ne $serverSoftwareCSV) {
        $serverSoftwareCSV | ForEach-Object {
            $serverSoftwareData = Import-Csv -Path $_.FullName
            $serverSoftwareData | Export-Csv -Path "RawData\combined-software_Servers.csv" -Append -NoTypeInformation
            if ($logfile) {
                Add-Content -Path $logfile -Value "Combined server software data from $($_.FullName)"
            }
        }
    }
    $disksCSV = Get-ChildItem -Filter "RawData\disk*.csv"
    if ($null -ne $disksCSV) {
        $disksCSV | ForEach-Object {
            $disksData = Import-Csv -Path $_.FullName
            $disksData | Export-Csv -Path "RawData\combined-disks.csv" -Append -NoTypeInformation
            if ($logfile) {
                Add-Content -Path $logfile -Value "Combined disk data from $($_.FullName)"
            }
        }
    }
    $gpoHTML = Get-ChildItem -Filter "RawData\gpo*.html"
    if ($null -ne $gpoHTML) {
        # Create a new HTML file
        $combinedGPO = "combined-gpo.html"

        # In the Combined GPO file, add the HTML header
        Add-Content -Path $combinedGPO -Value "<html><head><title>Group Policy Objects</title></head><body>"
        
        # Create a list of all the GPO HTML files and link them to the HTML file add the list to the Combined GPO HTML file
        $gpoHTML | ForEach-Object {
            Add-Content -Path $combinedGPO -Value "<a href='$($_.Name)'>$($_.Name)</a><br>"
        }

        # Add the HTML footer to the Combined GPO HTML file
        Add-Content -Path $combinedGPO -Value "</body></html>"
        if ($logfile) {
            Add-Content -Path $logfile -Value "Combined GPO HTML files into $combinedGPO"
        }
    }
    $dnsCSV = Get-ChildItem -Filter "RawData\dns_records*.csv"
    if ($null -ne $dnsCSV) {
        $dnsCSV | ForEach-Object {
            $dnsData = Import-Csv -Path $_.FullName
            $dnsData | Export-Csv -Path "RawData\combined-dns_records.csv" -Append -NoTypeInformation
            if ($logfile) {
                Add-Content -Path $logfile -Value "Combined DNS record data from $($_.FullName)"
            }
        }
    }

}