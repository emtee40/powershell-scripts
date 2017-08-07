. ..\Write-Log.ps1

$TenantDomain = "@domain.com"
$TenantUserName = "user@tenant.onmicrosoft.com"
$E3 = "tenant:ENTERPRISEPACK"

$date = Get-Date -Format "yyyy-MM-dd"
$time = Get-Date -format "HHmm"

if (-Not (Test-Path ($PSScriptRoot+"\logs\"))) {
    Write-Log "Creating logs folder"
    New-Item "logs" -Type Directory
}

Start-Transcript -Path ($PSScriptRoot + "\logs\"+$date+"-"+$time+".txt")

$filename = ($env:computername + "_" + $env:UserName + "_securestring.txt")

if (Test-Path $filename) {
    $pwdTxt = Get-Content $filename
    $securePwd = $pwdTxt | ConvertTo-SecureString 
    $TenantCredentials = New-Object System.Management.Automation.PSCredential -ArgumentList $TenantUserName, $securePwd
} else {
    Write-Log('Requesting Tenant Credentials...')
    $TenantCredentials = Get-Credential -Message "O365 Credentials" -UserName $TenantUserName
}

if ($TenantCredentials -eq $null) {
    Write-Log 'Tenant credentials not supplied, exiting'
    exit
}

Write-Log('Creating remote PSSession')
$PSSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $TenantCredentials -Authentication Basic -AllowRedirection
if ($PSSession) {
    Write-Log('Importing PSSession')
    Import-PSSession $PSSession -AllowClobber
} else {
    Write-Log 'Could not connect to Exchange Online' Red
    Exit
}

Write-Log "Connecting to MSOLService"
Connect-MsolService -Credential $TenantCredentials

$mailboxes = Get-Mailbox -ResultSize Unlimited -Filter {LitigationHoldEnabled -eq $false -and RecipientTypeDetails -eq "UserMailbox"}
$mailboxed_modified = 0

foreach ($mailbox in $mailboxes) {
    $user = Get-MsolUser -UserPrincipalName $mailbox.UserPrincipalName
    if ($user.Licenses.AccountSkuId -eq $E3) {
        $mailboxes_modified++
        Write-Log ('Enabling Litigation Hold for '+$user.DisplayName)
        Set-Mailbox ($mailbox.PrimarySmtpAddress) -LitigationHoldEnabled $true -LitigationHoldDuration 2555
    } else {
        Write-Log ($user.DisplayName+' does not have an E3 license')
    }
}

Write-Log('Removing PSSession')
Remove-PSSession $PSSession

Stop-Transcript

if ($mailboxes_modified -gt 0) {
    # Send email with text from transcription

    $body = "<pre>"+(Get-Content ($PSScriptRoot + "\logs\"+$date+"-"+$time+".txt") | Out-String)+"</pre>"
    send-mailmessage -to recipient@domain.com -subject ("Litigation Hold: "+$mailboxes_modified+" Mailboxes Added") -smtpserver smtp.domain.com -from Set-Mailbox-LitigationHold.ps1@server -body $body -BodyAsHtml
}

#Invoke-Item ($PSScriptRoot + "\logs\"+$date+"-"+$time+".txt")
