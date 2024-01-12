function GeneratedPassword {
    param (
        $Length # Paramet i funktionen som bruges i loopet
    )

    $HCase = "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" # Variabel som har alle UpperCase Characters fra A-Z 
    $lCase = "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" # Variablen som alle lowerCase Characters fra a-z
    $Number = "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" # Variabel som har alle tal fra 0-9
    $Special = "$", "%", "&", "/", "(", ")", "=", "?", "@", "#", "?", "{", "}", "*", "+" # Variabel som har specialtegn
    $Password = "" # Definere at variablen er en streng, som bruges i loopet til at bl.a. tælle længden af koden

    while ($Password.Length -lt $Length) {
        $AllChars = "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z","0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "$", "%", "&", "/", "(", ")", "=", "?", "@", "#", "?", "{", "}", "*", "+" 
        
        if ($Password -ceq "") { 
            $Password += Get-Random -InputObject $AllChars # Giver et tilfældigt tegn
        }
        elseif ($Password -cnotmatch "[A-Z]") { #Hvis ikke har UpperCase
            $Password += Get-Random -InputObject $HCase #giver den et tilfældigt uppercase
        }
        Elseif ($Password -cnotmatch "[a-z]") { #Hvis ikke har lowerCase
            $Password += Get-Random -InputObject $lCase #giver den et tilfældigt lowercase
        }
        Elseif ($Password -cnotmatch "\d") { #Hvis ikke har tal
            $Password += Get-Random -InputObject $Number #giver den et tilfældigt nummer
        }
        Elseif ($Password -notmatch "[^a-zA-Z0-9]") { #Hvis ikke har specialtegn
            $Password += Get-Random -InputObject $Special#Giver den et tilfældigt specialtegn
        }
        Else { # Hvis alle kriterier er opfyldt giver den tilfø
            $Password += Get-Random -InputObject $AllChars #Giver tilfældigt tegn
        }
    }
 

    Write-Host "Din kode: $Password" # Oplyser din kode i CLI'en
}



[int]$PSWLenght = Read-Host "Hvor mange tegn skal koden være" # Spørger brugeren om hvor mange tegn koden skal være, [int] tager kun imod integer(tal) hvis ikke fejler den.

if ($PSWLenght -lt 6) { # Giver fejl hvis indtastet længde er under 6 tegn
    Write-Host "Fejl i indtastning"
}
elseif ($PSWLenght -ge 6) { # Hvis længden er 6 eller over genere den koden
    GeneratedPassword -Length $PSWLenght # Tager lenght værdien med ind i funktionen
}



