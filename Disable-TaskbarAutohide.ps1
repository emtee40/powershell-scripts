try{
    . ..\Write-Log.ps1
} catch {}

$AutoHide = @{
    Enabled = 3
    Disabled = 2
}

$TaskbarPosition = @{
    Top=1
    Bottom=3
}

While ($true) {
	$UserHives = Get-ChildItem Registry::HKU

	foreach ($Hive in $UserHives) {
		$Path = $Hive.Name+"\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects2"

		if (Test-Path Registry::$Path) {
			$Existing = Get-ItemProperty -Path Registry::$Path -Name Settings

			if ($Existing.Settings[8] -eq $AutoHide.Enabled) {
				Write-Log ($Hive.Name)
				$Existing.Settings[8] = $AutoHide.Disabled
				Set-ItemProperty -Path Registry::$Path -Name Settings -Value ($Existing.Settings)
			}

            		if ($Existing.Settings[12] -eq $TaskbarPosition.Top) {
				Write-Log ($Hive.Name)
				$Existing.Settings[12] = $TaskbarPosition.Bottom
				Set-ItemProperty -Path Registry::$Path -Name Settings -Value ($Existing.Settings)
			}
		}
	}

	Start-Sleep -s 1
}
