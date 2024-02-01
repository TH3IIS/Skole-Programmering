## Find WIFI og koder
## Version 1.0     2021-10-05     JSK
##
$a = NETSH WLAN SHOW PROFILE
$skillelinje = "=============================================="
foreach ($linje In $a) {
if ($linje.Length -gt 27) {
$t= $linje.remove(0,27)
$b = NETSH WLAN SHOW PROFILE "$t" key=clear

$b1 = $b -match 'ssid name'
$b2 = $b -match 'key con'
$skillelinje
$b1 + $b2
}
}
$skillelinje