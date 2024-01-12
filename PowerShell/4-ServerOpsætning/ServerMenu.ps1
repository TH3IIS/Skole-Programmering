Clear-Host
# Renser skærmen før menuen skrives ud. 
Write-Host "
            #----------------------------------------------------------#
            #                     Server menu                          #
            #                                                          #
            #                                                          #
            #   1. Info om operativ system                             #
            #   2. Patchlevels/Hotfixes                                #
            #   3. IPv4, Subnet Mask, Default Gateway, DNS Server      #
            #   4. Shares (Alfabetisk orden)                           #
            #   5. Services som start automatisk                       #
            #   6. Tidspunkt for sidste genstart                       #
            #                                                          #
            #   0. Slut                                                #
            #                                                          #
            #                                                          #
            #----------------------------------------------------------#
            "

function EndMenu {
    Clear-Host # Lukker menuen, ved at fjerne al tekst i CLI'en
}

function WrongInput {
    Write-host "Forkert input, prøv igen" # Fejlmeddelelse hvis brugeren giver et forkert input til switchen
}

function OSInfo { <#    Opgave 10a      #>
    Get-CimInstance -ClassName Win32_OperatingSystem | # Henter CIM info fra Operating system
    Select-Object * | # Select * Giver alle informationer fra objektet
    Format-List # Formatere outputtet til en liste
}

function HotFixByDescription { <#   Opgave 10b      #>
    Get-HotFix | Sort-Object Description -Descending # Henter hotfixes og sortere efter beskrivelse
}

function NetworkInfo { <#   Opgave 10c      #>
    get-ciminstance Win32_NetworkAdapterConfiguration | # Henter CIM information om netværket
        Where-Object IPEnabled | # Vælger kun den driver der er slået til/i brug
        select-object IP,IPSubnet, DeafultGateway, DNSHostName | # Vælger kun relevant info
        format-list # Formatere outputtet til en liste
}

function GetShares { <#   Opgave 10d      #>
    $SharedNames = Get-CimInstance -ClassName Win32_Share # Henter Alles shares på Serveren
    $SharedPerms |
        ForEach-Object { $NamesAndPerms = Get-SmbShareAccess -name $SharedNames.Name | # Her bliver shares navnet taget og lagt i en anden cmdlet, og køres igennem en foreach så alle navne bliver kørt igennem da cmdletten ikke kan tage mere end 1 navn
            Select-Object Name, AccountName, AccessControlType, AccessRight | # Vælger kun de relevante info
            Format-Table # Formatere outputtet til en tabel da outputtet ikke vil poste og bugge menuen
        }
    $NamesAndPerms # Giver output
}

function AutomaticServices { <#   Opgave 10e      #>
    Get-Service | # Henter services
    Select-Object Name, Status, StartType | # Vælger kun relevant info til output
    Where-Object {$_.StartType -eq 'Automatic'} # Vælger kun services som starter automatisk
}

function LastReboot { <#   Opgave 10f      #>
    Get-CimInstance -ClassName Win32_OperatingSystem | # Henter CIM på Operativ system
    Select-Object LastBootUpTime | # Vælger kun LastBootUpTime  
    Format-Table # Formatere outputtet til en tabel da outputtet ikke vil poste og bugge menuen
}

<#      Opgave 10g      #>
Do # Starter en Do until
{
    $Userinput = Read-Host "Hvilken opgave ønsker du udført?" # Tager imod inputtet og bruger det i switchen

    switch ($Userinput) { # Switch som holder flere handlinger som i dette tilfælde udføres ud fra hvad input den møder.
        1 { OSInfo } # Kører funktionen hvis inputtet er 1, følgende for de andre i menuen
        2 { HotFixByDescription } 
        3 { NetworkInfo }
        4 { GetShares }
        5 { AutomaticServices }
        6 { LastReboot }
        0 { EndMenu } 
        default { WrongInput } # Hvis man ikke angiver et af de menupunkter der er skriver den at den har modtaget forkert input
    }

} until ($Userinput -eq 0) # Do until stopper når inputtet er 0 for at slutte
