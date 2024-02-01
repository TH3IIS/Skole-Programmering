##############################################################################
#   lav dokumentation
#
#############################################################################

#update-help -force -ErrorAction SilentlyContinue

get-adgroup -filter 'description -eq "Firma"' -properties * | select name,description,members

get-aduser -filter 'description -eq "Firma"' -properties * | select name,description,memberof,DistinguishedName

# GET-ADUSER -filter * SEACHBASE 

$alt=get-smbshare | where-object -property description -eq "Firma" | select name,path

-----------------

$Roller=Get-WindowsFeature | where installed

