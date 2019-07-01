Function Get-SecureStringPassword {
    param(
        [String] $Prefix = ""
        ,[String] $Filename = ''
        ,[String] $Username = $env:UserName
        ,[String] $Message
    )

    If ($Prefix -ne "") {
        $Prefix = ($Prefix+"_")
    }

    If ($Filename -eq '') {
        $HostUser = $Env:ComputerName + $env:UserName
    #    Write-Output ('$HostUser: '+$HostUser)
        $MD5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
        $UTF8 = new-object -TypeName System.Text.UTF8Encoding
        $Hash = ([System.BitConverter]::ToString($MD5.ComputeHash($UTF8.GetBytes($HostUser)))).Replace("-","")
    #    Write-Output ('$Hash: '+$Hash)
        $Filename = ($Prefix+$Hash+".txt")
        Write-Host ('Retrieving credentials from: '+$Filename)
    }

    if ($Username -eq "") {
        $Username = $env:UserName
#        Write-Output ('Username empty, $Username: '+$Username)
    }

    if (Test-Path $Filename) {
#        Write-Output ('$Filename exists')
        $pwdTxt = Get-Content $Filename
        $securePwd = $pwdTxt | ConvertTo-SecureString
        $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $securePwd
    } else {
#        Write-Output ('File does not exist, requesting credential interactively')
#        Write-Log('Requesting Credentials...')
#        $Credentials = Get-Credential -UserName $Username -Message $Message
        Write-Host ("Username: "+$Username)
        $Password = Read-Host 'Password' -AsSecureString
        Set-SecureStringPassword -Password $Password -Prefix $Prefix
        $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $Password
    }
#    Write-Output ('Object Type: '+$Credentials.GetType().Name)
    Return $Credentials
}





Function Set-SecureStringPassword {
    param(
        [Parameter(Mandatory=$True)][Security.SecureString] $Password
        , [String] $Prefix = ""
        ,[String] $Filename = ''
    )

    If ($Prefix -ne "" -and $Prefix.Substring($Prefix.Length-1,1) -ne '_') {
        $Prefix = ($Prefix+"_")
    }

    If ($Filename -eq '') {
        $HostUser = $Env:ComputerName + $env:UserName
        $MD5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
        $UTF8 = new-object -TypeName System.Text.UTF8Encoding
        $Hash = ([System.BitConverter]::ToString($MD5.ComputeHash($UTF8.GetBytes($HostUser)))).Replace("-","")
        $Filename = ($Prefix+$Hash+".txt")
    }

    $SecureStringText = $Password | ConvertFrom-SecureString 
    Set-Content $Filename $SecureStringText
    #Write-Host ('Wrote SecureString to '+$filename+', Done')
}