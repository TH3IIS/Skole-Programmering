USE ElevplanStandard /* Vælger hvilken database queries skal udføres i */
GO

/*
    BLANDEDE BOLCHER
    Opgave 1 & 2
*/

SELECT * -- Vælger alle rækker
    INTO dbo.Gamlehold -- Som bliver taget herfra
    FROM dbo.Hold -- Og sættes her i, med kolonner

-- Opgave 3

INSERT INTO dbo.Aflevering (OpgaveID, ElevID, [Status], Svar)
    SELECT 1, ElevID, 'V', 'Svaret er 42'
        FROM dbo.Elev
        WHERE HoldID = 'H2'

-- Opgave 4

INSERT INTO dbo.Karakter (ElevID, FagID, Karakter, [Status], LaererID)
    SELECT ElevID, 'NET', 12, 'Afleveret', 'LPOU'
        FROM dbo.Elev
        WHERE cprnr = '1409251234'

-- Opgave 5

UPDATE dbo.Karakter
    SET Karakter = 10
    WHERE FagID = 'DBS'
        AND ElevID IN(
            SELECT ElevID 
                FROM dbo.Elev
                WHERE Fornavn = 'Bente' AND Efternavn = 'Brem'
            )

-- Opgave 6

ALTER TABLE dbo.Aflevering
    ALTER COLUMN [Status] [VARCHAR](20) NULL

UPDATE dbo.Aflevering
    SET [Status] = 'Returneret til elev'
    WHERE OpgaveID = 1
        AND ElevID IN(
            SELECT ElevID
                FROM dbo.Elev
                WHERE Fornavn = 'Dennis' AND Efternavn = 'Dolmer'
        )

-- Opgave 7     IKKE FÆRDIG

SELECT count(ModulID) AS 'Antal lektioner 2018-03-01', LaererID
    FROM dbo.Lektion
    WHERE SkemaDato = '2018-03-01'
    GROUP BY LaererID

-- Kontrol

SELECT * FROM dbo.GamleHold

SELECT * FROM dbo.Aflevering
SELECT * FROM dbo.Elev
SELECT * FROM dbo.Fag
SELECT * FROM dbo.Hold
SELECT * FROM dbo.Karakter
SELECT * FROM dbo.Laerer
SELECT * FROM dbo.Lektion
SELECT * FROM dbo.Lokale
SELECT * FROM dbo.Modul
SELECT * FROM dbo.Opgave