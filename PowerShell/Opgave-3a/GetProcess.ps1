<#   OPGAVE 1-8   #>

$Filename = Read-Host "Hvad skal filen hedde?" #Tager imod input om hvad fil skal hedde

Get-Process | # Henter alle processor
    Sort-Object PM -Descending | # sortere efter PMs fra højest til lavest
    Where-Object {$_.Handles -gt 1000} | # viser kun hvis rækken har handles over 1000
    Select-Object Name, Id, Handles, PM -First 5 | # i tablet viser den name id handles og pm og kun de 5 højeste
    Export-Csv -Path .\$Filename.csv -NoClobber #opretter fil med ønsket navn fra Read-hosten

<#   OPGAVE 8-10   #>

Import-Csv -Path .\$Filename.csv | Sort-Object Handles -Descending  #importere den csv fil som bliver eksporteret i linje 9, og sortere efter handles

