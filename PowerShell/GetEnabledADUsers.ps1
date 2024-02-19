get-aduser -filter * |
Where-Object {$_.Enabled -eq "True"} |
Select-Object DistinguishedName, SamAccountName, UserPrincipalName |
Format-list