# Combine all the csv files in the current directory into a single excel file. Each csv file will be a separate sheet in the excel file.
# The output of the excel file will be the same as the name of the current directory.
# The name of the sheets will be the name of the csv file without the extension and "## - $Domain -" (eg. 01 - Domain1 -)

# Set the domain name
$Domain = "WaiConnor.net"

# Set the output file path
$OutputFile = ".\00 - $Domain - On Premise Assessment.xlsx"

# Create a new Excel application
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $true

# Create a new workbook
$Workbook = $Excel.Workbooks.Add()

# Get all the csv files in the current directory
$CsvFiles = Get-ChildItem -Path $PSScriptRoot -Filter *.csv -File

# Loop through each csv file
foreach ($CsvFile in $CsvFiles) {
    # Get the name of the sheet
    $shortName = $CsvFile.BaseName

    # Remove the first 5 characters (assuming "## - " prefix)
    $shortName = $shortName.Substring(5)

    # Remove the "$Domain - " suffix
    $shortName = $shortName.Substring(0, $shortName.Length - $Domain.Length - 3)
    $SheetName = $shortName

    # Import the csv file into a new worksheet
    $Worksheet = $Workbook.Worksheets.Add()
    $Worksheet.Name = $SheetName
    # CSV file to import
    $ImportFile = $CsvFile.FullName
    # Import the CSV file
    $Range = $Worksheet.Range("A1").LoadFromText($ImportFile, [Type]::Missing, [Type]::Missing, [Microsoft.Office.Interop.Excel.XlTextParsingType]::xlDelimited, [Microsoft.Office.Interop.Excel.XlTextQualifier]::xlTextQualifierDoubleQuote)
    # Auto fit the columns
    $Worksheet.UsedRange.EntireColumn.AutoFit()


}

# Save the workbook
$Workbook.SaveAs($OutputFile)

# Clean up
$Excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | Out-Null
Remove-Variable Excel
[GC]::Collect()
[GC]::WaitForPendingFinalizers()


# Create Excel COM object
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $false
$Excel.DisplayAlerts = $false

# Create a new workbook
$Workbook = $Excel.Workbooks.Add()

# Get all CSV files from the folder
$CsvPath = "C:\Users\wford.MS\OneDrive - Managed Solution\Customers\WaiConnor\Engineering Documents\On Prem Assessment"
$Domain = "WaiConnor.net" # Modify as needed
$OutputFile = "\00 - $Domain - On Premise Assessment.xlsx"
$CsvFiles = Get-ChildItem -Path $CsvPath -Filter "*.csv"
$outPath = $CsvPath + $OutputFile

# Loop through each csv file
foreach ($CsvFile in $CsvFiles) {
    Write-Host "Starting $($CsvFile.BaseName)"
    # Get the name of the sheet
    $shortName = $CsvFile.BaseName
    
    # Remove the first 5 characters (assuming "## - " prefix)
    $shortName = $shortName.Substring(5)
    
    # Remove the "$Domain - " suffix
    $shortName = $shortName.Substring($Domain.Length + 3)
    $SheetName = $shortName
    # Import the csv file into a new worksheet
    $Worksheet = $Workbook.Worksheets.Add()
    $Worksheet.Name = $SheetName
    
    # Import CSV data
    $CSVData = Import-Csv -Path $ImportFile
    
    # Get headers and convert to array
    $Headers = $CSVData | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
    
    # Write headers to first row
    for($col = 0; $col -lt $Headers.Count; $col++) {
        $Worksheet.Cells.Item(1, $col + 1) = $Headers[$col]
    }
    
    # Write CSV data starting from second row
    $row = 2
    foreach($item in $CSVData) {
        for($col = 0; $col -lt $Headers.Count; $col++) {
            $Worksheet.Cells.Item($row, $col + 1) = $item.$($Headers[$col])
        }
        $row++
    }
    
    # Auto fit columns
    $Worksheet.UsedRange.EntireColumn.AutoFit()
}

# Delete the default empty Sheet1
$Workbook.Worksheets.Item(1).Delete()

# Save the workbook
$Workbook.SaveAs($outPath)

# Cleanup
$Workbook.Close($true)
$Excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()