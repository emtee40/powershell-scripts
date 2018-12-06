Function Wait-Until {
    param (
        [Parameter(Mandatory=$True,Position=1)][string] $Script,
        [int] $Pause = 1
    )

    $ScriptBlock = [scriptblock]::Create($Script)

    Do {
        $Result = Invoke-Command -ScriptBlock $ScriptBlock
        Start-Sleep $Pause
    } While ($Result -eq $False -or $Result -eq $null -or $Result -eq [DBNull]::Value)
}