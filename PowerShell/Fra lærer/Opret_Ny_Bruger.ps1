# Opret en bruger med alle indstillinger
cls


do {
    #spørg om login-navn
    write-host "___Ny bruger___"
    write-host ""
    $Loginnavn = read-host "Indtast login navn "
    if ($Loginnavn -eq "")  {return}
    #hvis bruger findes så
        #skriv "Bruger findes allerede"
        #retur i loop (1)
    #opret ad bruger i OU og skriv "Bruger ____ er oprettet"
    #opret personlig mappe og skriv "personlig mappe er oprettet"
    #del mappe
    #sæt rettigheder på mappe og share
    #loop (2)
    do {
        #spørg om gruppe 
        $gruppe = read-host "Indtast gruppe: "
        #hvis gruppe ikke findes så opret gruppen og skriv "Gruppe ___ er oprettet"
        #tilmeld bruger til gruppe og skriv "bruger ____ er nu medlem af gruppe _____"
    #hvis gruppe =* så stop ellers retur loop (2)
    }
    while ($gruppe -ne "")
#hvis login-navn =* så stop ellers retur loop (1)
write-host "=========================================="
}
while ($Loginnavn -ne "")