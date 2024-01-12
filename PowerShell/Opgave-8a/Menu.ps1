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
            #   4. Computerens Produkt serienummer                     #
            #   5. Ledig hukommelse                                    #
            #                                                          #
            #   0. Slut                                                #
            #                                                          #
            #                                                          #
            #----------------------------------------------------------#
            "

Do # Starter en Do until
{
    $input = Read-Host "Hvilken opgave ønsker du udført?" # Tager imod inputtet og bruger det i switchen

    function PowerShellVersionNumber {
        Write-host $PSVersionTable.PSVersion # Giver dig versionen af Powershell
    }

    function HotFixByDescription {
        Get-HotFix | Sort-Object Description -Descending # Henter hotfixes og sortere efter beskrivelse
    }

    function Top10FilesOnPC {
        Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | # Fortæller hvilke filer der ligger i gældende "Path"
            Sort-Object Length -Descending | # Sortere efter at største fil ligger øverst i listen
            Select-Object -First 10 | # Viser kun de 10 første resultater
            Format-Table # Formatere outputtet til et table
    }

    function ProductSN { 
        Get-CimInstance -class win32_bios | #Henter data fra win32_bios
            select-object SerialNumber |# Vælger specifik række af data som skal vises
            format-table
    } 

    function LedigRAM { 
        Get-CimInstance -class Win32_OperatingSystem |# Henter data fra fra win32_OperatingSystem
            Select-Object FreePhysicalMemory, FreeVirtualMemory| # Vælger specifik rækker fra class'en som skal vises
            format-table
     } 

    function EndMenu { Clear-Host } 

    function WrongInput { Write-host "Forkert input" }

    switch ($input) { # Switch som holder flere handlinger som i dette tilfælde udføres ud fra hvad input den møder.
        1 { PowerShellVersionNumber } 
        2 { HotFixByDescription } 
        3 { Top10FilesOnPC }
        4 { ProductSN }
        5 { LedigRAM }
        0 { EndMenu } 
        default { WrongInput } # Hvis man ikke angiver et af de menupunkter der er skriver den at den har modtaget forkert input
    }

} until ($input -eq 0) # Do until stopper når inputtet er 0 for at slutte

