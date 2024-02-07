USE ElevplanStandard
GO

/*
    BASALE DELETE
    Opgave 1
*/

DELETE FROM /*Tabel: */ dbo.Lektion
    WHERE /* Kolonne: */ LaererID IS NULL -- IS NULL er en operator og der skal derfor ikke bruges = da vi ikke søger efter specifik data

-- Opgave 2

DELETE FROM dbo.Opgave
    WHERE OpgaveID = 2 -- Ingen fejl med FK da den er lavet med CASCADE ACTION

-- KONTROL

SELECT * FROM dbo.Lektion
SELECT * FROM dbo.Aflevering
SELECT * FROM dbo.Opgave