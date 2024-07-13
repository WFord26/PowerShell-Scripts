<#
.SYNOPSIS
    This script will run a speed test on the computer and submit the results to a Microsoft Form.
.DESCRIPTION
    This script will run a speed test on the computer and submit the results to a Microsoft Form.
    The script will check if the speed test executable exists on the computer. If it does not exist, the script will download the speed test executable and run the speed test.
    The script will then submit the results to a Microsoft Form.
.PARAMETER serverLocation
    The server location to run the speed test against. Default is 47552.
.PARAMETER speedTestExe
    The path to the speed test executable. Default is 'C:\Temp\speedtest\speedtest.exe'.
.PARAMETER DownloadURL
    The URL to download the speed test executable. Default is "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip".
.EXAMPLE
    Run-SpeedTest.ps1 -serverLocation 47552 -speedTestExe 'C:\Temp\speedtest\speedtest.exe' -DownloadURL "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"
    This example will run a speed test on the computer and submit the results to a Microsoft Form.
.NOTES
    File Name      : Run-SpeedTest.ps1
    Author         : William Ford (@WFord26)
    Date           : 2024-07-12
    Version        : 1.0
    Change History : 1.0 - Initial version
    Prerequisite   : PowerShell V2
#>

param (
    [int]$serverLocation = 47552,
    [string]$speedTestExe = 'C:\Temp\speedtest\speedtest.exe',
    [string]$DownloadURL = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"
)

Function formEntry {
    param (
        [string]$q1,
        [string]$q2,
        [string]$q3,
        [string]$q4,
        [string]$q5,
        [string]$q6,
        [string]$q7,
        [string]$q8
    )
    process {
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0"
        Invoke-WebRequest -UseBasicParsing -Uri "https://forms.office.com/formapi/api/271cf5e9-b477-4759-a5d6-6d459bb35f3e/users/769fcfc0-5a70-4751-8b2a-4262fe8984ca/forms('6fUcJ3e0WUel1m1Fm7NfPsDPn3ZwWlFHiypCYv6JhMpUNkFQOURKV0owOVJMOTdFM1k3NlhSWFZQVi4u')/responses" `
        -Method "POST" `
        -WebSession $session `
        -Headers @{
        "authority"="forms.office.com"
        "method"="POST"
        "path"="/formapi/api/271cf5e9-b477-4759-a5d6-6d459bb35f3e/users/769fcfc0-5a70-4751-8b2a-4262fe8984ca/forms('6fUcJ3e0WUel1m1Fm7NfPsDPn3ZwWlFHiypCYv6JhMpUNkFQOURKV0owOVJMOTdFM1k3NlhSWFZQVi4u')/responses"
        "scheme"="https"
        "__requestverificationtoken"="Q1tcBxM0dj8tqsoIdPrc5DMo1Ey9U8c6rf4tsM1lAHIRvLKuduJI78yR_YLK6jZ_yaAptjQvNKIqzbamPQM0Ihn7CPC2w8bLh8k1VRzSfdR6sspUUnxoizenHFAQSsKrUKL8GYiVOxfolrZUHAY3Ew2"
        "accept"="application/json"
        "accept-encoding"="gzip, deflate, br, zstd"
        "accept-language"="en-US,en;q=0.9"
        "authorization"=""
        "dnt"="1"
        "odata-maxverion"="4.0"
        "odata-version"="4.0"
        "origin"="https://forms.office.com"
        "priority"="u=1, i"
        "referer"="https://forms.office.com/Pages/ResponsePage.aspx?id=6fUcJ3e0WUel1m1Fm7NfPsDPn3ZwWlFHiypCYv6JhMpUNkFQOURKV0owOVJMOTdFM1k3NlhSWFZQVi4u"
        "sec-ch-ua"="`"Not/A)Brand`";v=`"8`", `"Chromium`";v=`"126`", `"Microsoft Edge`";v=`"126`""
        "sec-ch-ua-mobile"="?0"
        "sec-ch-ua-platform"="`"Windows`""
        "sec-fetch-dest"="empty"
        "sec-fetch-mode"="cors"
        "sec-fetch-site"="same-origin"
        "x-correlationid"="421a59d3-c982-4e25-9137-548b4f46e60f"
        "x-edge-shopping-flag"="1"
        "x-ms-form-muid"="0B491EFB33F261EE19270AF7329D601C"
        "x-ms-form-request-ring"="business"
        "x-ms-form-request-source"="ms-formweb"
        "x-usersessionid"="17693d06-731d-4269-8244-9afb4d49997a"
        } `
        -ContentType "application/json" `
        -Body "{`"startDate`":`"2024-07-12T23:48:50.024Z`",`"submitDate`":`"2024-07-12T23:49:37.720Z`",`"answers`":`"[{\`"questionId\`":\`"rb53980291c8b493c8ed5fb709e527f71\`",\`"answer1\`":\`"$q1\`"},{\`"questionId\`":\`"rce8f0215991045b8a35d0629e6232bb8\`",\`"answer1\`":\`"$q2\`"},{\`"questionId\`":\`"r63b8f050fc51463cacac2d4d97370227\`",\`"answer1\`":\`"$q3\`"},{\`"questionId\`":\`"r10b49a13a6dd48c18fa2552abd9c66c9\`",\`"answer1\`":\`"$q4\`"},{\`"questionId\`":\`"r1afc4dfe7223435688fb3790f2747856\`",\`"answer1\`":\`"$q5\`"},{\`"questionId\`":\`"rddca130ab5ac4cd99f9872517c3b892f\`",\`"answer1\`":\`"$q6\`"},{\`"questionId\`":\`"rdc5320917f2f42729bb3cdd0d511a362\`",\`"answer1\`":\`"$q7\`"},{\`"questionId\`":\`"r3985db2b6edb4cf39f9ac04f7ee85350\`",\`"answer1\`":\`"$q8\`"}]`"}";

    }
}

Function speedtestcli {
    param (
        [int]$serverLocation,
        [string]$speedTestExe
    )
    process {
        # Speed Test command
        $speedTestCMD = & $speedTestExe --accept-license -f json -s $serverLocation
        # Run Speed Test
        $speedTestOutput = ConvertFrom-Json $speedTestCMD
        # Confirm Speed Test output is valid
        if ($speedTestOutput.Type -ne 'result') {
            Write-Host "Speed Test failed. Please try again."
            exit
        } else {
            $compname = hostname
            $downloadSpeed = [math]::Round($speedTestOutput.Download.Bandwidth / 125000, 2)
            $uploadSpeed = [math]::Round($speedTestOutput.Upload.Bandwidth / 125000, 2)
            formEntry -q1 $uploadSpeed -q2 $downloadSpeed -q3 $speedTestOutput.Ping.Latency -q4 $speedTestOutput.isp -q5 $speedTestOutput.interface.internalIP -q6 $speedTestOutput.interface.externalIP -q7 $speedTestOutput.Server.id -q8 $compname -$q9 
        }
    }
}
# Check if Speed Test executable exists on computer.
if (Test-Path $speedTestExe) {
    speedtestcli -serverLocation $serverLocation -speedTestExe $speedTestExe
} else {
    # Check if 'C:\Temp\speedtest' directory exists
    if (-not (Test-Path 'C:\Temp')) {
        # Create 'C:\Temp\speedtest' directory
        New-Item -Path 'C:\Temp' -ItemType Directory
    }
    # Download Speed Test CLI
    Invoke-WebRequest -Uri $DownloadURL -OutFile 'C:\Temp\speedtest.zip'
    # Extract Speed Test CLI
    Expand-Archive -Path 'C:\Temp\speedtest.zip' -DestinationPath 'C:\Temp\speedtest'
    # Run Speed Test
    speedtestcli -serverLocation $serverLocation -speedTestExe $speedTestExe
}
# Write-Host "Speed Test completed."
Write-Host "Speed Test completed."
