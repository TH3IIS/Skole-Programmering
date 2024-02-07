-- Opretter en database kaldet 'ElevplanNTYP'
-- Forbinder til 'master' database for at kører snippet NOTE: Koden er skrevet i VSCODE og bruger en SQL Extension men virker også igennem SSMS
USE master
GO
-- Opretter databasen hvis ikke der allerede findes en med det angivne navn
IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'ElevplanNTYP'
)
CREATE DATABASE ElevplanNTYP
GO

USE ElevplanNTYP /* Går 'ind' i databasen */
GO

CREATE SCHEMA Administration /* Opretter Skema i databasen */
GO

CREATE SCHEMA Undervisning
GO

/*
Opretter ny tabel kaldet 'Hold' i skemaet 'Undervisning'
Hvis tabellen allerede eksistere bliver den dropped/slettet
*/
IF OBJECT_ID('Undervisning.Hold', 'U') IS NOT NULL
DROP TABLE Undervisning.Hold
GO
-- Opretter Table i det specifikke skema
CREATE TABLE Undervisning.Hold
(
    Klasse INT IDENTITY PRIMARY KEY, -- primary key column
    Niveau [NVARCHAR](50) NOT NULL,
    "Start Periode" DATE NOT NULL,
    "Slut Periode" DATE NOT NULL,
    CONSTRAINT check_date CHECK ("Start Periode" < "Slut Periode")
);
GO

/*
Opretter ny tabel kaldet 'Laerer' i skemaet 'Administration'
Hvis tabellen allerede eksistere bliver den dropped/slettet
*/
IF OBJECT_ID('Administration.Laerer', 'U') IS NOT NULL
DROP TABLE Administration.Laerer
GO
-- Opretter Table i det specifikke skema
CREATE TABLE Administration.Laerer
(
    Fornavn [NVARCHAR](50) NOT NULL,
    Efternavn [NVARCHAR](50) NOT NULL,
    Initialer [NVARCHAR](4) NOT NULL PRIMARY KEY,
    TLFnr BIGINT NULL,
    MAIL [NVARCHAR](50) NULL,
    Ansaettelsesforhold [NVARCHAR](50) NOT NULL,
);
GO

ALTER TABLE Administration.Laerer
    ADD CONSTRAINT c_laerer_MailEllerTLF check (MAIL IS NOT NULL OR TLFnr IS NOT NULL) -- Forhindre indsætning af data hvis Mail eller tlf ikke er indsat

ALTER TABLE Administration.Laerer
    ADD CONSTRAINT c_laerer_mail check ([MAIL] LIKE '%@%.%') /* Kontrol om der MAIL kommer til at indeholde @ og . */


/*
Opretter ny tabel kaldet 'Elever' i skemaet 'Administration'
Hvis tabellen allerede eksistere bliver den dropped/slettet
*/
IF OBJECT_ID('Administration.Elever', 'U') IS NOT NULL
DROP TABLE Administration.Elever
GO
-- Opretter Table i det specifikke skema
CREATE TABLE Administration.Elever
(
    ElevID INT PRIMARY KEY IDENTITY,
    Fornavn [NVARCHAR](50) NOT NULL,
    Efternavn [NVARCHAR](50) NOT NULL,
    CPRnr BIGINT NOT NULL UNIQUE,
    Initialer [NVARCHAR](4) NOT NULL,
    "By" [NVARCHAR](50) NOT NULL,
    Postnr INT NOT NULL,
    Vejnavn [NVARCHAR](100) NOT NULL,
    Tlfnr BIGINT NULL,
    Mail [NVARCHAR](100) NULL,
    Klasse INT FOREIGN KEY REFERENCES Undervisning.Hold(Klasse) ON DELETE CASCADE,
    Kontaktlaerer [NVARCHAR](4) FOREIGN KEY REFERENCES Administration.Laerer(Initialer) ON DELETE SET NULL
);
GO

ALTER TABLE Administration.Elever
    ADD CONSTRAINT c_elev_MailEllerTLF check (MAIL IS NOT NULL OR TLFnr IS NOT NULL) -- Forhindre indsætning af data hvis Mail eller tlf ikke er indsat

ALTER TABLE Administration.Elever
    ADD CONSTRAINT c_elev_mail check ([MAIL] LIKE '%@%.%') -- Checker om mail indeholder @ og . 

/*
Opretter ny tabel kaldet 'Fag' i skemaet 'Administration'
Hvis tabellen allerede eksistere bliver den dropped/slettet
*/
IF OBJECT_ID('Administration.Fag', 'U') IS NOT NULL
DROP TABLE Administration.Fag
GO
-- Opretter Table i det specifikke skema
CREATE TABLE Administration.Fag
(
    Fag [NVARCHAR](50) NOT NULL PRIMARY KEY,
    Varighed [NVARCHAR](50) NOT NULL
);
GO

/*
Opretter ny tabel kaldet 'LaererTilFag' i skemaet 'Administration'
Hvis tabellen allerede eksistere bliver den dropped/slettet
*/
IF OBJECT_ID('Administration.LaererTilFag', 'U') IS NOT NULL
DROP TABLE Administration.LaererTilFag
GO
-- Opretter Table i det specifikke skema
CREATE TABLE Administration.LaererTilFag
(
    Undervisere [NVARCHAR](4) FOREIGN KEY REFERENCES Administration.Laerer(Initialer) ON DELETE CASCADE, /* Opretter en kolonne der hedder 'Undervisere' som har en FK fra Initialer i Administration.Laerer */
    Fag [NVARCHAR](50) FOREIGN KEY REFERENCES Administration.Fag(Fag) ON DELETE CASCADE,
    PRIMARY KEY(Undervisere, Fag) /* Bruges til at lave flere kolonner til PK*/
);
GO

/*
Opretter ny tabel kaldet 'Karaktere' i skemaet 'Undervisning'
Hvis tabellen allerede eksistere bliver den dropped/slettet
*/
IF OBJECT_ID('Undervisning.Karakter', 'U') IS NOT NULL
DROP TABLE Undervisning.Karakter
GO
-- Opretter Table i det specifikke skema
CREATE TABLE Undervisning.Karakter
(
    Fag [NVARCHAR](50) NOT NULL FOREIGN KEY REFERENCES Administration.Fag (Fag) ON DELETE CASCADE, -- primary key column
    Elev INT NOT NULL FOREIGN KEY REFERENCES Administration.Elever(ElevID) ON DELETE CASCADE,
    Laerer [NVARCHAR](4) NOT NULL FOREIGN KEY REFERENCES Administration.Laerer(Initialer) ON DELETE CASCADE,
    Karakter INT NOT NULL,
    Dato DATE NOT NULL,
    PRIMARY KEY(Fag, Elev),
    CONSTRAINT Syv_trins CHECK ((Karakter) in ('-3', '00', '02', '4', '7', '10', '12')) -- Checker for at der input kun bliver karaktere fra 7 trins skalaen
);
GO

-- Create a new table called 'Skema' in schema 'Undervisning'
-- Drop the table if it already exists
IF OBJECT_ID('Undervisning.Skema', 'U') IS NOT NULL
DROP TABLE Undervisning.Skema
GO
-- Create the table in the specified schema
CREATE TABLE Undervisning.Skema
(
    LektionID INT NOT NULL PRIMARY KEY,    
    Laerer [NVARCHAR](4) NOT NULL FOREIGN KEY REFERENCES Administration.Laerer(Initialer) ON DELETE CASCADE,
    Dato DATE NOT NULL,
    "Start Lektion" TIME NOT NULL,
    "Slut Lektion" TIME NOT NULL,
    Lokale [NVARCHAR](10) NOT NULL,
    Klasse INT NOT NULL FOREIGN KEY REFERENCES Undervisning.Hold(Klasse) ON DELETE CASCADE,
    Fag [NVARCHAR](50) NOT NULL FOREIGN KEY REFERENCES Administration.Fag(Fag) ON DELETE CASCADE
);
GO