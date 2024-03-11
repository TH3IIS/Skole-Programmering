$Server = "2016-SQL" # Server/PC navn
$Database = "Gartneri" # Databse Navn
$uid ="PSUser" # Database bruger
$pwd = "1234abcd." # Database brugerkode

# Forbinder til Databasen
$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server='$Server';database='$Database'; User ID = $uid; Password = $pwd;"
$Connection.Open()

# Stier som bruges til at flytte data
$LocalCSV = "C:\csv\"
$UsedCSV = "C:\csv\used\"
$Files = Get-item -Path "C:\csv\*.csv" # Giver dig en liste med alle csv filer i mappen


# $command bliver erklæret som en speciel datatype der bruges til at eksekvere 
# SQL kommandoer mod den database der er etableret forbindelse til herover.
# $command bruges i flere af funktionerne herunder.
$command = New-Object System.Data.SqlClient.SqlCommand
$command.Connection = $Connection

Function CSVtoTables() 
{
    <#  MAALER TABEL  #>
    $command.CommandText = "Select * FROM Gartner.Maaler"
    $sqlReader = $command.ExecuteReader();
    $sqlReader.Read() # Readeren læser Maalerdatabasen

    If ($sqlReader["MaalerNr"] -gt 100000) { # Her laves if statement på maalertabellen hvis der er en værdi over 100000 lukker den igen, hvis ikke indlæser den maalere der er for hver maalertype
        $sqlReader.Close()
        write-host 'No insert into Maaler'
    }
    Else { 
        $sqlReader.Close()   
        $Type1 = Get-ChildItem -Filter '1*' -Path $LocalCSV | Select-Object -First 1 # Finder den første fil der starter med 1 i navnet for at kunne tage alle maalenumre i i første maaletype
        $Type2 = Get-ChildItem -Filter '2*' -Path $LocalCSV | Select-Object -First 1
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
        
        Import-Csv -Path ($LocalCSV + $Type4.Name) -Delimiter ";" | 
            ForEach-Object { ($MaalerNr = $_.MaalerId), ($MaalerType = $_.Type);
                $command.CommandText = "Insert into Gartner.Maaler ([MaalerNr],[MaalerType],[Maaleenhed]) Values ($($MaalerNr), 'Lys', 'Lux')"
        
                $command.CommandText;
                $command.ExecuteNonQuery(); 
            }
    }
    Foreach ($F in $Files) {   
    <#  MAALING TABEL   #>
    Import-Csv -Path ($LocalCSV + $F.Name) -Delimiter ";" |
        ForEach-Object { ($MaalingNr = $_.MaalerId), ($Tidspunkt = $_.Tidspunkt), ($Maaling = $_.Maaling);

            $DateTime = Get-date $Tidspunkt -Format "yyyy-MM-dd HH:mm" # Formatering af dato og tid der er i csv filen så det passer med databasens format af datetime

            $command.CommandText = "Insert into Administration.Maaling ([MaalerNr],[Tidspunkt],[MaaltVaerdi]) Values ($($MaalingNr), '$($DateTime)', $($Maaling.Replace(',', '.')))"
            
            $command.CommandText;
            $command.ExecuteNonQuery();
        }
    
    <# Flytning af Fil til "Brugt mappe" saa data ikke bliver indlaest igen #>
    
    Move-Item -Path ($LocalCSV + $F.Name) -Destination $UsedCSV -Force # Når dataene i filen er indsat bliver filen flyttet videre så den ikke indsættes igen

    }
}

CSVtoTables # Funktionen eksekveres

<#
    Scriptet bliver opsat i Task scheduler og bliver kørt der igennem for at automatisere processen.
#>