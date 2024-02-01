
$_Folders=Get-ChildItem c:\firma -Recurse  | select -Property fullname

:: Get-ChildItem c:\firma -Recurse  | select -Property fullname
:: foreach 

:: Get-ChildItem c:\firma -Recurse  | select -Property fullname
:: get-acl C:\firma\Personlig\Gert |select -expand accesstostring

::@(Get-ChildItem c:\firma -Recurse  | select -Property fullname ).ForEach({get-acl $foreach |select -expand accesstostring})