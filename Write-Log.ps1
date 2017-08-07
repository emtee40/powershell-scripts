Function Write-Log($string, $color) {
# Colors: [enum]::GetValues([System.ConsoleColor]) | Foreach-Object {Write-Host $_ -ForegroundColor $_}
    $timestamp = Get-Date -Format "s"
    $oldFGcolor = $host.ui.RawUI.ForegroundColor
    if ($color -ne $null) {
        $host.ui.RawUI.ForegroundColor = $color
        Write-Output ("["+$timestamp+"] " + $string)
        $host.ui.RawUI.ForegroundColor = $oldFGcolor
    } else {
        Write-Output ("["+$timestamp+"] " + $string)
    }
}