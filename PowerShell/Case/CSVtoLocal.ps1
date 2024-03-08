$RemoteCSV = "\\10.192.20.35\Loevetand\"
$LocalCSV = "C:\Users\Administrator\Documents\GitHub\Skole-Programmering\PowerShell\Case\csv\"

Function RemoteToLocal() 
{
    $RemoteCSV = "\\10.192.20.35\Loevetand\"
    $LocalCSV = "C:\csv\"
    $SavedDate = Import-Csv -Path "C:\SavedDate.csv"

    $Files = Get-Item -Path ($RemoteCSV + "*.csv") | Where-Object {$_.CreationTime -gt (Get-Date $SavedDate.CreationTime)}

    ForEach ($F in $Files) {
        Copy-Item -Path ($RemoteCSV + $F.Name) -Destination $LocalCSV 

        Get-ChildItem $RemoteCSV |
            Sort-Object CreationTime -Descending |
            Select-Object CreationTime -first 1 |
            Export-Csv -Path "C:\SavedDate.csv"
    }
}

#RemoteToLocal

# Nyeste version på 2016-SQL

Set-Location -Path $RemoteCSV