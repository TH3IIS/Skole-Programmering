Clear-Host
# Renser skærmen før menuen skrives ud. 
Write-Host "
            #----------------------------------------------------------#
            #                 Enkle cmdlet opgaver                     #
            #                                                          #
            #                                                          #
            #   1. PowerShell versionen                                #
            #   2. HotFix’es på maskinen sorteret efter Description    #
            #   3. De ti største/længste filer på maskinen             #
            #                                                          #
            #   0. Slut                                                #
            #                                                          #
            #                                                          #
            #----------------------------------------------------------#
            "

Do # Starter en Do until
{
    $input = Read-Host "Hvilken opgave ønsker du udført?" # Tager imod inputtet og bruger det i switchen

    switch ($input) { # Switch som holder flere handlinger som i dette tilfælde udføres ud fra hvad input den møder.
        1 { Write-host $PSVersionTable.PSVersion } # Giver dig versionen af Powershell
        2 { Get-HotFix | Sort-Object Description -Descending } # Henter hotfixes og sortere efter beskrivelse
        3 {
            Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | # Fortæller hvilke filer der ligger i gældende "Path"
                Sort-Object Length -Descending | # Sortere efter at største fil ligger øverst i listen
                Select-Object -First 10 | # Viser kun de 10 første resultater
                Format-Table # Formatere outputtet til et table
        }
        0 { Clear-Host } # "Lukker menuen" ved at rydde teksten
        default {Write-host "Forkert input"} # Hvis man ikke angiver et af de menupunkter der er skriver den at den har modtaget forkert input
    }
} until ($input -eq 0) # Do until stopper når inputtet er 0 for at slutte