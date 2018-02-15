Function Get-Domain-Credential {
    $domainUser = [Environment]::UserDomainName+"\"+[Environment]::UserName

    $DomainCredentials = Get-Credential -Message "Domain Admin Credentials" -UserName $domainUser
    
    $DomainCredentials
}