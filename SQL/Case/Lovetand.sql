-- Forbinder til Master databasen
USE master
GO

-- IF statement der opretter databasen hvis der ikke allerede er oprettet en med samme navn
IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'Gartneri'
)
CREATE DATABASE Gartneri
GO

-- Forbinder til oprettet database
USE Gartneri
GO

-- Opretter skemaer
CREATE SCHEMA Gartner
GO

CREATE SCHEMA Medhjaelper
GO

CREATE SCHEMA Administration
GO

/*
    Oprettelse af tabeller ud fra billede vedlagt casen
*/

-- IF Statement der sletter tabel hvis den allerede eksistere
IF OBJECT_ID('Medhjaelper.Plantetyper', 'U') IS NOT NULL
DROP TABLE Medhjaelper.Plantetyper
GO

CREATE TABLE Medhjaelper.Plantetyper
(
    /* Tabelnavn: */Plantetype /*Datatype: */[NVARCHAR]/*Antal tegn i kolonne*/(20) /* Må ikke indeholde NULL*/NOT NULL /* Denne kolonne er Primær nøgle*/PRIMARY KEY,
    Plantebeskrivelse [NVARCHAR](200) NULL
);
GO

IF OBJECT_ID('Medhjaelper.Bord', 'U') IS NOT NULL
DROP TABLE Medhjaelper.Bord
GO

CREATE TABLE Medhjaelper.Bord
(
    Drivhus INT NOT NULL,
    Bord [NVARCHAR](50) NOT NULL,
    Plantetype [NVARCHAR](20) NOT NULL
    PRIMARY KEY(Drivhus, Bord)
);
GO

IF OBJECT_ID('Gartner.BordMaaler', 'U') IS NOT NULL
DROP TABLE Gartner.BordMaaler
GO

CREATE TABLE Gartner.BordMaaler
(
    Drivhus INT NOT NULL ,
    Bord [NVARCHAR](50) NOT NULL,
    MaalerNr INT NOT NULL 
    PRIMARY KEY(Drivhus, Bord, MaalerNr)
);
GO

IF OBJECT_ID('Gartner.Maaler', 'U') IS NOT NULL
DROP TABLE Gartner.Maaler
GO

CREATE TABLE Gartner.Maaler
(
    MaalerNr INT NOT NULL PRIMARY KEY,
    MaalerType [NVARCHAR](50) NOT NULL,
    Maaleenhed [NVARCHAR](50) NULL
);
GO

IF OBJECT_ID('Administration.Maaling', 'U') IS NOT NULL
DROP TABLE Administration.Maaling
GO

CREATE TABLE Administration.Maaling
(
    MaalingID INT NOT NULL IDENTITY PRIMARY KEY,
    MaalerNr INT NOT NULL,
    Tidspunkt DATETIME NOT NULL,
    MaaltVaerdi DECIMAL(10,2) NOT NULL    
);
GO

/* Tilføjelse af Foreign keys */

ALTER TABLE Medhjaelper.Bord
    ADD FOREIGN KEY (Plantetype) REFERENCES Medhjaelper.Plantetyper(Plantetype) ON DELETE NO ACTION

ALTER TABLE Gartner.BordMaaler
    ADD FOREIGN KEY(MaalerNr) REFERENCES Gartner.Maaler(MaalerNr) ON DELETE NO ACTION,
    FOREIGN KEY(Drivhus, Bord) REFERENCES Medhjaelper.Bord(Drivhus, Bord) ON DELETE NO ACTION

ALTER TABLE Administration.Maaling
    ADD FOREIGN KEY (MaalerNr) REFERENCES Gartner.Maaler(MaalerNr) ON DELETE NO ACTION

ALTER TABLE Gartner.Maaler
	ADD CONSTRAINT C_MaalerType
		CHECK (MaalerType IN('Temperatur', 'Vand', 'Gødning', 'Lys'))

/*
    Data til BordMaaler, Bord og Plantetyper tabellerne
*/

INSERT INTO Bord(Drivhus, Bord, Plantetype)
 Values
	(1, 1, 'Tomater'),
	(1, 2, 'Tomater'),
	(1, 3, 'Tomater'),
	(1, 4, 'Tomater'),
	(1, 5, 'Tomater'),
	(2, 1, 'Agurker'),
	(2, 2, 'Agurker'),
	(2, 3, 'Agurker'),
	(2, 4, 'Agurker'),
	(2, 5, 'Agurker'),
	(3, 1, 'Peberfrugter'),
	(3, 2, 'Peberfrugter'),
	(3, 3, 'Peberfrugter'),
	(3, 4, 'Peberfrugter'),
	(3, 5, 'Peberfrugter'),
	(4, 1, 'Basilikum'),
	(4, 2, 'Basilikum'),
	(4, 3, 'Basilikum'),
	(4, 4, 'Basilikum'),
	(4, 5, 'Basilikum')

INSERT INTO Plantetyper (plantetype, Plantebeskrivelse)
    VALUES 
    ('Tomater', 'Tomater er populaere drivhusplanter paa grund af deres haaje udbytte og smagfulde frugter. De kraever varme og sollys samt regelmaessig vanding.'),
    ('Agurker', 'Agurker trives i et drivhusmiljoe paa grund af den varme og fugtige atmosfaere. De producerer velsmagende og saftige groentsager, der kraever rigelig vanding.'),
    ('Peberfrugter', 'Peberfrugter, baade soede og varme sorter, trives godt i drivhuse. De kraever masser af sollys og varme for at modne ordentligt.'),
    ('Salat', 'Salat er en hurtigtvoksende groentsag, der er ideel til dyrkning i et drivhus. Den kraever regelmaessig vanding og delvis skygge for at forhindre, at bladene bliver bitre.'),
    ('Basilikum', 'Basilikum er en aromatisk urt, der trives i et varmt og solrigt drivhusmiljoe. Det kraever regelmaessig vanding og kan hoestes loebende for friske blade til madlavning.');

INSERT INTO BordMaaler (Drivhus, Bord, MaalerNr)
    VALUES
    (1, 1, 100102),
    (1, 1, 200101),
    (1, 1, 400101),
    (2, 1, 100200),
    (2, 1, 200200),
    (2, 1, 400200),

/*
    Oprettelse af Stored Procedure
*/

-- IF statement der sletter SP hvis den allerede er oprettet med samme navn
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'Gartner'
    AND SPECIFIC_NAME = N'SPUdtraekMaanedsStatistikker'
)
DROP PROCEDURE Gartner.SPUdtraekMaanedsStatistikker
GO
-- Oprettelse af SP i specifik skema
CREATE PROCEDURE Gartner.SPUdtraekMaanedsStatistikker(/*Variabel til søgning*/@MaalerType /*Datatype og antal tegn*/NVARCHAR(50))
-- add more stored procedure parameters here
AS
   SELECT
        TOP (100) PERCENT
        Medhjaelper.Plantetyper.Plantetype,
        Medhjaelper.Plantetyper.Plantebeskrivelse,
        Gartner.Maaler.Maaleenhed,
        FORMAT(Administration.Maaling.Tidspunkt, 'yyyy-MM') AS Tidspunkt, /* Formatering af data som kun tager År og Måned ud fra en datetime kolonne */
        CAST(AVG(Administration.Maaling.MaaltVaerdi) AS Decimal(10,2)) AS Gennemsnitstemperatur, /* Cast til kun at vise to decimaltal AVG til at finde gennemsnittet af data */
        MIN(Administration.Maaling.MaaltVaerdi) AS Minimumstemperatur, /* MIN der viser mindste værdi af dataerne*/
        MAX(Administration.Maaling.MaaltVaerdi) AS Maximumtemperatur /* Max der viser den største værdi af alle data*/
        FROM Medhjaelper.Plantetyper
            LEFT JOIN Medhjaelper.Bord
                ON Medhjaelper.Plantetyper.Plantetype = Medhjaelper.Bord.Plantetype
            LEFT JOIN Gartner.BordMaaler
                ON Medhjaelper.Bord.Drivhus = Gartner.BordMaaler.Drivhus
                    AND Medhjaelper.Bord.Bord = Gartner.BordMaaler.Bord
            LEFT JOIN Gartner.Maaler
                ON Gartner.BordMaaler.MaalerNr = Gartner.Maaler.MaalerNr 
                    AND Gartner.Maaler.MaalerType = @MaalerType /* Variablen der bliver indtastet i executen bliver brugt her hvor den kun finder den specifikke MaaleType */
            LEFT JOIN Administration.Maaling
                ON Gartner.Maaler.MaalerNr = Administration.Maaling.MaalerNr
            GROUP BY Medhjaelper.Plantetyper.Plantetype, Medhjaelper.Plantetyper.Plantebeskrivelse, Gartner.Maaler.Maaleenhed, FORMAT(Administration.Maaling.Tidspunkt, 'yyyy-MM')
            ORDER BY Medhjaelper.Plantetyper.Plantetype ASC
            
GO

/*
Eksempel til at køre SP hvor man kan søge med variablen

EXECUTE Gartner.SPUdtraekMaanedsStatistikker 'temperatur' 
GO
*/

/*
Oprettelse af View
IF Statement der tjekker om der er et view med samme navn hvis så sletter den
*/
IF EXISTS (
SELECT *
    FROM sys.views
    JOIN sys.schemas
    ON sys.views.schema_id = sys.schemas.schema_id
    WHERE sys.schemas.name = N'Gartner'
    AND sys.views.name = N'V_Maalinger_Per_Plantetype'
)
DROP VIEW Gartner.V_Maalinger_Per_Plantetype
GO
-- Opretter view i specifikt skema
CREATE VIEW Gartner.V_Maalinger_Per_Plantetype
AS
   SELECT
        TOP (100) PERCENT
        Medhjaelper.Plantetyper.Plantetype,
        Medhjaelper.Plantetyper.Plantebeskrivelse,
        Gartner.Maaler.Maaleenhed,
        FORMAT(Administration.Maaling.Tidspunkt, 'yyyy-MM') AS Tidspunkt,
        CAST(AVG(Administration.Maaling.MaaltVaerdi) AS Decimal(10,2)) AS Gennemsnitstemperatur,
        MIN(Administration.Maaling.MaaltVaerdi) AS Minimumstemperatur,
        MAX(Administration.Maaling.MaaltVaerdi) AS Maximumtemperatur
        FROM Medhjaelper.Plantetyper
            LEFT JOIN Medhjaelper.Bord
                ON Medhjaelper.Plantetyper.Plantetype = Medhjaelper.Bord.Plantetype
            LEFT JOIN Gartner.BordMaaler
                ON Medhjaelper.Bord.Drivhus = Gartner.BordMaaler.Drivhus
                    AND Medhjaelper.Bord.Bord = Gartner.BordMaaler.Bord
            LEFT JOIN Gartner.Maaler
                ON Gartner.BordMaaler.MaalerNr = Gartner.Maaler.MaalerNr 
                    AND Gartner.Maaler.MaalerType = 'Temperatur'
            LEFT JOIN Administration.Maaling
                ON Gartner.Maaler.MaalerNr = Administration.Maaling.MaalerNr
            GROUP BY Medhjaelper.Plantetyper.Plantetype, Medhjaelper.Plantetyper.Plantebeskrivelse, Gartner.Maaler.Maaleenhed, FORMAT(Administration.Maaling.Tidspunkt, 'yyyy-MM')
            ORDER BY Medhjaelper.Plantetyper.Plantetype ASC
    
GO