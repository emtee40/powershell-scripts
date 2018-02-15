Function Get-FileName {
    param (
        [string] $Filter,
        [string] $InitialDirectory
    )

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $InitialDirectory
    $OpenFileDialog.filter = $Filter
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}
