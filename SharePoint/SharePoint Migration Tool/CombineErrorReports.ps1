<#
.SYNOPSIS
    This script combines multiple CSV files into a single CSV file. This is currently configured to work with SharePoint Migration Tool error reports.

.DESCRIPTION
    This script searches for CSV files in a specified path and combines them into a single CSV file. 
    The script imports the data from each CSV file, combines it into a single array, and then exports the combined data to a new CSV file.

.PARAMETER None
    This script does not accept any parameters.

.EXAMPLE
    Make sure you are running from the correct directory where the folder "Report" is present.
    CombineErrorReports.ps1

.NOTES
    Author: William Ford
    Date: 10/29/2024
    Version: 1.0

#>

# Define the path to search for CSV files
$searchPath = "Report\TaskReport_*"

# Define the output file path
$outputFile = "C:\Temp\CombinedItemFailureReport.csv"

# Get all CSV files matching the pattern
$csvFiles = Get-ChildItem -Path $searchPath -Filter "ItemFailureReport_R1.csv" -Recurse

# Initialize an empty array to hold the data
$combinedData = @()

# Loop through each CSV file and import the data
foreach ($csvFile in $csvFiles) {
    $data = Import-Csv -Path $csvFile.FullName
    $combinedData += $data
}

# Export the combined data to a new CSV file
$combinedData | Export-Csv -Path $outputFile -NoTypeInformation