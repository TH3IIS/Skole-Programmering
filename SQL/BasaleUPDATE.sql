USE ElevplanStandard
GO

/*
    BASALE UPDATE
    Opgave 1
*/

UPDATE /* Tabel: */dbo.Fag
    SET /* Kolonne: */ FagNavn = 'Kundeservice' -- Hvad data bliver ændret til!
    WHERE /* Kolonne: */ FagID = 'SER' -- Hvor data ser sådan ud!

-- Opgave 2

UPDATE dbo.Aflevering
    SET [Status] = 'Godkendt'
    WHERE OpgaveID = 2

-- Opgave 3

UPDATE dbo.Modul
    SET [Start] = '08:30:00'
    WHERE [Start] = '08:15:00'

-- Opgave 4

UPDATE dbo.Karakter
    SET Karakter = 7, LaererID = 'LPOU' -- Flere data på samme query der bliver ændret
    WHERE Karakter = 4

-- Opgave 5

UPDATE dbo.Lektion
    SET LokaleID = 204
    WHERE SkemaDato = '2018-03-01' AND LokaleID = 101 -- Her er to forhold der skal opfyldes hvis rækken skal ændres

-- Opgave 6

UPDATE dbo.Elev
    SET HoldID = NULL -- Indsat NULL da Nøglen ikke acceptere en tom string
    WHERE ElevID = 8

-- KONTROL

SELECT * FROM dbo.Fag
SELECT * FROM dbo.Aflevering
SELECT * FROM dbo.Modul
SELECT * FROM dbo.Karakter
SELECT * FROM dbo.Lektion
SELECT * FROM dbo.Elev
SELECT * FROM dbo.Hold
