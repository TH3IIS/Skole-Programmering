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