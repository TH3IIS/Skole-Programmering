[int]$VMStartupMemInput = Read-Host "Indtast ønsket startup memory i GB (Win10 min. 2GB - Win11 min. 4GB)"
Set-VMMemory -VMName test1 -DynamicMemoryEnabled $TRUE -StartupBytes (1gb * $VMStartupMemInput) -MinimumBytes 2048mb

