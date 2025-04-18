Function Get-GraphHeaders {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$accessToken
    )
    # Define the authorization header
    $headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type"  = "application/json"
    }
    # Return the headers
    return $headers
}