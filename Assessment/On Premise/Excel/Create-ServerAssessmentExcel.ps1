function Create-ServersAssessmentExcel {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$domain
    )
    # Check if ImportExcel module is installed, if not install it
    if (-not (Get-Module -Name ImportExcel -ListAvailable)) {
        Install-Module -Name ImportExcel -Scope CurrentUser -Force -AllowClobber
    } else {
        Write-Host "ImportExcel module is already installed"
    }

    # Import the ImportExcel module
    Import-Module ImportExcel

    # Excel File
    $ExcelFile = ".\$($domain)_Server_Assessment.xlsx"

    # Clear variables
    $ServerCSV = @()
    $DisksCsv = @()
    $SoftwareCsv = @()
    $FileSharesCsv = @()
    $WebsitesCsv = @()

    # Import Server CSV
    $ServerCSV = Import-Csv -Path ".\combined_servers_info*.csv"

    # Import Combined Disks CSV
    $DisksCsv = Import-Csv -Path ".\combined-disks.csv"

    # Import Combined Software CSV
    $SoftwareCsv = Import-Csv -Path ".\combined-software_Servers.csv"

    # Import Combined File Shares CSV
    $FileSharesCsv = Import-Csv -Path ".\combined-shared_folders.csv"

    # Import Combined Websites CSV
    $WebsitesCsv = Import-Csv -Path ".\combined-websites.csv"

    # Import Combined Services CSV
    $servicesCsv = Import-Csv -Path ".\combined-services.csv"

    # Import Combined Roles CSV
    $rolesCsv = Import-Csv -Path ".\combined-roles.csv"

    # Import Combined Printers CSV
    $printersCsv = Import-Csv -Path ".\combined-printers.csv"

    # Import Combined ADCS Info CSV
    $adcsInfoCsv = Import-Csv -Path ".\combined-adcs_info.csv"

    # Import Combined ADCS Extensions CSV
    $adcsExtensionsCsv = Import-Csv -Path ".\combined-adcs_extensions.csv"

    # Import Combined ADCS Templates CSV
    $adcsTemplatesCsv = Import-Csv -Path ".\combined-adcs_templates.csv"

    # Import Combined Virtual Machines CSV
    $virtualMachinesCsv = Import-Csv -Path ".\combined-virtual_machines.csv"

    # Import Combined Network Adapters CSV
    $networkAdaptersCsv = Import-Csv -Path ".\combined-network_adapters.csv"


    # Use CSV data directly without Format-Table
    $ServerTable = $ServerCSV
    $DisksTable = $DisksCsv
    $SoftwareTable = $SoftwareCsv
    $FileSharesTable = $FileSharesCsv
    $WebsitesTable = $WebsitesCsv

    # Add a Column to the Server Table
    $ServerTable | Add-Member -MemberType NoteProperty -Name "Disks" -Value "" -Force
    $ServerTable | Add-Member -MemberType NoteProperty -Name "Migrate" -Value "" -Force
    $ServerTable | Add-Member -MemberType NoteProperty -Name "Notes" -Value "" -Force

    # In the DisksTable drop any row that has a Size of 0
    $DisksTable = $DisksTable | Where-Object { $_.Size -gt 0 }


    # for each server in the Server Table
    foreach ($Server in $ServerTable) {
        # Get the Disks for the Server
        $ServerDisks = $DisksTable | Where-Object { $_.PSComputerName -eq $Server.ServerName }
        # Convert the disks to readable format. Example: D: 100/200GB Free
        $Disks = $ServerDisks | ForEach-Object {
            $FreeSpace = [math]::Round($_.FreeSpace / 1GB, 2)
            $Size = [math]::Round($_.Size / 1GB, 2)
            "{0} {1}/{2}GB Free" -f $_.DeviceID, $FreeSpace, $Size
        }

        # Add the Disks to the Server Table
        $Server.Disks = $Disks -join "`n"

        # Convert Memory to GB
        $Server.TotalPhysicalMemory = [math]::Round($Server.TotalPhysicalMemory / 1GB, 2)

        # Get the Software for the Server
        $ServerSoftware = $SoftwareTable | Where-Object { $_.PSComputerName -eq $Server.ServerName }
    }

    # Export Tables to Excel
    if (Test-Path $ExcelFile) {
        Remove-Item $ExcelFile
    }

    if ($ServerTable){
        $ServerTable | Export-Excel -Path $ExcelFile -WorksheetName "Servers" -TableName "Servers" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($DisksTable){
        $DisksTable | Export-Excel -Path $ExcelFile -WorksheetName "Disks" -TableName "Disks" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($SoftwareTable){
        $SoftwareTable | Export-Excel -Path $ExcelFile -WorksheetName "Software" -TableName "Software"  -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($FileSharesTable){
        $FileSharesTable | Export-Excel -Path $ExcelFile -WorksheetName "FileShares" -TableName "FileShares"  -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($WebsitesTable){
        $WebsitesTable | Export-Excel -Path $ExcelFile -WorksheetName "Websites" -TableName "Websites" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($rolesCsv){
        $rolesCsv | Export-Excel -Path $ExcelFile -WorksheetName "Roles" -TableName "Roles" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($servicesCsv){
        $servicesCsv | Export-Excel -Path $ExcelFile -WorksheetName "Services" -TableName "Services" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($printersCsv){
        $printersCsv | Export-Excel -Path $ExcelFile -WorksheetName "Printers" -TableName "Printers" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($virtualMachinesCsv){
        $virtualMachinesCsv | Export-Excel -Path $ExcelFile -WorksheetName "Virtual Machines" -TableName "Virtual Machines" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($networkAdaptersCsv){
        $networkAdaptersCsv | Export-Excel -Path $ExcelFile -WorksheetName "Network Adapters" -TableName "Network Adapters" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($adcsInfoCsv) {
        $adcsInfoCsv | Export-Excel -Path $ExcelFile -WorksheetName "ADCS Info" -TableName "ADCS Info" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($adcsExtensionsCsv) {
        $adcsExtensionsCsv | Export-Excel -Path $ExcelFile -WorksheetName "ADCS Extensions" -TableName "ADCS Extensions" -AutoSize -BoldTopRow -FreezeTopRow
    }
    if ($adcsTemplatesCsv) {
        $adcsTemplatesCsv | Export-Excel -Path $ExcelFile -WorksheetName "ADCS Templates" -TableName "ADCS Templates" -AutoSize -BoldTopRow -FreezeTopRow
    }
}
Create-ServersExcelFile -domain "WaiConnor.net"