
# Import the required modules
Import-Module Microsoft.Online.SharePoint.PowerShell

#Connect to SharePoint Online
$UserCredential = Get-Credential
Connect-SPOService -Url https://rockmtnins-admin.sharepoint.com -Credential $UserCredential


# Set the path to the CSV file containing UPNs
$csvPath = "C:\Temp\Users.txt"

# Set the path to export the OneDrive statistics
$exportPath = "C:\Temp\OneDriveStatistics.csv"

Function ConvertTo-Gb {
    <#
      .SYNOPSIS
          Convert mailbox size to Gb for uniform reporting.
    #>
    param(
      [Parameter(
        Mandatory = $true
      )]
      [string]$size
    )
    process {
      if ($size -ne $null) {
        $sizeInGb = ($size / 1024)
  
        return [Math]::Round($sizeInGb,2,[MidPointRounding]::AwayFromZero)
      }
    }
  }

# Read the CSV file
$upns = Import-Csv $csvPath | Select-Object -ExpandProperty UPN
$upnSP = $upns -replace '@', '_' -replace '\.', '_'
# Initialize an empty array to store the statistics
$statistics = @()

# Iterate through each UPN
foreach ($upn in $upnSP) {
    # Get the user's OneDrive statistics
    $statistics += Get-SPOSite -Identity "https://rockmtnins-my.sharepoint.com/personal/$upn" |
                   Select-Object -Property Title,Owner,StorageQuota,StorageQuotaWarningLevel,StorageUsageCurrent,,LastContentModifiedDate,Status

    # Output progress
    Write-Host "Processed UPN: $upn"
}
$statistics | ForEach {
  if ($_.StorageUsageCurrent -ne 0) {
    [pscustomobject]@{
      "Display Name" = $_.Title
      "Owner" = $_.Owner
      "Onedrive Size (Gb)" = ConvertTo-Gb -size $_.StorageUsageCurrent
      "Storage Warning Quota (Gb)" = ConvertTo-Gb -size $_.StorageQuotaWarningLevel
      "Storage Quota (Gb)" = ConvertTo-Gb -size $_.StorageQuota
      "Last Used Date" = $_.LastContentModifiedDate
      "Status" = $_.Status
    }
    $currentUser = $_.Title
    Write-Progress -Activity "Collecting OneDrive Sizes" -Status "Current Count: $i" -PercentComplete (($i / $oneDrives.Count) * 100) -CurrentOperation "Processing OneDrive: $currentUser"
    $i++;
  } else {
    [pscustomobject]@{
      "Display Name" = $_.Title
      "Owner" = $_.Owner
      "Onedrive Size (Gb)" = 0
      "Storage Warning Quota (Gb)" = ConvertTo-Gb -size $_.StorageQuotaWarningLevel
      "Storage Quota (Gb)" = ConvertTo-Gb -size $_.StorageQuota
      "Last Used Date" = $_.LastContentModifiedDate
      "Status" = $_.Status
    }
    $currentUser = $_.Title
    Write-Progress -Activity "Collecting OneDrive Sizes" -Status "Current Count: $i" -PercentComplete (($i / $oneDrives.Count) * 100) -CurrentOperation "Processing OneDrive: $currentUser"
    $i++;
  
  }
}
# Export the statistics to a CSV file
$statistics | Export-Csv -Path $exportPath -NoTypeInformation

# Output completion message
Write-Host "OneDrive statistics exported to: $exportPath"