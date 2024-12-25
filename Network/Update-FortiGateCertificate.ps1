# Take Files C:\Temp\API\Wildcard.key and C:\Temp\API\Wildcard.crt and create variables for them
$Key = Get-Content -Path C:\Temp\API\Wildcard.key
$Cert = Get-Content -Path C:\Temp\API\Wildcard.crt

# Remove the first and last lines in each variables
$Key = $Key[1..($Key.Length - 2)]
$Cert = $Cert[1..($Cert.Length - 2)]

# Remove line breaks in each variable so that they are one line
$Key = $Key -join ""
$Cert = $Cert -join ""

curl -X POST -H "Content-Type: application/json" -d {
    "name": "Wildcard",
    "comments": "Wildcard Certificate",
    "certificate": "$Cert",
    "private-key": "$Key"
  } "https://fortigate.mtnmanit.com:8443/api/v2/monitor/vpn-certificate/local/import?scope=global&access_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjEw"