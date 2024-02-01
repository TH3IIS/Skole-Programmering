
$Dato = Get-Date -f yyyy-MM-dd_hh-mm-ss  # Passer til filnavn
$Titel= "Opgave 8A / Jørgen"
$DokuFil = "c:\Opgave8A\Dokumentation-" + $Dato + ".txt"

# Header til fil
$Titel | Out-File $DokuFil
Get-Date -f {dd. MMMM yyyy hh:mm:ss} | Out-File $DokuFil -Append
#"===========================================" |Out-File $DokuFil -Append

# Brugerer
Write-Output "#############################################################" | Out-File $DokuFil -Append
Write-Output " BRUGERE" | Out-File $DokuFil -Append
$AD_Users = (Get-ADUser -Properties * -Filter * -SearchBase "OU=Opgave8, DC=BY-Joergen, DC=local") | sort
Foreach($B in $AD_Users) {
    Write-Output " " | Out-File $DokuFil -Append
    Write-Output "=======================" | Out-File $DokuFil -Append
    Write-Output $B.name | Out-File $DokuFil -Append
    Write-Output "--------" | Out-File $DokuFil -Append
    $B.memberof | Out-File $DokuFil -Append
}

# Grupper og hvem der er medlem af grupper
Write-Output "#############################################################" | Out-File $DokuFil -Append
Write-Output " GRUPPER og MEDLEMMER" | Out-File $DokuFil -Append
$AD_Grupper = (Get-ADGroup -Properties * -Filter * -SearchBase "OU=Opgave8, DC=BY-Joergen, DC=local") | sort
Foreach($G In $AD_Grupper) {
    Write-Output " " | Out-File $DokuFil -Append
    Write-Output "=======================" | Out-File $DokuFil -Append
    Write-Output $G.name | Out-File $DokuFil -Append
    Write-Output "--------" | Out-File $DokuFil -Append
    $G.members | Out-File $DokuFil -Append
}
Write-Output "=======================" | Out-File $DokuFil -Append
#>

function kol {
#    param( [string]$f1, $f2, $f3, $f4, $f5, $f6)
    param( $f1, $f2, $f3, $f4, $f5, $f6)
    $tom50="                                                  "
    ($f1+$tom50).Substring(0,10) + ($f2+$tom50).Substring(0,30) + ($f3+$tom50).Substring(0,24) + ($f4+$tom50).Substring(0,7) + ($f5+$tom50).Substring(0,10) + ($f6+$tom50).Substring(0,10) 
}

# Delte mapper og rettigheder
Write-Output "#############################################################" | Out-File $DokuFil -Append
Write-Output "DELTE MAPPER og RETTIGHEDER" | Out-File $DokuFil -Append

$SMB_Share = Get-SmbShare | Where-Object -Property description -Like "opgave8"| select name, path, description
Write-Output "=======================" | Out-File $DokuFil -Append
#Write-Output "Navn     Sti                          Kontonavn     Type   Rettighed " | Out-File $DokuFil -Append
#Write-Output "---------------------------------------------------------------------" | Out-File $DokuFil -Append
#$tom="                                                                                           "
Write-Output (kol Navn Sti Kontonavn Type Rettighed) | Out-File $DokuFil -Append
Write-Output "---------------------------------------------------------------------------------" | Out-File $DokuFil -Append


Foreach($S in $SMB_Share) {
    $temp =(Get-SmbShareAccess $S.name) # |select name, AccessControlType, accessright) # | fl   #| Out-File $DokuFil -Append
#    $S.name + "   " + $S.path + "   " + $temp.AccountName + "   " + $temp.AccessControlType + "   " + $temp.AccessRight  | Out-File $DokuFil -Append
    Write-Output (kol $S.name.ToString() $S.path.ToString() $temp.AccountName.ToString() $temp.AccessControlType.ToString() $temp.AccessRight.ToString()) | Out-File $DokuFil -Append
}