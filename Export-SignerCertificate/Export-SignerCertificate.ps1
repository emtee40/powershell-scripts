param (
    [Parameter(Mandatory=$true)][string]$FileName
)

$CertificateInfo = Get-AuthenticodeSignature $FileName
$CertificateData = [Convert]::ToBase64String($CertificateInfo.SignerCertificate.GetRawCertData()) -Replace '.{64}',"`$&`n"

@"
-----BEGIN CERTIFICATE-----
$CertificateData
-----END CERTIFICATE-----

"@

#  | Out-File -FilePath ($CertificateInfo.SignerCertificate.Thumbprint + '.cer')