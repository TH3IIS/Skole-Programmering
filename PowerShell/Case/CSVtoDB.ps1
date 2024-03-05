$Server = "FYS-NTYP"
$Database = "Gartneri"
$uid ="sa"
$pwd = "1234abcd."
$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server='$Server';database='$Database'; User ID = $uid; Password = $pwd;"
$Connection.Open()

$RemoteCSV = "\\10.192.20.35\Loevetand\*.csv"
$LocalCSV = "C:\Users\Administrator\Documents\GitHub\Skole-Programmering\PowerShell\Case\csv\*.csv"

# $command bliver erklæret som en speciel datatype der bruges til at eksekvere 
# SQL kommandoer mod den database der er etableret forbindelse til herover.
# $command bruges i flere af funktionerne herunder.
$command = New-Object System.Data.SqlClient.SqlCommand
$command.Connection = $Connection

Function ToMaalerTabel() 
{
Import-Csv -Path $LocalCSV
    ForEach-Object ($MaalerNr = $_.MaalerId), ($MaalerType = $_.Type) {

        $command.CommandText = "Insert into Gartner.Maaler ([MaalerNr],[MaalerType]) Values ($($MaalerNr),$($MaalerType))"
        
        $command.ExecuteReader();
    }
}

Function ToMaalingTabel() 
{

    $command.CommandText = "Insert into Administration.Maaling ([MaalerNr],[Tidspunkt],[MaaltVaerdi]) Values ($($MaalerNr),$($Tidspunkt),$($MaaltVaerdi))"
    
    $command.CommandText;
    $command.ExecuteNonQuery(); 

}