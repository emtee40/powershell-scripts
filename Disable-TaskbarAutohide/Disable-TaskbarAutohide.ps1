. ..\Write-Log.ps1

$AutoHideEnabled = 3
$AutoHideDisabled = 2

While ($true) {
	$UserHives = Get-ChildItem Registry::HKU

	foreach ($Hive in $UserHives) {
		$Path = $Hive.Name+"\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects2"

		if (Test-Path Registry::$Path) {
			$Existing = Get-ItemProperty -Path Registry::$Path -Name Settings

			if ($Existing.Settings[8] -eq $AutoHideEnabled) {
				Write-Log ($Hive.Name)
				$Existing.Settings[8] = $AutoHideDisabled
				Set-ItemProperty -Path Registry::$Path -Name Settings -Value ($Existing.Settings)
			}
		}
	}

	Start-Sleep -s 1
}