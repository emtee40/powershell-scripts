Function Wait-Until {
    param (
        [Parameter(Mandatory=$True,Position=1)][string] $Script,
        [int] $Pause = 1
    )

    $ScriptBlock = [scriptblock]::Create($Script)

    While ((Invoke-Command -ScriptBlock $ScriptBlock) -eq $False -or (Invoke-Command -ScriptBlock $ScriptBlock) -eq $null) {
        Start-Sleep $Pause
    }
}
