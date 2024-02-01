for ($i=0; $i -le 10000;$i++) {
    $i.ToString() + ' '+ [char]$i | Out-File ascii.txt -Append

}