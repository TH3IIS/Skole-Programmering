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

-- Create a new table called 'Plantetyper' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Plantetyper', 'U') IS NOT NULL
DROP TABLE dbo.Plantetyper
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Plantetyper
(
    Plantetype [NVARCHAR](20) NOT NULL PRIMARY KEY, -- primary key column
    Plantebeskrivelse [NVARCHAR](100) NULL
);
GO

-- Create a new table called 'Bord' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Bord', 'U') IS NOT NULL
DROP TABLE dbo.Bord
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Bord
(
    Drivhus INT NOT NULL, -- primary key column
    Bord [NVARCHAR](50) NOT NULL,
    Plantetype [NVARCHAR](20) NOT NULL
    PRIMARY KEY(Drivhus, Bord)
);
GO

-- Create a new table called 'BordMaaler' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.BordMaaler', 'U') IS NOT NULL
DROP TABLE dbo.BordMaaler
GO
-- Create the table in the specified schema
CREATE TABLE dbo.BordMaaler
(
    Drivhus INT NOT NULL , -- primary key column
    Bord [NVARCHAR](50) NOT NULL,
    MaalerNr INT NOT NULL 
    PRIMARY KEY(Drivhus, Bord, MaalerNr)
);
GO

-- Create a new table called 'Maaler' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Maaler', 'U') IS NOT NULL
DROP TABLE dbo.Maaler
GO

-- Create the table in the specified schema
CREATE TABLE dbo.Maaler
(
    MaalerNr INT NOT NULL PRIMARY KEY, -- primary key column
    MaalerType [NVARCHAR](50) NOT NULL,
    Maaleenhed [NVARCHAR](50) NOT NULL
);
GO

-- Create a new table called 'Maaling' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Maaling', 'U') IS NOT NULL
DROP TABLE dbo.Maaling
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Maaling
(
    MaalingID INT NOT NULL PRIMARY KEY, -- primary key column
    MaalerNr INT NOT NULL,
    Tidspunkt DATETIME NOT NULL,
    MaaltVaerdi INT NOT NULL    
);
GO

/* Tilføjelse af Foreign keys */

ALTER TABLE dbo.Bord
    ADD FOREIGN KEY (Plantetype) REFERENCES dbo.Plantetyper(Plantetype) ON DELETE NO ACTION

ALTER TABLE dbo.BordMaaler
    ADD FOREIGN KEY(MaalerNr) REFERENCES dbo.Maaler(MaalerNr) ON DELETE NO ACTION,
    FOREIGN KEY(Drivhus, Bord) REFERENCES dbo.Bord(Drivhus, Bord) ON DELETE NO ACTION

ALTER TABLE dbo.Maaling
    ADD FOREIGN KEY (MaalerNr) REFERENCES dbo.Maaler(MaalerNr) ON DELETE NO ACTION

-- Målernummer + tidspunkt unique
-- Find selv planter

/*
BordMaaler
Bord
Plantetyper

Skal data selv sættes ind for at teste
*/