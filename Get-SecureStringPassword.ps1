Function Get-SecureStringPassword {
    param(
        [String] $Filename
        ,[String] $Username
    )

    if ($Filename -eq "") {
        $hostuser = $env:computername + $env:UserName
        $md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
        $utf8 = new-object -TypeName System.Text.UTF8Encoding
        $hash = ([System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($hostuser)))).Replace("-","")
        $Filename = ($hash+".txt")
    }

    if ($Username -eq "") {
        $Username = $env:UserName
    }

    if (Test-Path $Filename) {
        $pwdTxt = Get-Content $Filename
        $securePwd = $pwdTxt | ConvertTo-SecureString 
        $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $securePwd
    } else {
        Write-Log('Requesting Credentials...')
        $Credentials = Get-Credential -UserName $env:UserName
    }

    $Credentials
}