$filnavn = "C:\FIRMA\fil-2.txt"

Get-Date -Format "yyyy-MM-dd    hh:mm:ss" | Out-File $filnavn
"Domaim:       " + $env:userdnsdomain | Out-File $filnavn -Append
"Conputername: " + $env:COMPUTERNAME | Out-File $filnavn -Append
"User:         " + $env:USERNAME | Out-File $filnavn -Append
("=" * 30)| Out-File $filnavn -Append
" "  | Out-File $filnavn -Append
"Grupper og medlemmer" | Out-File $filnavn -Append

#$grupper = (Get-ADGroup -Filter 'name -like "G_*"' ) | sort

# $grupper = (Get-ADGroup -Filter * -SearchBase "OU=FIRMA,DC=JSK-08,DC=LOCAL" | SORT

$grupper = (Get-ADGroup -Filter * -SearchBase ("OU=FIRMA,DC=" + $env:USERDNSDOMAIN.SPLIT(".")[0] + ",DC=" + $env:USERDNSDOMAIN.SPLIT(".")[1])) | SORT

$grupper | ForEach-Object {
    $gr=$_.name
    $g1=Get-ADGroupMember -Identity $_.name
    " "  | Out-File $filnavn -Append
    ("=" * 80) | Out-File $filnavn -Append
    "  " + $gr | Out-File $filnavn -Append
    ("=" * 20)| Out-File $filnavn -Append
    $g1 | ForEach-Object {
    $en_user = Get-ADUser $_.name
    $linje ="    " + $en_user.name + "  ----  " + $en_user.DistinguishedName
    $linje  | Out-File $filnavn -Append
    }
}
" "  | Out-File $filnavn -Append
("=" * 80) | Out-File $filnavn -Append

NOTEPAD $filnavn
