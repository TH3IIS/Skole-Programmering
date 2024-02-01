#Dokumentation af opgave 8A

#Sti til output fil
$fil = "C:\Dokumentation_Opgave8A.txt"

#Skillelinje mellem afsnit
$linje = "==============================================================================================================="


#Viser dato, Out-File opretter et dokument og skriver outputtet i dokumentet.
Get-Date | Out-file $fil

#Out-file -Append $fil tilføjer output til dokumentet
"Dokumentation af Opgave 8A" | Out-file -Append $fil
"Lavet af Anders Gade Lietzen" | Out-file -Append $fil
"Klasse: 20V1H01" | Out-file -Append $fil

#Ny skillelinje
$linje | Out-File -Append $fil 

#Overskrift
"Domain:" | Out-File -Append $fil 

#Viser oplysninger om domænet. Jeg vælger også at vise ReplicaDirectoryServers så man kan se hvilke server mit AD er replikeret til.
Get-ADDomain | Select -Property name,forest,distinguishedname,ReplicaDirectoryServers | Out-File -Append $fil 

"Domain Computers:" | Out-File -Append $fil 

#Domæne computere
$ADcomputers = Get-ADComputer -Filter * -Properties *
 
#Udvælger hvilke informationer jeg vil vise om computerne. Jeg vælger primarygroup så man kan se hvilke maskiner som er DC.
$ADcomputers | FT Name, IPv4Address, PrimaryGroup | Out-File -Append $fil 

#Viser alle domæne controllers og deres ip adresse. Har fravalgt denne kommando da den viser det samme som ovenfor.
#Get-ADDomainController -filter * | ft name,Domain,IPv4Address | Out-File -Append $fil 

$linje | Out-File -Append $fil 


"DHCP Scopes:" | Out-File -Append $fil

#Indsætter tom linje
"" | Out-File -Append $fil

#Gemmer servernavn i en variabel
$DC = Get-ADDomainController -filter * | Select -Property name

#Bruger servernavne til at lave en foreach og vise scope oplysninger for hver server.
Foreach ($_ in $DC) {$_.name | Out-File -Append $fil ; Get-DhcpServerv4Scope -ComputerName $_.name | Select -Property Name,Type,ScopeId,SubnetMask,StartRange,EndRange,LeaseDuration | Out-File -Append $fil}

$linje | Out-File -Append $fil 


"Users & Groups:" | Out-file -Append $fil

#Viser Adbrugere
Get-ADUser -Filter * -SearchBase "OU=BY-anders_Groups,DC=BY-anders,DC=local" -Properties * | Select name, objectclass, memberof | Out-file -Append $fil

#Vis AD grupper
Get-ADGroup -Filter * -SearchBase "OU=BY-anders_Groups,DC=BY-anders,DC=local" -Properties * | Select name,Objectclass,Groupscope | Out-file -Append $fil

$linje | Out-File -Append $fil


"Mappe Struktur:" | Out-File -Append $fil 

"" | Out-File -Append $fil

#Mappestruktur for By-anders hovedmappen
Tree /a C:\BY-anders | Out-File -Append $fil 

$linje | Out-File -Append $fil 


"Shares:" | Out-file -Append $fil

#Vis Smb shares
Get-SmbShare | Where-Object Description -match "BY-anders" | Sort Path | Out-File -Append $fil

#Kasseret kommando, da den laver for mange mellemrum mellem resultaterne
#dir C:\BY-anders,C:\BY-anders\Personal | % {Get-Smbshare -Name $_ -ErrorAction SilentlyContinue | FL -Property Name,Path | Out-File -Append $fil}

"Share access:" | Out-File -Append $fil

#Vis hvem der har adgang til smb shares
Get-SmbShare | Where-Object Description -match "BY-anders" | Get-Smbshareaccess | Sort Accountname | Out-File -Append $fil

#Kasseret kommando, da den laver for mange mellemrum mellem resultaterne
#dir C:\BY-anders,C:\BY-anders\Personal | % {Get-Smbshareaccess -Name $_ -ErrorAction SilentlyContinue | FL -Property Name,AccountName,AccessControlType,AccessRight | Out-File -Append $fil}

$linje | Out-File -Append $fil


"" | Out-File -Append $fil

"Security rettigheder på mapperne:" | Out-File -Append $fil

#Vis sercurity rettigheder på share mapperne. % er et alias for Foreach-Object.
Get-ChildItem -Path C:\By-anders,C:\BY-anders\Personal | % {$_.name | Out-File -Append $fil ; Get-Acl -Path $_.FullName | select path -ExpandProperty access | Select -Property IdentityReference,FileSystemRights,Path | Out-File -Append $fil}

$linje | Out-File -Append $fil


#Henter information ud af min fil
$filreplace = Get-Content $fil
#Fjerner irrelevant information fra Security rettigheder og lægger data tilbage i filen igen. 
$filreplace -replace 'Microsoft.Powershell.Core\\FileSystem::','' | Set-Content $fil


#Noter:
#((Get-Content -path C:\ReplaceDemo.txt -Raw) -replace 'brown','white') | Set-Content -Path C:\ReplaceDemo.txt
#((Get-Content $fil -raw) -replace 'Microsoft.PowerShell.Core\FileSystem:',' ') | Set-Content -Path $fil
#$demo.replace("dEf","xyz")