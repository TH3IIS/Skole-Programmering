$_Tid = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$_UdFil = "c:\ovelse1\" + $_Tid + "_Brugere.txt"

"Computer: " + $env:COMPUTERNAME | Out-File $_UdFil
"Domæne:   " + $env:USERDNSDOMAIN | Out-File $_UdFil -Append 
"Bruger:   " + $env:USERNAME | Out-File $_UdFil -Append 

Get-Date -Format "yyyy-MM-dd  -  HH:mm:ss" | Out-File $_UdFil -Append 
("="*50) | Out-File $_UdFil -Append

$_a = Get-ADUser -Filter * | select samaccountname, DistinguishedName
$_a | Out-File $_UdFil -Append

notepad $_UdFil

#### FOR /L %N IN (1,1,20) DO NET USER BRUGER-%N 1234abcd. /ADD

