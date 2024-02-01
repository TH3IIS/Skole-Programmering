<#
    Viser VM med VHDX og størrelse 
    ------------------------------
    Version 1.3
    2023-09-18
    JSK
#>
$_alle_VM = Get-VM 
$_alle_VM_data = @()
foreach( $_VM in $_alle_VM) { $_alle_VM_data+= Get-VMHardDiskDrive $_VM.name }

$_ny = $_alle_VM_data | select vmname, path | sort path 

$_mellemrum = 4
$_vmname_length = $_mellemrum + ($_ny.vmname | Measure-Object -Maximum -Property Length).Maximum
$_path_length = $_mellemrum + ($_ny.path | Measure-Object -Maximum -Property Length).Maximum

"{0,-$_vmname_length} {1,-$_path_length} {2,13} " -f ("-"*($_vmname_length-$_mellemrum)), ("-"*$_path_length), "---------"
"{0,-$_vmname_length} {1,-$_path_length} {2,10} " -f "VM-Navn", "Disk Path", "Size"
"{0,-$_vmname_length} {1,-$_path_length} {2,13} " -f ("-"*($_vmname_length-$_mellemrum)), ("-"*$_path_length), "---------"

for ($_i=0; ($_i -lt $_ny.Count); $_i++) {
    "{0,-$_vmname_length} {1,-$_path_length} {2,10:N3} GB" -f ($_ny[$_i].VMName), ($_ny[$_i].Path), ((gci ($_ny[$_i].Path)).length /1Gb)
    }

"{0,-$_vmname_length} {1,-$_path_length} {2,13} " -f ("-"*($_vmname_length-$_mellemrum)), ("-"*$_path_length), "---------"
