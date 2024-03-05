<#net use \\10.192.20.35\Lovetand /user:data 1234abcd.
Set-Location c:\
Copy-Item *.csv -Destination c:\temp\loevetand

Set-Location \\10.192.20.35\Loevetand
#>

$RemoteCSV = "\\10.192.20.35\Loevetand\*.csv"
$LocalCSV = "C:\Users\Administrator\Documents\GitHub\Skole-Programmering\PowerShell\Case\csv\"

function FindCSVs
{

Param (
    $StartDate,
    $EndDate
)
    $CSVs = Get-ChildItem $RemoteCSV | Where-Object {($_.CreationTime -gt (Get-Date $StartDate)) -and ($_.CreationTime -lt (Get-Date $endDate))}

    ForEach ($CSV in $CSVs) {
        Copy-Item -Path $CSV.FullName -Destination $LocalCSV 
    }

}

$SavedDate = Import-Csv -Path ($ENV:TEMP + "\SavedDate.csv")

FindCSVs -StartDate "04-03-2024 08:00:00" -EndDate "04-03-2024 09:00:00"

function NewestCSV()
{
Get-ChildItem $RemoteCSV |
    Sort-Object CreationTime -Descending |
    Select-Object CreationTime -first 1 
}

