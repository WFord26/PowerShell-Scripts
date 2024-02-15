#requires -version 5.0
<#
.Synopsis
  Tests network Connections

.DESCRIPTION
  This script will test network, http, and share tests.
   
.NOTES
  Name: NetworkTest
  Author: W. Ford
  Version: 1.0
  DateCreated: mar 2023
  Purpose/Change: Creation

.PARAMETER siteName
Enter the site or computer name that you are testing from.

.PARAMETER networkTest
What type of network test would you like to run from this computer?
    - ip - Will run scans on only IP address listed
    - http - Will run http tests on Domains listed 
    - share - Check access to Network Shares
    - httpscan - Run an ip test and http test together
    - all (default) - Run all tests

.PARAMETER output
Where would you like the Log file to save to?
    - Default is current Users home directory.

.PARAMETER ipList
This is a list of ip and domains seperated with a "," with your string
wrapped in quotation marks. 
    - Default is "1.1.1.1,8.8.8.8" this will do independent searches for each ip address.

.PARAMETER httpList
This is for domains that you would like to have tested for http access. 
This also tests basic network functionality too.
    - Default is "google.com"

.PARAMETER shareList.
Where would you like the Log file to save to?

.EXAMPLE
  .\NetworkTest.ps1 -siteName "My Site Name" -output "C:\temp"
    - This saves a file to "C:\temp\NetworkTest\My Site Name\LogFile-<Todays Date>.md"
    - Will run the Network and HTTP tests for the default settings for both.
        - 1.1.1.1, 8.8.8.8

  .\NetworkTest.ps1 -ipList "1.1.1.1,192.168.0.1,google.com" -httpList "facebook.com" -shareList "\\Server\share,\\Server2\share2" -networkTest all
    - This will run all network tests
    - It will do network tests to:
        - 1.1.1.1, 192.168.0.1, google.com
    - It will do a http test to facebook.com
    - It will do a network share test to:
        - \\Server\share, \\Server2\share2

#>
param(
  [Parameter(
    Mandatory = $false,
    HelpMessage = "Enter the site location that you are running this test at"
  )]
  [string]$siteName = "MySite",

  [Parameter(
    Mandatory = $false,
    HelpMessage = "What network test would you like to run? (ip, http, share, httpscan, all)"
  )]
  [ValidateSet("ip", "http", "share", "httpScan", "all")]
  [string]$networkTest = "httpScan",

  [Parameter(
    Mandatory = $false,
    HelpMessage = "Where would you like the file placed for you. (Default is user profile)"
  )]
  [string]$output = $HOME,
  [Parameter(
    Mandatory = $false,
    HelpMessage = "What Network addresses would you like to test? (Defualt is 8.8.8.8 and 1.1.1.1)"
  )]
  [string[]]$ipList = "8.8.8.8,1.1.1.1",
  [Parameter(
    Mandatory = $false,
    HelpMessage = "What Domain addresses would you like to test HTTP connection to? (Defualt is google.com)"
  )]
  [string[]]$httpList = "google.com",
  [Parameter(
    Mandatory = $false,
    HelpMessage = "What Network share would you like to test?"
  )]
  [string[]]$shareList
)
# Functions out here trying to Function.
# Convert to Markdown.
Function ConvertTo-Markdown {
[cmdletbinding()]
    [outputtype([string[]])]
    Param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [object]$Inputobject,
        [Parameter()]
        [string]$Title,
        [string[]]$PreContent,
        [string[]]$PostContent,
        [ValidateScript( {$_ -ge 10})]
        [int]$Width = 80
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting $($myinvocation.MyCommand)"
        #initialize an array to hold incoming data
        $data = @()

        #initialize an empty here string for markdown text
        $Text = @"

"@
        If ($title) {
            Write-Verbose "[BEGIN  ] Adding Title: $Title"
            $Text += "# $Title`n`n"
        }
        If ($precontent) {
            Write-Verbose "[BEGIN  ] Adding Precontent"
            $Text += $precontent
            $text += "`n`n"
        }

    } #begin

    Process {
        #add incoming objects to data array
        Write-Verbose "[PROCESS] Adding processed object"
        $data += $Inputobject

    } #process
    End {
        #add the data to the text
        if ($data) {
            #convert data to strings and trim each line
            Write-Verbose "[END    ] Converting data to strings"
            [string]$trimmed = (($data | Out-String -Width $width).split("`n")).ForEach( {"$($_.trimend())`n"})
            Write-Verbose "[END    ] Adding to markdown"
            $text += @"
``````text
$($trimmed.trimend())
``````

"@
        }

        If ($postcontent) {
            Write-Verbose "[END    ] Adding postcontent"
            $text += "`n"
            $text += $postcontent
        }
        #write the markdown to the pipeline
        $text
        Write-Verbose "[END    ] Ending $($myinvocation.MyCommand)"
    } #end

}
# IP Test Function.
Function IPTest {
    # Create IP Log Arrays
    $script:pingResults = @()
    $script:ipLogs = @()
    $ipLogFragments = @()

    # Add Header for IP Section
    $ipLogFragments += ConvertTo-Markdown -precontent "## IP Test Logs"

    # Loop through the list of IP addresses
    foreach ($ip in $ipList) {
        # Test network connectivity using ping
        $routeTest = Test-NetConnection $ip -Traceroute -ErrorAction SilentlyContinue 
        # Check if ping test was successful
        if ($routeTest) {
            $status = "Success"
            $responseTime = $routeTest.PingReplyDetails.RoundTripTime
            $ipLogFragments += ConvertTo-Markdown -precontent "### Tests for $ip"
            $ipLogFragments += $routeTest | ConvertTo-Markdown -precontent "#### Test Connecion"
            $ipLogFragments += tracert -d -h 12 $ip | ConvertTo-Markdown -precontent "#### Traceroute"
        } else {
            $status = "Failed"
            $responseTime = "N/A"
            $ipLogFragments += ConvertTo-Markdown -precontent "### Tests for $ip"
            $ipLogFragments += Test-NetConnection $ip -DiagnoseRouting -InformationLevel "Detailed" | ConvertTo-Markdown -precontent "#### Route Failed"
            $ipLogFragments += tracert -d -h 12 $ip | ConvertTo-Markdown -precontent "#### Traceroute"
        }
        # Create an object with the ping test results
        $ipObject = New-Object -TypeName PSObject -Property @{
            "IP Address" = $ip
            "Status" = $status
            "Response Time (ms)" = $responseTime
            "Interface" = $routeTest.InterfaceAlias
        }
        # Add the result object to the results array
        Write-Host $ipObject | Format-Table -AutoSize
        $script:pingResults += $ipObject
        $script:ipLogs += $ipLogFragments
    }
}
# HTTP Test Function.
Function HTTPTest {
    # Create HTTP Log Arrays
    $script:httpResults = @()
    $script:httpLogs = @()
    $httpLogFragments = @()
    # Add Section Title to Markdown report
    $httpLogFragments += ConvertTo-Markdown -precontent "## Domain Test Logs"
    # Loop through the list of Domains
    foreach ($domain in $httpList) {
        # Test network connectivity using ping
        $httpTest = Test-NetConnection $domain -CommonTCPPort "Http" -InformationLevel "Detailed" -ErrorAction SilentlyContinue
        $routeTest = Test-NetConnection $domain -Traceroute -ErrorAction SilentlyContinue
        # Check if ping test was successful
        if ($httpTest.TcpTestSucceeded) {
            $status = "Success"
            $responseTime = $routeTest.PingReplyDetails.RoundTripTime
            $httpLogFragments += ConvertTo-Markdown -precontent "### Tests for $domain Successfull"
            $httpLogFragments += $httpTest | ConvertTo-Markdown -precontent "#### HTTP Test"
            $httpLogFragments += $routeTest | ConvertTo-Markdown -precontent "#### Route Test"
            $httpLogFragments += tracert -d -h 12 $domain | ConvertTo-Markdown -precontent "#### Traceroute"
            
        } else {
            $status = "Failed"
            $responseTime = if($null -eq $routeTest.PingReplyDetails.RoundTripTime){"N/A"}else{$routeTest.PingReplyDetails.RoundTripTime}
            $httpLogFragments += ConvertTo-Markdown -precontent "### Tests for $domain Failed"
            $httpLogFragments += $httpTest | ConvertTo-Markdown -precontent "#### HTTP Test"
            $httpLogFragments += $httpTest.AllNameResolutionResults | ConvertTo-Markdown -precontent "#### DNS Results"
            $httpLogFragments += tracert -d -h 12 $domain | ConvertTo-Markdown -precontent "#### Traceroute"
        }
    
        # Create an object with the ping test results
        $httpObject = New-Object -TypeName PSObject -Property @{
            "Domain" = $domain
            "Status" = $status
            "IP Address" = $httpTest.RemoteAddress.IPAddressToString
            "Interface" = $httpTest.InterfaceAlias
            "Response Time (ms)" = $responseTime
            "DNS Status" = $httpTest.NameResolutionSucceeded
        }
        
        # Add the result object to the results array
        Write-Host $httpObject | Format-Table -AutoSize
        $script:httpResults += $httpObject
        $script:httpLogs += $httpLogFragments
    }
}
# Network Share Test.
Function ShareTest {
    # Create Network Share Log Arrays
    $script:shareResults = @()
    $script:shareLogs = @()
    $shareLogFragments = @()
    # Add Section Title to Markdown report
    $shareLogFragments += ConvertTo-Markdown -precontent "## Network Share Test Logs"
        # Loop through the list of Domains
        foreach ($share in $shareList) {
            # Test network connectivity using ping
            $pattern = '(?<=^\\.).+?(?=\\)'
            $shareHost = [regex]::Matches($share, $pattern).Value
            $shareTest = Test-Path -Path $share
            $resolveTest = Resolve-Path -Path $share 
            $routeTest = Test-NetConnection $shareHost -Traceroute -InformationLevel "Detailed" -ErrorAction SilentlyContinue
            # Check if ping test was successful
            if ($shareTest) {
                $status = "Success"
                $responseTime = $routeTest.PingReplyDetails.RoundTripTime
                $shareLogFragments += ConvertTo-Markdown -precontent "### Tests for $share Successfull"
                $shareLogFragments += $resolveTest | ConvertTo-Markdown -precontent "#### Network Share Test"
                $shareLogFragments += $routeTest | ConvertTo-Markdown -precontent "#### Route Test"
                
            } else {
                $status = "Failed"
                $responseTime = "N/A"
                $shareLogFragments += ConvertTo-Markdown -precontent "### Tests for $shareHost Failed"
                $ShareLogFragments += $routeTest | ConvertTo-Markdown -precontent "#### Share Network Test"
                $ShareLogFragments += $routeTest.AllNameResolutionResults | ConvertTo-Markdown -precontent "#### DNS Results"
                $ShareLogFragments += tracert -d -h 12 $shareHost | ConvertTo-Markdown -precontent "#### Traceroute"
            }
        
            # Create an object with the ping test results
            $shareObject = New-Object -TypeName PSObject -Property @{
                "Share" = $share
                "Status" = $status
                "IP Address" = $routeTest.RemoteAddress.IPAddressToString
                "Interface" = $routeTest.InterfaceAlias
                "Response Time (ms)" = $responseTime
                "DNS Status" = $httpTest.NameResolutionSucceeded
            }
            
            # Add the result object to the results array
            Write-Host $shareObject | Format-Table -AutoSize
            $script:shareResults += $shareObject
            $script:shareLogs += $shareLogFragments
        }
}
# Combine Table Arrays for Final Reporting.
Function CombineTables {
    if ($networkTest -eq "All"){
        # All Tests results combined
        $title = "$siteName Network Tests"
        $script:logResults += ConvertTo-Markdown -Title $title -PreContent $pre
        $script:logResults += ipconfig /all | ConvertTo-Markdown -precontent "## Network Info"
        $script:logResults += $script:pingResults | ConvertTo-Markdown -precontent "## Ping Test Results"
        $script:logResults += $script:httpResults | ConvertTo-Markdown -precontent "## Domain Test Results"
        $script:logResults += $script:shareResults | ConvertTo-Markdown -precontent "## Share Test Results"
        $script:logResults += $script:ipLogs
        $script:logResults += $script:httpLogs
        $script:logResults += $script:shareLogs
    } elseif ($networkTest -eq "ip") {
        # Network Ping Test restults
        $title = "$siteName Network Tests"
        $script:logResults += ConvertTo-Markdown -Title $title -PreContent $pre
        $script:logResults += ipconfig /all | ConvertTo-Markdown -precontent "## Network Info"
        $script:logResults += $script:pingResults | ConvertTo-Markdown -precontent "## Ping Test Results"
        $script:logResults += $script:ipLogs
    } elseif ($networkTest -eq "http"){
        # Website Test Results
        $title = "$siteName Network Tests"
        $script:logResults += ConvertTo-Markdown -Title $title -PreContent $pre
        $script:logResults += ipconfig /all | ConvertTo-Markdown -precontent "## Network Info"
        $script:logResults += $script:httpResults | ConvertTo-Markdown -precontent "## HTTP Test Results"
        $script:logResults += $script:httpLogs
    } elseif ($networkTest -eq "share"){
        # Network Share Test results
        $title = "$siteName Network Tests"
        $script:logResults += ConvertTo-Markdown -Title $title -PreContent $pre
        $script:logResults += ipconfig /all | ConvertTo-Markdown -precontent "## Network Info"
        $script:logResults += $script:shareResults | ConvertTo-Markdown -precontent "## Network Share Test Results"
        $script:logResults += $script:shareLogs
    } elseif ($networkTest -eq "httpScan"){
        # HTTP and IP tests Combined test results
        $title = "$siteName Network Tests"
        $script:logResults += ConvertTo-Markdown -Title $title -PreContent $pre
        $script:logResults += ipconfig /all | ConvertTo-Markdown -precontent "## Network Info"
        $script:logResults += $script:pingResults | ConvertTo-Markdown -precontent "## Ping Test Results"
        $script:logResults += $script:httpResults | ConvertTo-Markdown -precontent "## HTTP Test Results"
        $script:logResults += $script:ipLogs
        $script:logResults += $script:httpLogs
    } else {
    }
}
# Output to terminal and file.
Function OutputResults {
    if ($networkTest -eq "All"){
        # ALL Output the results to the console
        Write-Host "IP Test Results"
        $script:pingResults | Format-Table -AutoSize
        Write-Host "Domain Test Results"
        $script:httpResults | Format-Table -AutoSize
        Write-Host "Network Share Test Results"
        $script:shareResults | Format-Table -AutoSize
    } elseif ($networkTest -eq "ip"){
        # IP Output the results to the console
        Write-Host "IP Test Results"
        $script:pingResults | Format-Table -AutoSize
    }elseif ($networkTest -eq "http"){
        # HTTP Output the results to the console
        Write-Host "Domain Test Results"
        $script:httpResults | Format-Table -AutoSize
    } elseif ($networkTest -eq "share"){
        # Share Output the results to the console
        Write-Host "Network Share Test Results"
        $script:shareResults | Format-Table -AutoSize
    } elseif ($networkTest -eq "httpScan"){
        # httpScan Output the results to the console
        Write-Host "IP Test Results"
        $script:pingResults | Format-Table -AutoSize
        Write-Host "Domain Test Results"
        $script:httpResults | Format-Table -AutoSize
    }
    # Check if file path exists, if not it creates it.
    if (Test-Path -Path $filePathFull){
        # path exists
        $script:logResults | out-file -FilePath $logFile
    } else {
        # Path doesn't exist
        mkdir $filePathFull
        $script:logResults | out-file -FilePath $logFile
    }
}
# Create log file variables and array
Function CreateLog {
    # Set the path and name of the report file
    $script:filePathFull= "$output\NetworkTest\$siteName\"
    $script:logFile ="$filePathFull\$SiteName-LogFile-TT-$networkTest-$((Get-Date -format "MMM-dd-yyyy").ToString()).md"

    # Create an empty array to store the ping test results
    $script:logResults = @()
}

# Code Start
# Save current ProgressPreference settings
$OriginalPref = $ProgressPreference # Default is 'Continue'
# Disables Progress Bar
$ProgressPreference = "SilentlyContinue"

if ($networkTest -eq "All"){
    # Run all Tests
    $script:ipList = $ipList.split(',')
    $script:httpList = $httpList.split(',')
    $script:shareList = $shareList.split(',')
    CreateLog
    IPTest
    HTTPTest
    ShareTest
    CombineTables
    OutputResults
} elseif ($networkTest -eq "ip"){
    # Run only IP/Network Test
    $script:ipList = $ipList.split(',')
    $script:httpList = $httpList.Split(',')
    $script:shareList = $shareList.Split(',')
    CreateLog
    IPTest
    CombineTables
    OutputResults
}elseif ($networkTest -eq "http"){
    # HTTP Tests
    $script:httpList = $httpList.split(',')
    CreateLog
    HTTPTest
    CombineTables
    OutputResults
} elseif ($networkTest -eq "share"){
    # Network Share Tests
    $script:shareList = $shareList.split(',')
    CreateLog
    ShareTest
    CombineTables
    OutputResults
} elseif ($networkTest -eq "httpScan"){
    # HTTP and IP tests
    $script:ipList = $ipList.split(',')
    $script:httpList = $httpList.split(',')
    CreateLog
    IPTest
    HTTPTest
    CombineTables
    OutputResults
} else {
    Write-Host "Incorrect selection for type of test."
}

$ProgressPreference = $OriginalPref