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


# Functions out here trying to Function
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
# IP Test Function
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
        $script:pingResults += $ipObject
        $script:ipLogs += $ipLogFragments
    }
}
# HTTP Test Function
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
        if ($httpTest) {
            $status = "Success"
            $responseTime = $routeTest.PingReplyDetails.RoundTripTime
            $httpLogFragments += ConvertTo-Markdown -precontent "### Tests for $domain Successfull"
            $httpLogFragments += $httpTest | ConvertTo-Markdown -precontent "#### HTTP Test"
            $httpLogFragments += $routeTest | ConvertTo-Markdown -precontent "#### Route Test"
            $httpLogFragments += tracert -d -h 12 $domain | ConvertTo-Markdown -precontent "#### Traceroute"
            
        } else {
            $status = "Failed"
            $responseTime = "N/A"
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
        $script:httpResults += $httpObject
        $script:httpLogs += $httpLogFragments
    }
}
$ipList
$ipList = $ipList.split(',')
$ipList