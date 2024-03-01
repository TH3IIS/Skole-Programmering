net use B: \\WIN-1ON6JNPD6C1\Lovetand /user:data 1234abcd.
Set-Location B:
Copy-Item *.csv -Destination c:\temp\loevetand
net use B: /delete /yes
Set-Location  C:\Windows\System32

# Måler ID i csv er målernummer i db


#Lys = Lux
#Vand = %
# Temp = grader



# Tip fra function NyLeverandor()