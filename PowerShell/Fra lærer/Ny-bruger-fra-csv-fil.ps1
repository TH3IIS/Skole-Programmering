Import-Csv c:\csv\user.csv | foreach-object {
#write-host $_.SamAccountName, $_.Name, $_.DisplayName

$userprinicpalname = $_.SamAccountName + "@D-2016.local"
New-ADUser -SamAccountName $_.SamAccountName -Name $_.name  -UserPrincipalName $userprinicpalname -DisplayName $_.name  -Path "OU=TEST,DC=D-2016,DC=local" -AccountPassword (ConvertTo-SecureString "PASSWORD1." -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru 
#New-ADUser -SamAccountName $_.SamAccountName -Name $_.name -DisplayName $_.name -GivenName $_.cn -SurName $_.sn -Department $_.Department -Path "CN=Users,DC=EXAMPLE,DC=com" -AccountPassword (ConvertTo-SecureString "PASSWORD1" -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru 
}


#PS C:\> Import-Csv .\users.csv | foreach-object {
#$userprinicpalname = $_.SamAccountName + "@EXAMPLE.com"
#New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName $userprinicpalname -Name $_.name -DisplayName $_.name -GivenName $_.cn -SurName $_.sn -Department $_.Department -Path "CN=Users,DC=EXAMPLE,DC=com" -AccountPassword (ConvertTo-SecureString "PASSWORD1" -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru }
