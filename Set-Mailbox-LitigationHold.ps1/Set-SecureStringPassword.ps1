$hostuser = $env:computername + $env:UserName
$md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = new-object -TypeName System.Text.UTF8Encoding
$hash = ([System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($hostuser)))).Replace("-","")
$filename = ($hash+".txt")

$StringText = Read-Host 'Password' -AsSecureString
$secureStringText = $StringText | ConvertFrom-SecureString 
Set-Content $filename $secureStringText
Write-Host ('Wrote SecureString to '+$filename+', Done')

# To Read
<#
if (Test-Path $filename) {
    $pwdTxt = Get-Content $filename
    $securePwd = $pwdTxt | ConvertTo-SecureString 
    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $env:UserName, $securePwd
} else {
    Write-Log('Requesting Credentials...')
    $Credentials = Get-Credential -UserName $env:UserName
}
#>