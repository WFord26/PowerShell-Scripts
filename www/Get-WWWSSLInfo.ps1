function Get-WWWSSLInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$url,
        [Parameter(Mandatory = $false)]
        [string]$port
    )

    try {
        # Check if URL has https://
        if ($url -notmatch "^https://") {
            $url = "https://$($url)"
        }
        
        Write-Verbose "URL: $url"

        # If port is specified, append it to the URL
        if ($port) {
            $url = "$($url):$($port)"
            Write-Verbose "URL with port: $url"
        }
        
        $request = [Net.HttpWebRequest]::Create($url)
        $request.ServerCertificateValidationCallback = { $true }
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
        $request.GetResponse() | Out-Null
        $cert = $request.ServicePoint.Certificate
        $cert2 = New-Object Security.Cryptography.X509Certificates.X509Certificate2 $cert

        $certInfo = @{
            Subject = $cert2.Subject
            Issuer = $cert2.Issuer
            EffectiveDate = $cert2.NotBefore
            ExpiryDate = $cert2.NotAfter
            Thumbprint = $cert2.Thumbprint
        }

        $certInfo
    } catch {
        Write-Error "Failed to retrieve certificate information: $_"
    }
}