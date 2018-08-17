param(
    [string]$Path = ".\*.csv",
    [string]$OutputFile = "combined-"+(Get-Date -Format "yyyy-MM-dd")+"_"+(Get-Date -format "HHmm")+".csv"
)

$Files = Get-ChildItem -Path $Path

$AllData = New-Object System.Data.DataTable

ForEach ($File in $Files) {
    $FileData = Import-Csv -Path $File

    $Columns = $FileData.PSObject.Members | Where MemberType -eq NoteProperty | Select -Expand Name
    
    ForEach ($Column in $Columns) {
        if (-Not $AllData.Columns.Contains($Column)) {
            [void]$AllData.Columns.Add($Column)
        }
    }

    ForEach ($FileDataRow in $FileData) {
        $Row = $AllData.NewRow()
        ForEach ($AllDataColumn in $AllData.Columns) {
            $Row.$AllDataColumn = $FileDataRow.($AllDataColumn.ColumnName)
        }
        $AllData.Rows.Add($Row)
    }
}

$AllData | Export-Csv -Path $OutputFile -NoTypeInformation
