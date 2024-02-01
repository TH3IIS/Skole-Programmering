
$dato = Get-Date -Format "yyyy-MM-dd___HH-mm-ss"

Get-GPOReport -All -ReportType Html -Path c:\ny\GPO-$dato.html

Get-GPO -All | select DisplayName, CreationTime, ModificationTime | sort ModificationTime | out-file c:\ny\GPO-$dato.txt
