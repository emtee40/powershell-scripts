function Invoke-SQL {
    param(
        [string] $DataSource = ".\SQLEXPRESS",
        [string] $Database = "MasterData",
        [string] $Query = $(throw "Please specify a query."),
        [PSCredential] $Credential = $null
      )

    $connectionString = "Data Source=$DataSource; " +
            "Integrated Security=SSPI; " +
            "Initial Catalog=$Database"

    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)

    if ($Credential -ne $null) {
        $connection.Credential = $Credential
    }

    $command = new-object system.data.sqlclient.sqlcommand($Query,$connection)
    $connection.Open()

    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null

    $connection.Close()
    $dataSet.Tables

}
