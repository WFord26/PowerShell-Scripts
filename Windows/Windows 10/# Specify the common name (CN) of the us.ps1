# Specify the common name (CN) of the user for whom you want to request a certificate
$commonName = "John Doe"

# Specify the output file path for the certificate request
$certRequestFile = "C:\Path\to\output.csr"

# Generate the certificate request using certutil
certutil -user -new -f "CN=$commonName" $certRequestFile