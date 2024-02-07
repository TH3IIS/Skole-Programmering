USE ElevplanStandard /* Vælger hvilken database queries skal udføres i */
GO

/*
    BASALE UDTRÆK AF DATA
    Opgave 1
*/

SELECT /* Kolonne: */ LaererID, Fornavn, Efternavn, Telefon 
    FROM /*Tabel: */ dbo.laerer
GO

-- Opgave 2

SELECT elevID, Fornavn, Efternavn,/*Skema.Tabel.Kolonne*/ dbo.Elev.HoldID, dbo.Hold.Holdnavn 
    FROM dbo.Elev 
    JOIN /* Tabel: */dbo.Hold 
    ON /* Kolonne: */dbo.Elev.HoldID /* Sammenligning -> */ = /* Kolonne: */ dbo.Hold.HoldID
    ORDER BY Efternavn, Fornavn, ElevID ASC -- Stigende Sortering af Kolonner 
GO

-- Opgave 3

SELECT elevID, Fornavn, Efternavn, dbo.Hold.Holdnavn
    FROM dbo.Elev
    JOIN dbo.Hold
    ON dbo.Elev.HoldID = dbo.Hold.HoldID
    WHERE Elev.HoldID /* Denne operator betyder NOT EQUAL TO alternativ kan <> bruges */ != 'H2'
GO

-- Opgave 4

SELECT dbo.Elev.ElevID, Fornavn, Efternavn, dbo.Karakter.Karakter, dbo.Karakter.FagID
    FROM dbo.Elev
    JOIN dbo.Karakter
    ON dbo.Elev.ElevID = dbo.Karakter.ElevID
    WHERE dbo.Karakter.Karakter >= 10 -- Putter du 10 i anførselstegn får du det forkerte resultat da du søger med en string og ikke int selvom kolonnens datatype er nchar
GO

-- Opgave 5

SELECT HoldID, count(ElevID) as 'Antal elever'
    FROM dbo.Elev
    GROUP BY HoldID
GO

-- Opgave 6

CREATE VIEW Opgave_6 AS -- Opretter View'et
    SELECT dbo.Lektion.SkemaDato, dbo.Modul.[Start], dbo.Modul.[Slut], dbo.Lektion.LokaleID, dbo.Fag.FagNavn, dbo.Laerer.FORNAVN, dbo.Laerer.EFTERNAVN -- Her vælges ønsket kolonner der skal bruges til view'et
        FROM dbo.Lektion
        JOIN dbo.Modul -- Her joines de andre tabeller så data kan trækkes fra dem også
        ON dbo.Lektion.ModulID = dbo.Modul.ModulID -- Her sammenlignes data i kolonner mellem tabeller til at samle en række der viser korrekt data
        JOIN dbo.Fag
        ON dbo.Lektion.FagID = dbo.Fag.FagID
        JOIN dbo.Laerer
        ON dbo.Lektion.LaererID = dbo.Laerer.LaererID

SELECT * FROM Opgave_6

-- Kontrol
SELECT * FROM dbo.Hold
SELECT * FROM dbo.Karakter
SELECT * FROM dbo.Fag
SELECT * FROM dbo.Modul
SELECT * FROM dbo.Lektion