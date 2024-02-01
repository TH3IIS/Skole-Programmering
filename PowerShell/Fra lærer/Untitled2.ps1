<#
.SYNOPSIS
	Map-AD will create a visual representation of your AD structure
.DESCRIPTION
	Map-AD will create a visual representation of the Container and Organizational Unit structure within your Active Directory Domain starting from the root, or from a specified OU.
.PARAMETER OU
	Represents the OU that you would like to start the mapping from.
.PARAMETER Name
	A switch to toggle between outputting distinguished names and just names of OUs and containers
.EXAMPLE
	Map-AD
	
	This will return a mapping of AD starting at the root, ouputting distinguished names.
.EXAMPLE
	Map-AD "OU=Users,DC=Contoso,DC=local" -name
	
	This will return a mapping of AD starting at "OU=Users,DC=Contoso,DC=local", ouputting names.
.OUTPUTS
	Ex. ouput:
	DC=Contoso,DC=local
	| --- Computers
	| ------ Local
	| ------ Remote
	| --- Users
	| ------ Local
	| ------ Remote
.NOTES
	Author: Twon Of An
.LINK
	ActiveDirectory
#>
Function Map-AD
{
	Param
	(
		$OU
		,
		[switch]$names
	)
	Import-Module ActiveDirectory
	If(!($OU))
	{
		[string[]]$temp = (Get-ADOrganizationalUnit -filter * -ResultSetSize 1).distinguishedname.split(",")
		[string]$OU = $($temp[$temp.count-2]) + "," + $($temp[$temp.count-1])
	}
	If($ou.distinguishedname)
	{
		$depth = $ou.distinguishedname.split(",").count - 2
	}
	Else
	{
		$depth = -1
	}
	If(($depth -gt 0))
	{
		If($names)
		{
			Write-Host "|"("-" * $Depth * 4) $OU.name
		}
		Else
		{
			Write-Host "|"("-" * $Depth * 3) $OU.distinguishedname
		}
	}
	Else
	{
		$OU
	}
	If($tmp = Get-ChildItem AD:"$OU" | Where-Object{($_.objectclass -eq "container") -or ($_.objectclass -eq "organizationalUnit") -and ($_.distinguishedname -notlike "*-*-*-*-*")})
	{
		ForEach($child in $tmp)
		{
			If($names)
			{
				Map-AD $child -name
			}
			Else
			{
				Map-AD $child
			}
		}
	}
}


# map-ad "ou=firma,DC=D-2016,DC=LOCAL" -name

$_data_1 = 
$_data_2= $env:USERDOMAIN
$_data_3 = 

# map-ad "ou=firma,DC=$_data_2,DC=LOCAL" -name
map-ad "DC=AD1-JSK,DC=LOCAL" -name
