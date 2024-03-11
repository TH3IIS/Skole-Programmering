<#
    Funktionens formål er at hente dataen fra mappen, når den henter en fil gemmer den Creation time, når scriptet køres igen
#>

Function RemoteToLocal() 
{
    $RemoteCSV = "\\10.192.20.35\Loevetand\"
    $LocalCSV = "C:\csv\"
    $SavedDate = Import-Csv -Path "C:\SavedDate.csv" # Henter den gemte Creation time fra sidste data flytning

    $Files = Get-Item -Path ($RemoteCSV + "*.csv") | Where-Object {$_.CreationTime -gt (Get-Date $SavedDate.CreationTime)} # Henter liste over filer der er nyere end den gemte dato fra sidste flytning

    ForEach ($F in $Files) {
        Copy-Item -Path ($RemoteCSV + $F.Name) -Destination $LocalCSV #Flytter filen fra remote til den lokale maskine

        Get-ChildItem $RemoteCSV |
            Sort-Object CreationTime -Descending |
            Select-Object CreationTime -first 1 |
            Export-Csv -Path "C:\SavedDate.csv" # Opdatere filen med data fra den sidste fil der er blevet flyttet.
    }
}

RemoteToLocal # Eksekvere funktionen

<#
    Scriptet bliver opsat i Task scheduler og bliver kørt der igennem for at automatisere processen.
#>