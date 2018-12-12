param (
    [string] $DomainController = (Get-ADDomain | Select-Object -Expand PDCEmulator),
    [Array] $Attributes = (1..15 | % {"extensionAttribute$_"})
)

Import-Module ActiveDirectory

ForEach ($Attribute in $Attributes) {
    $AttributeUsers = Get-ADUser -Properties $Attribute -Filter {$Attribute -like "*"} -Server $DomainController

    If ($AttributeUsers.Count -gt 0) {
        $AttributeUsers | Select sAMAccountName,Name,$Attribute | FT
    }
}