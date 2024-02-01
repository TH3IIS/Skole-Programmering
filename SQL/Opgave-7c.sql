-- Opgave 7c

-- Query 1
insert into produkt (ProdID, ProdNavn, Farve, V�gt, [By], Antal)
   values ('P9', 'S�m', 'Black', 12, 'Paris', 500)
/*
Msg 156, Level 15, State 1, Line 4
Incorrect syntax near the keyword 'By'.

Her Kaldes den forkerte kolonne og �ndres derfor til "[By]"

Msg 2627, Level 14, State 1, Line 4
Violation of PRIMARY KEY constraint 'PK_Produkt'. Cannot insert duplicate key in object 'dbo.Produkt'. The duplicate key value is (P5).

Her eksistere ProdID "P5" allerede og erstattes med "P9" som n�ste entry i Tabellen, Ellers kunne ProdID s�ttes som Identity Column?
*/

--Query 2
delete produkt
	where prodID = 'P2'
/*
The DELETE statement conflicted with the REFERENCE constraint "FK_Bestilling_Produkt". The conflict occurred in database "ButikNTYP", table "dbo.Bestilling", column 'ProdID'.
The statement has been terminated.

Fejler da den er forbundet med en FK hvor handlingen er sat til no action og vil derfor ikke blive udf�rt.
*/

-- Query 3
insert into bestilling (Ordrenr, ProdID, Antal, AftaltPrisIalt)
   values (1, 'P9', 50, 100.00)

/*
(1 row affected)

Der er oprettet en ordre(1) p� Sorte S�m 50 stk.
Hvis Query 1 ikke var rettet til ville den fejl da der ikke var et P9 Produkt i tabellen.
*/

--Query 4
insert into bestilling (Ordrenr, ProdID, AftaltPrisIalt)
   values (1, 'P8', 100.00)

/*
(1 row affected)

Der st�r 1 i Antal fordi at der i querien ikke er defineret et antal s� har den taget den default v�rdi som er sat.
*/

-- Query 5
insert into bestilling (Ordrenr, ProdID, AftaltPrisIalt) 
   values (1, 'P8', 100.00)
/*
Violation of PRIMARY KEY constraint 'PK_Bestilling'. Cannot insert duplicate key in object 'dbo.Bestilling'. The duplicate key value is (1, P8).
The statement has been terminated.

Da b�de Ordrenr og ProdID er PK kan de ikke dupleres i tabellen da det er en unik v�rdi. og handlingen bliver derfor stoppet. L�sning ville evt. v�re at opdatere v�rdien.
*/

--Query 6
delete ordre
	where Ordrenr = 1
/*
(1 row affected)

Ordren slettes og alt hvad der er forbundet med ordrenr 1 som f.eks. I Bestilling bliver slettet grundet CASCADE er sat som delete rule
*/

--Query 7
insert into Ordre (Ordrenr, Levid)
   values (2, 'S2') 
/*
Cannot insert explicit value for identity column in table 'Ordre' when IDENTITY_INSERT is set to OFF.

Da Ordrenr er sat som Identity column tager den ikke imod v�rdi da den selv s�tter det.
*/
