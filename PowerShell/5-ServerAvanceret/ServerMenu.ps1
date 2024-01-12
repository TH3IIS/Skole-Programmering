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
            #   7. Opret en Virtuel Maskine                            #
            #   8. Slet en Virtuel Maskine                             #
            #   9. Vis liste over virtuelle maskiner                   #
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

function OSInfo { <#    Opgave "Server Opsætning"a      #>
    Get-CimInstance -ClassName Win32_OperatingSystem | # Henter CIM info fra Operating system
    Select-Object * | # Select * Giver alle informationer fra objektet
    Format-List # Formatere outputtet til en liste
}

function HotFixByDescription { <#   Opgave "Server Opsætning"b      #>
    Get-HotFix | Sort-Object Description -Descending # Henter hotfixes og sortere efter beskrivelse
}

function NetworkInfo { <#   Opgave "Server Opsætning"c      #>
    get-ciminstance Win32_NetworkAdapterConfiguration | # Henter CIM information om netværket
        Where-Object IPEnabled | # Vælger kun den driver der er slået til/i brug
        select-object IP,IPSubnet, DeafultGateway, DNSHostName | # Vælger kun relevant info
        format-list # Formatere outputtet til en liste
}

function GetShares { <#   Opgave "Server Opsætning"d      #>
    $SharedNames = Get-CimInstance -ClassName Win32_Share # Henter Alles shares på Serveren
    $SharedPerms |
        ForEach-Object { $NamesAndPerms = Get-SmbShareAccess -name $SharedNames.Name | # Her bliver shares navnet taget og lagt i en anden cmdlet, og køres igennem en foreach så alle navne bliver kørt igennem da cmdletten ikke kan tage mere end 1 navn
            Select-Object Name, AccountName, AccessControlType, AccessRight | # Vælger kun de relevante info
            Format-Table # Formatere outputtet til en tabel da outputtet ikke vil poste og bugge menuen
        }
    $NamesAndPerms # Giver output
}

function AutomaticServices { <#   Opgave "Server Opsætning"e      #>
    Get-Service | # Henter services
    Select-Object Name, Status, StartType | # Vælger kun relevant info til output
    Where-Object {$_.StartType -eq 'Automatic'} # Vælger kun services som starter automatisk
}

function LastReboot { <#   Opgave "Server Opsætning"f      #>
    Get-CimInstance -ClassName Win32_OperatingSystem | # Henter CIM på Operativ system
    Select-Object LastBootUpTime | # Vælger kun LastBootUpTime  
    Format-Table # Formatere outputtet til en tabel da outputtet ikke vil poste og bugge menuen
}

<#      Opgave "Server Avanceret"         #>

function NewVM { <#   Opgave "Server Avanceret" h      #>
    $VMName = Read-Host "Hvad skal den Virtuelle maskine hedde?" # Spørger hvad VM skal hedde
    $VMPath = Read-host "Indtast stien hvor den virtuelle maskine skal lagres/placeres Eks. 'C:\VMs'" # Spørger efter hvor VM skal lagres
    $VMDiskSize = Read-Host "Indtast hvor stor harddisk VM'en skal have i GB" # Spørger efter hvor stor disken skal være på VM
    [int]$VMGen = Read-host "Vælg VM Generation (1-2)" # Spørger efter hvilke generation af VM det skal være

    Get-VMSwitch * | Format-Table Name # Henter Oprettet netværk lavet i Hyper-V

    $VMNetwork = Read-Host "Vælg et af følgende netværksmuligheder" # Spørger efter hvad netværk der skal bruges på VM

    New-VM -Name $VMName -Generation $VMGen -SwitchName $VMNetwork -Path $VMPath -NewVHDSizeBytes (1gb * $VMDiskSize) -NewVHDPath $VMPath\$VMName.vhdx # Opretter VM, Hvad generation den skal være, Hvilket netværk den skal have, Hvor den skal lagres, Hvor stor disken på VM skal være

    $VMDynMem = Read-host -prompt "Skal VM bruge Dynamic Memory? true/false (Boolean)" # Spørger om VM skal have dynamisk RAM
    try # Try catch bruges til hvis den får et inkorrekt svar så spørger den på ny.
    {
    $VMDynMem = [System.Convert]::ToBoolean($VMDynMem)
    }catch
    {
    Write-Host "Fejl indtastet"
    $VMDynMem = Read-Host -Prompt "Skal VM bruge Dynamic Memory? true/false (Boolean)"
    $VMDynMem = [System.Convert]::ToBoolean($VMDynMem)
    }

    [int]$VMStartupMemInput = Read-Host "Indtast ønsket startup memory i GB (Win10 min. 2GB - Win11 min. 4GB)" # Spørger efter hvor mange GB VM skal have til startup
    Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $VMDynMem -StartupBytes (1gb * $VMStartupMemInput) -MinimumBytes 2048mb # Redigere den oprettet VM, om den skal have dynamisk RAM, Hvor mange gb den skal bruge til startup

}

function DeleteVM { <#   Opgave "Server Avanceret" i      #>
    $VMName = Read-host "Hvilken Virtuel Maskine skal slettes?" # Spørger efter navnet på VM der skal slettes
    $VMHarddrive = Get-VMHardDiskDrive -VMName $VMName # Henter oversigten over harddisken VM'en bruger
    Remove-Item $VMHarddrive.path # Sletter den harddisk som VM har brugt
    Remove-VM -Name $VMName # Sletter VM
}

function ShowVMs { <#   Opgave "Server Avanceret" j      #>
    Get-VM | # Henter oversigt over VMs på Serveren
    Select-Object Name, State, Uptime, IsDeleted, Path | #Udvælger relevant info om VM
    Format-List # Formatere visningen til en liste
}

<#      Opgave "Server Opsætning"g      #>
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
        7 { NewVM }
        8 { DeleteVM }
        9 { ShowVMs}
        0 { EndMenu } 
        default { WrongInput } # Hvis man ikke angiver et af de menupunkter der er skriver den at den har modtaget forkert input
    }

} until ($Userinput -eq 0) # Do until stopper når inputtet er 0 for at slutte
