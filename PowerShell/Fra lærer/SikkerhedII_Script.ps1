# User configuration
$Path = "C:\FIRMA\"
$GroupOU = "Locations"
$Logfilename = "Logfile_$(Get-Date -Format 'dd-MM-yyyy_HH-mm-ss').txt"

# Variables for the logfile
$Delimiter = "---------------------------------------------------------"
$Date = Get-Date -Format 'dd-MM-yyyy HH:mm:ss'
$DomainName = "Domain name: $env:USERDOMAIN"
$HostName = "Hostname: $env:COMPUTERNAME"

# Write the file to disk
Out-File $Logfilename
Write-Host "Running script..." -ForegroundColor Yellow

# Output basic information to host and logfile
Add-Content $Logfilename $Date
Add-Content $Logfilename $Delimiter
Add-Content $Logfilename $DomainName
Add-Content $Logfilename $HostName
Add-Content $Logfilename $Delimiter

# Output shares
Add-Content $Logfilename $Delimiter
Add-Content $Logfilename "Shared Folders"
Add-Content $Logfilename $Delimiter
Get-WmiObject -class win32_share | Where {$_.Path -like 'C:\FIRMA\*'} |
Out-File $Logfilename -Append

# Output shared folder rights
Add-Content $Logfilename $Delimiter
Add-Content $Logfilename "Shared Folder Rights"
Add-Content $Logfilename $Delimiter

$Folders = Get-ChildItem $Path -Recurse
foreach ($Folder in $Folders){
    Add-Content $Logfilename $Delimiter
    Add-Content $Logfilename $Folder.FullName
    Add-Content $Logfilename $Delimiter
    Get-Acl $Folder.FullName | Select -expand access |
    Out-File $Logfilename -Append
}

# Output users in security group from the OU specified in $GroupOU
Add-Content $Logfilename $Delimiter
Add-Content $Logfilename "Users in Security Groups"
Add-Content $Logfilename $Delimiter

$Groups = (Get-ADGroup -filter * -Properties GroupCategory | Where {$_.DistinguishedName -match "OU=$GroupOU"}).Name
foreach($Group in $Groups){
    Add-Content $Logfilename $Delimiter
    Add-Content $Logfilename "Security Group:  $Group"
    Add-Content $Logfilename $Delimiter
    Get-ADGroupMember $Group | Select-Object distinguishedName |
    Out-File $Logfilename -Append
}
Write-Host "Script finished." -ForegroundColor Green