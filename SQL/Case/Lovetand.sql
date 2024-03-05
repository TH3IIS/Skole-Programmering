-- Create a new database called 'Gartneri'
-- Connect to the 'master' database to run this snippet
USE master
GO

-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'Gartneri'
)
CREATE DATABASE Gartneri
GO

USE Gartneri
GO

CREATE SCHEMA Gartner
GO

CREATE SCHEMA Medhjaelper
GO

CREATE SCHEMA Administration
GO

-- Create a new table called 'Plantetyper' in schema 'Medhjaelper'
-- Drop the table if it already exists
IF OBJECT_ID('Medhjaelper.Plantetyper', 'U') IS NOT NULL
DROP TABLE Medhjaelper.Plantetyper
GO
-- Create the table in the specified schema
CREATE TABLE Medhjaelper.Plantetyper
(
    Plantetype [NVARCHAR](20) NOT NULL PRIMARY KEY, -- primary key column
    Plantebeskrivelse [NVARCHAR](200) NULL
);
GO

-- Create a new table called 'Bord' in schema 'Medhjaelper'
-- Drop the table if it already exists
IF OBJECT_ID('Medhjaelper.Bord', 'U') IS NOT NULL
DROP TABLE Medhjaelper.Bord
GO
-- Create the table in the specified schema
CREATE TABLE Medhjaelper.Bord
(
    Drivhus INT NOT NULL, -- primary key column
    Bord [NVARCHAR](50) NOT NULL,
    Plantetype [NVARCHAR](20) NOT NULL
    PRIMARY KEY(Drivhus, Bord)
);
GO

-- Create a new table called 'BordMaaler' in schema 'Gartner'
-- Drop the table if it already exists
IF OBJECT_ID('Gartner.BordMaaler', 'U') IS NOT NULL
DROP TABLE Gartner.BordMaaler
GO
-- Create the table in the specified schema
CREATE TABLE Gartner.BordMaaler
(
    Drivhus INT NOT NULL , -- primary key column
    Bord [NVARCHAR](50) NOT NULL,
    MaalerNr INT NOT NULL 
    PRIMARY KEY(Drivhus, Bord, MaalerNr)
);
GO

-- Create a new table called 'Maaler' in schema 'Gartner'
-- Drop the table if it already exists
IF OBJECT_ID('Gartner.Maaler', 'U') IS NOT NULL
DROP TABLE Gartner.Maaler
GO

-- Create the table in the specified schema
CREATE TABLE Gartner.Maaler
(
    MaalerNr INT NOT NULL PRIMARY KEY, -- primary key column
    MaalerType [NVARCHAR](50) NOT NULL,
    Maaleenhed [NVARCHAR](50) NULL
);
GO

-- Create a new table called 'Maaling' in schema 'Administration'
-- Drop the table if it already exists
IF OBJECT_ID('Administration.Maaling', 'U') IS NOT NULL
DROP TABLE Administration.Maaling
GO
-- Create the table in the specified schema
CREATE TABLE Administration.Maaling
(
    MaalingID INT NOT NULL IDENTITY PRIMARY KEY, -- primary key column
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

-- Målernummer + tidspunkt unique
-- Find selv planter

/*
BordMaaler
Bord
Plantetyper

Skal data selv sættes ind for at teste
*/