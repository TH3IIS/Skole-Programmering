# Finder GPO'er der ikke er linket (ikke brugt)


$gpos = Get-Gpo -All
foreach ($gpo in $gpos) {
    [xml]$gpoReport = Get-GPOReport -Guid $gpo.ID -ReportType xml
    if ( $gpoReport.GPO.LinksTo) {
    #if ( -not $gpoReport.GPO.LinksTo) {
        $gpo.DisplayName, $gpoReport.GPO.LinksTo
    }
}