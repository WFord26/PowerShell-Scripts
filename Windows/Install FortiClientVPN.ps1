# FortiClientVPN installation file.
$dowknloadLink = "https://filestore.fortinet.com/forticlient/downloads/FortiClientVPNSetup_7.0.1.0083_x64.zip.zip"

$filepath = "C:\Temp"
# Checks for file path, if it does not exist it creates it.
if (!(Test-Path $filepath)) {

    New-Item -ItemType Directory -path $filepath -force -whatif:$false

}

$file = $filepath + "\FortiClient.zip"
$destination = $filepath + "\FortiClient"
$dfile = $destination + "\FortiClientVPN.msi"

# Option Speeds up Downloads
$ProgressPreference = 'SilentlyContinue'
# Downloads the Zip file from Fortinet server
#wget $downloadlink -OutFile $file
(New-Object System.Net.WebClient).DownloadFile("$dowknloadLink","$file")
powershell –c “(new-object System.Net.WebClient).DownloadFile($downloadlink,$file)”
Start-BitsTransfer -Source $dowknloadLink -Destination $file
#Invoke-WebRequest $downloadLink -OutFile $file
# Expands Zip file
Expand-Archive $file -DestinationPath $destination
# Runs installation quietly.
MsiExec.exe /i $dfile REBOOT=ReallySuppress /qn /l* "C:\Temp\Log.txt" | Out-Null  

# File clean up.
Remove-Item -path $dfile 
Remove-Item -path $destination -Recurse

