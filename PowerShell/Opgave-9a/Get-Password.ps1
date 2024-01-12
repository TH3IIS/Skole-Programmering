function GeneratedPassword {
    param (
        $Length # Paramet i funktionen som bruges i loopet
    )

    $Password = "" # Definere at variablen er en streng, som bruges i loopet til at bl.a. tælle længden af koden

    while ($Password.Length -lt $Length - 4) {
        $HCase = "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" | Get-Random # Variabel som har alle UpperCase Characters fra A-Z 
        $lCase = "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" | Get-Random # Variablen som alle lowerCase Characters fra a-z
        $Number = "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" | Get-Random # Variabel som har alle tal fra 0-9
        $Special = "$", "%", "&", "/", "(", ")", "=", "?", "@", "#", "?", "{", "}", "*", "+" | Get-Random # Variabel som har specialtegn
        $AllChars = "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z","0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "$", "%", "&", "/", "(", ")", "=", "?", "@", "#", "?", "{", "}", "*", "+" | Get-random

        $Password += Get-Random -InputObject $AllChars #$AllChars # Laver en get random iblandt de 4 forsk. Tegn typer. += gør at der bliver tilføjet til variablen i loopet i stedet for at den bliver skrevet over.
    }

    $Password = $Password + $HCase + $lCase + $Number + $Special

    $Password = Get-Random -Shuffle -InputObject $Password

    Write-Host "Din kode: $Password" # Oplyser din kode i CLI'en
}



[int]$PSWLenght = Read-Host "Hvor mange tegn skal koden være" # Spørger brugeren om hvor mange tegn koden skal være, [int] tager kun imod integer(tal) hvis ikke fejler den.

if ($PSWLenght -lt 6) { # Giver fejl hvis indtastet længde er under 6 tegn
    Write-Host "Fejl i indtastning"
}
elseif ($PSWLenght -ge 6) { # Hvis længden er 6 eller over genere den koden
    GeneratedPassword -Length $PSWLenght # Tager lenght værdien med ind i funktionen
}



