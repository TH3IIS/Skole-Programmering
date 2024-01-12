Start-Transcript -Path "C:\Users\Administrator\Documents\GitHub\PowerShell---Scripts\Skole\Opgave-2a\transcript.txt" -NoClobber
<#
Get-Command -Verb Get -noun Service

Get-Service -Name a*

Get-Service -Name a* |
    Where-Object {$_.Status -eq 'Running'} 

Get-Service | Get-Member

Get-Service -Name a* |
    Select-Object Name, Status, StartType

Get-Service -Name a* |
    Select-Object Name, Status, StartType | Where-Object {$_.StartType -eq 'Automatic'}

Get-Service -Name a* |
    Select-Object Name, Status, StartType | Where-Object {$_.StartType -eq 'Automatic'} |
    Out-File -FilePath C:\Users\Administrator\Documents\GitHub\PowerShell---Scripts\Skole\Opgave-2a\output-2a.txt

Get-Content .\Opgave-2a\output-2a.txt

Get-Help Out-File -Online
#>

Get-Service -Name a* |
    Select-Object Name, Status, StartType | Where-Object {$_.StartType -eq 'Automatic'} |
    Out-File -FilePath C:\Users\Administrator\Documents\GitHub\PowerShell---Scripts\Skole\Opgave-2a\output-2a.txt -NoClobber

Stop-Transcript