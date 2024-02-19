$Dato = Get-Date -Format dd-MM-yyyy_HH-MM-ss
$Dato2 = Get-Date -Format {dd.MM/yyyy HH:MM:ss}
$Doc = "c:\" + $Dato + ".txt"

Out-File $Doc

"
#######################################
#                                     #
#     Dokumentation til opgave 8A     #
#                                     #
#     Dato: $Dato2       #
#                                     #
#     Af: Nicki                       #
#                                     #
#######################################
" | Out-File $Doc -Append

$IPaddress = (Get-NetIPAddress |
                Where-Object {$_.PrefixOrigin -eq "Manual"} |
                Select-Object IPAddress).IPAddress
              

"
SYSTEM OPLYSNINGER
=======================================

Computernavn: $env:COMPUTERNAME
Domæne: $env:USERDNSDOMAIN
Brugernavn: $env:USERNAME
IP Adresse: $($IPaddress)
" | Out-File $Doc -Append

"Windows Features (Relevans til OPG8a)
=======================================" | Out-File $Doc -Append

Get-WindowsFeature |
    Where-Object {($_.Installed -eq "True") -and ($_.Name -like "*AD*") -or ($_.Name -like "*DFS*") -or ($_.Name -like "*DHCP*") -or ($_.Name -like "*DNS*") -or ($_.Name -like "*GPM*")} |
    Format-table |
    Out-File $Doc -Append

"DHCP - SCOPE
=======================================" | Out-File $Doc -Append

$DHCPScope = Get-DHCPServerV4Scope
$DHCPDNS = (Get-DhcpServerv4OptionValue -ComputerName $env:COMPUTERNAME -ScopeId $DHCPScope.ScopeId | where optionid -EQ "6").Value
$DHCPDefaultGateway = (Get-DhcpServerv4OptionValue -ComputerName $env:COMPUTERNAME -ScopeId $DHCPScope.ScopeId | where optionid -EQ "3").Value

Get-DHCPServerV4Scope | 
    Select Name, ScopeID, StartRange, EndRange, SubnetMask, Type | 
    Format-list  | 
    Out-File $Doc -Append

"DNS : $($DHCPDNS)" | Out-File $Doc -Append
"Default Gateway : $($DHCPDefaultGateway)" | Out-File $Doc -Append

"" | Out-File $Doc -Append


"DHCP - FAILOVER
=======================================" | Out-File $Doc -Append

Get-DHCPServerV4Failover | 
    Select Name, PartnerServer, Mode | 
    Format-list | 
    Out-File $Doc -Append

"DFS
=======================================" | Out-File $Doc -Append

Get-DfsnRoot -ComputerName $env:COMPUTERNAME |
 Format-List |
 Out-File $Doc -Append

"DFS - REPLICATION
=======================================" | Out-File $Doc -Append

Get-DFSRConnection |
    Select SourceComputerName, GroupName, DestinationComputerName, DomainName, State, Enabled, CrossFileRdcEnabled | 
    Format-List |
    Out-File $Doc -Append

"SHARES
=======================================" | Out-File $Doc -Append

$Shares = Get-SmbShare 
$SharePaths = (Get-Fileshare |
    Where-Object {($_.Name -notLike "*$") -and ($_.Name -notlike "SYSVOL*") -and ($_.Name -notlike "NETLOGON*")}).VolumeRelativePath

Get-SmbShareaccess -name $Shares.Name |
    Where-Object {($_.Name -notLike "*$") -and ($_.Name -notlike "SYSVOL*") -and ($_.Name -notlike "NETLOGON*")}  |
    Select-Object Name, Accountname, AccessRight |
    format-table | 
    Out-File $Doc -Append

ForEach($SharePath in $SharePaths) {

    Get-acl -Path $SharePath |
        Select-Object PSChildName, PSDrive, Owner, AccessToString |
        Format-List |
        Out-file $Doc -Append  

}

## Skal bruge et TREE for bedre at se shares

"AD BRUGER
=======================================" | Out-File $Doc -Append

Get-ADUser -Properties * -Filter * |
    Select SamAccountName, DistinguishedName, UserPrincipalName, Memberof |
    Where-Object {$_.DistinguishedName -like "*OU_BY*"} |
    Format-List |
    Out-File $Doc -Append

"AD GRUPPER (Relevans til OPG8a)
=======================================" | Out-File $Doc -Append

Get-ADGroup -Filter * |
    Where-Object {$_.Name -match "G_"} |
    Select-Object Name, Groupcategory, DistinguishedName |
    Format-list |
    Out-File $Doc -Append

"GROUP POLICIES
=======================================" | Out-File $Doc -Append

Get-GPO -all -Domain "BY-Nicki.local" |
    Where-Object {$_.DisplayName -notlike "Default*"} |
    Select-Object DisplayName, GPOStatus |
    Format-list |
    Out-File $Doc -Append

New-Item -Path C:\ -Name "GPOsFraOPG8a" -ItemType "directory" -ErrorAction SilentlyContinue

$GPOs = Get-GPO -all -Domain "BY-Nicki.local" |
            Where-Object {$_.DisplayName -notlike "Default*"} |
            Select-Object -ExpandProperty DisplayName

ForEach($GPO in $GPOs) {
    Get-GPOReport -Name $GPO -ReportType HTML -Path C:\GPOsFraOPG8a\$GPO.html
}

"Udvidet HTML Rapport kan findes i Mappen GPOsFraOPG8a" | Out-File $Doc -Append