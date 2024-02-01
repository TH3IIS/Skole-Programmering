$mellemrum = "========================================================"
$Serverdok = "C:\Serverdoko.txt"


#===========================================================================================# 
#Få DHCP info
echo "DHCP SERVER INFO" | out-file $Serverdok -Append
get-dhcpserverindc | out-file $Serverdok -Append
$mellemrum | out-file $Serverdok -Append 



#Sprøger efter server navne med dhcp og finder DHCP scope
$DHCPserver = ""
$Servername = @()

While($DHCPserver -ne 'q'){

    $DHCPserver = Read-host 'DHCP server name'

 if($DHCPserver -ne 'q'){

    Get-DhcpServerv4Scope -ComputerName $DHCPserver | out-file C:\DHCPscope.txt -Append unicode
 }
 
 else
 {
 break
 }

}





#===========================================================================================# 

get-aduser -Filter * | select samaccountname | Export-Csv -Path C:\Burger.csv

$Bruger = "C:\Burger.csv"
$outputfile = "c:\done.txt"


$imported = import-csv -Path C:\Burger.csv


foreach($ting in $imported){


     $ting2 = $ting.samaccountname
     echo $ting2 | Add-Content $outputfile
     '' |add-content $outputfile
     Get-ADPrincipalGroupMembership -Identity "$ting2" | select name | Add-Content $outputfile
     $mellemrum | Add-Content $outputfile
     
     
}

$Remove = get-content $outputfile 
$Remove -replace "@{name=" ,"" -replace "}" ,"" | add-content $Serverdok
#===========================================================================================# 