#Updatere help funktionen
Update-Help -force -ErrorAction SilentlyContinue

#Viset liste over valgmuligheder til ExecutionPolicy
Get-ExecutionPolicy -List
#Sætter executionpolicy så scripts kan køres
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Write-host $PSVersionTable

Get-History | export-csv -Path C:\Users\Administrator\Documents\GitHub\PowerShell---Scripts\Skole\Opgave-1\opgave1.txt

