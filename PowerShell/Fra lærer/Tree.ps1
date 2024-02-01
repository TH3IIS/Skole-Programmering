# Laver TREE-kommandoen fra PowerShell med de rigtige grafiktegn
# version: 1.5
# date:    2022-01-19
#     JSK@SDE.DK
#
$bat_fil=@("@del tree.txt","@tree %1 >tree.txt")
$bat_fil | out-file tt.bat -Encoding ascii

&cmd /c tt.bat c:\firma

$tree=(Get-Content tree.txt -Encoding oem)
$slut=$tree.Count
$tree[2..$slut]# | Out-File tot.txt -Encoding oem
