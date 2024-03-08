$Server = "FYS-NTYP"
$Database = "Gartneri"
$uid ="sa"
$pwd = "1234abcd."
$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server='$Server';database='$Database'; User ID = $uid; Password = $pwd;"
$Connection.Open()

$RemoteCSV = "\\10.192.20.35\Loevetand\*.csv"
$LocalCSV = "C:\Users\Administrator\Documents\GitHub\Skole-Programmering\PowerShell\Case\csv\"
$UsedCSV = "C:\Users\Administrator\Documents\GitHub\Skole-Programmering\PowerShell\Case\csv\used\"
$Files = Get-item -Path "C:\Users\Administrator\Documents\GitHub\Skole-Programmering\PowerShell\Case\csv\*.csv"


# $command bliver erklæret som en speciel datatype der bruges til at eksekvere 
# SQL kommandoer mod den database der er etableret forbindelse til herover.
# $command bruges i flere af funktionerne herunder.
$command = New-Object System.Data.SqlClient.SqlCommand
$command.Connection = $Connection

Function CSVtoTables() 
{
    $command.CommandText = "Select * FROM Gartner.Maaler"
    $sqlReader = $command.ExecuteReader();
    $sqlReader.Read()

    If ($sqlReader["MaalerNr"] -gt 100000) {
        $sqlReader.Close()
        write-host 'No insert into Maaler'
    }
    Else { 
        $sqlReader.Close()   
        $Type1 = Get-ChildItem -Filter '1*' -Path $LocalCSV | Select-Object -First 1
        $Type2 = Get-ChildItem -Filter '2*' -Path $LocalCSV | Select-Object -First 1
        $Type3 = Get-ChildItem -Filter '3*' -Path $LocalCSV | Select-Object -First 1
        $Type4 = Get-ChildItem -Filter '4*' -Path $LocalCSV | Select-Object -First 1
        
        Import-Csv -Path ($LocalCSV + $Type1.Name) -Delimiter ";" | 
            ForEach-Object { ($MaalerNr = $_.MaalerId), ($MaalerType = $_.Type);
                $command.CommandText = "Insert into Gartner.Maaler ([MaalerNr],[MaalerType],[Maaleenhed]) Values ($($MaalerNr), 'Temperatur', 'Celcius')"
        
                $command.CommandText;
                $command.ExecuteNonQuery(); 
            }
        
        Import-Csv -Path ($LocalCSV + $Type2.Name) -Delimiter ";" | 
            ForEach-Object { ($MaalerNr = $_.MaalerId), ($MaalerType = $_.Type);
                $command.CommandText = "Insert into Gartner.Maaler ([MaalerNr],[MaalerType],[Maaleenhed]) Values ($($MaalerNr), 'Vand', 'Procent')"
        
                $command.CommandText;
                $command.ExecuteNonQuery(); 
            }
        
        Import-Csv -Path ($LocalCSV + $Type3.Name) -Delimiter ";" | 
            ForEach-Object { ($MaalerNr = $_.MaalerId), ($MaalerType = $_.Type);
                $command.CommandText = "Insert into Gartner.Maaler ([MaalerNr],[MaalerType]) Values ($($MaalerNr), 'Gødning')"
        
                $command.CommandText;
                $command.ExecuteNonQuery(); 
            }
        
        Import-Csv -Path ($LocalCSV + $Type4.Name) -Delimiter ";" | 
            ForEach-Object { ($MaalerNr = $_.MaalerId), ($MaalerType = $_.Type);
                $command.CommandText = "Insert into Gartner.Maaler ([MaalerNr],[MaalerType],[Maaleenhed]) Values ($($MaalerNr), 'Lys', 'Lux')"
        
                $command.CommandText;
                $command.ExecuteNonQuery(); 
            }
    }
    Foreach ($F in $Files) {
    <#  MAALER TABEL    
    
    <#  MAALING TABEL   #>
    Import-Csv -Path ($LocalCSV + $F.Name) -Delimiter ";" |
        ForEach-Object { ($MaalingNr = $_.MaalerId), ($Tidspunkt = $_.Tidspunkt), ($Maaling = $_.Maaling);

            $DateTime = Get-date $Tidspunkt -Format "yyyy-MM-dd HH:mm"

            $command.CommandText = "Insert into Administration.Maaling ([MaalerNr],[Tidspunkt],[MaaltVaerdi]) Values ($($MaalingNr), '$($DateTime)', $($Maaling.Replace(',', '.')))"
            
            $command.CommandText;
            $command.ExecuteNonQuery();
        }
    
    <# Flytning af Fil til "Brugt mappe" så data ikke bliver indlæst igen #>
    
    Move-Item -Path ($LocalCSV + $F.Name) -Destination $UsedCSV 

    }
}

CSVtoTables