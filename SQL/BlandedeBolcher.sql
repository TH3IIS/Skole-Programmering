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
    SELECT 1, ElevID, 'V', 'Svaret er 42' -- Her tages alle elev id'er fra elev tabellen og bruge til indsætning i afleveringstabellen
        FROM dbo.Elev
        WHERE HoldID = 'H2'

-- Opgave 4

INSERT INTO dbo.Karakter (ElevID, FagID, Karakter, [Status], LaererID) -- Kolonner hvor værdi skal indsættes
    SELECT ElevID, 'NET', 12, 'Afleveret', 'LPOU' -- værdi som skal i kolonnerne - Elevid bliver hentet fra elev tabellen MEN WHERE specificere at det er eleven med følgende cprnr
        FROM dbo.Elev
        WHERE cprnr = '1409251234'

-- Opgave 5

UPDATE dbo.Karakter -- Opdatering og i hvilken tabel
    SET /*Kolonne: */ Karakter = /* Ny værdi: */ 10 
    WHERE FagID = 'DBS' -- Hvor faget er
        AND ElevID IN(
            SELECT ElevID 
                FROM dbo.Elev
                WHERE Fornavn = 'Bente' AND Efternavn = 'Brem'
            ) -- Finder ElevID ud fra navnet fra anden tabel

-- Opgave 6

ALTER TABLE dbo.Aflevering
    ALTER COLUMN [Status] [VARCHAR](20) NULL -- Ændre "Designet" af kolonnen da den ikke kunne indeholde teksten.

UPDATE dbo.Aflevering
    SET [Status] = 'Returneret til elev'
    WHERE OpgaveID = 1
        AND ElevID IN(
            SELECT ElevID
                FROM dbo.Elev
                WHERE Fornavn = 'Dennis' AND Efternavn = 'Dolmer'
        )

-- Opgave 7

SELECT dbo.Laerer.LaererID,/*Tæller antal moduler*/ Count(ModulID) AS "Lektioner d. 01/03-2018"
    FROM dbo.Laerer
    JOIN dbo.Lektion -- Joiner lektionstabellen for at kunne søge efter skemadato
    ON dbo.Laerer.LaererID = dbo.Lektion.LaererID
    WHERE dbo.Lektion.SkemaDato = '2018-03-01' -- Tjekker for lektion med følgende dato
    GROUP BY dbo.laerer.LaererID --grupperes efter lærer

-- Opgave 8

SELECT dbo.Fag.FagNavn, /*Gennemsnit: */AVG(/*Ændre dataen til at blive læst som INT*/CAST(dbo.Karakter.Karakter AS INT)) AS "Gennemsnitlig Karakter"
    FROM dbo.Karakter
    JOIN dbo.Fag
    ON dbo.Fag.FagID = dbo.Karakter.FagID
    GROUP BY dbo.Fag.FagNavn

-- Opgave 9 

SELECT dbo.Elev.ElevID, dbo.Elev.Fornavn, dbo.Elev.Efternavn, dbo.Laerer.FORNAVN, dbo.Laerer.EFTERNAVN
    FROM dbo.Elev
    LEFT JOIN dbo.Laerer -- LEFT JOIN for at tage ALT indhold fra elev tabellen og så koble sammenhæng med laerer tabellen efter
    ON dbo.Elev.LaererID = dbo.Laerer.LaererID

-- Opgave 10

SELECT DISTINCT dbo.Elev.ElevID, dbo.Elev.Fornavn, dbo.Elev.Efternavn, dbo.Karakter.Karakter -- Distinct ikke at få flere entries af samme elev
    FROM dbo.Elev
    JOIN dbo.Karakter
    ON dbo.Elev.ElevID = dbo.Karakter.ElevID
    WHERE CAST(dbo.Karakter.Karakter AS INT) >= 10 

-- Opgave 11

SELECT dbo.Laerer.LaererID, dbo.Laerer.FORNAVN, dbo.Laerer.EFTERNAVN
    FROM dbo.Laerer
    LEFT JOIN dbo.Elev -- LEFT JOIN igen for at hente al data fra laerer tabel og derefter sammenligne med elev tabel
    ON dbo.Laerer.LaererID = dbo.Elev.LaererID
    WHERE dbo.Elev.LaererID IS NULL

-- Opgave 12

SELECT COUNT(/*Distinct count for ikke at få flere a samme entry*/DISTINCT FagID) AS "Antal fag", LaererID
    FROM dbo.Lektion
    GROUP BY LaererID

-- Opgave 13

SELECT COUNT(DISTINCT dbo.Lektion.FagID) AS "Antal fag", dbo.Laerer.LaererID, dbo.Laerer.FORNAVN, dbo.Laerer.EFTERNAVN
    FROM dbo.Lektion
    JOIN dbo.Laerer
    ON dbo.Laerer.LaererID = dbo.Lektion.LaererID
    GROUP BY dbo.Laerer.LaererID, dbo.Laerer.FORNAVN, dbo.Laerer.EFTERNAVN
    HAVING COUNT(DISTINCT FagID) > 1

-- Opgave 14

SELECT dbo.Fag.FagID, dbo.Fag.FagNavn, (Select STRING_AGG(L.LaererID,', ')) AS "Undervisere" -- Ligger flere entries i samme kolonne og deler dem op med et komma
    FROM (SELECT DISTINCT dbo.Lektion.LaererID, dbo.Lektion.FagID FROM dbo.Lektion) AS L --Laver subquery og navngiver den l for at hente data fra den i resten af querien
    JOIN dbo.Fag
    ON L.FagID = dbo.Fag.FagID
    GROUP BY dbo.Fag.FagID, dbo.Fag.FagNavn

-- Opgave 15

INSERT INTO dbo.Opgave (LaererID, HoldID, Offentliggøres, Svarfrist, Beskrivelse)
    SELECT 'LPOU', dbo.Hold.HoldID, '2018-03-29', '2018-03-29', 'Fælles projektdag'
        FROM dbo.Hold 
        WHERE '2018-03-29' BETWEEN dbo.Hold.StartDato AND dbo.Hold.SlutDato -- Kontroller efter data imellem dato fra anden tabel.

-- Opgave 16

DELETE 
    FROM dbo.Opgave   
    Where dbo.Opgave.HoldID IN(SELECT HoldID FROM dbo.Hold where dbo.hold.Forloeb = '1HF') AND Beskrivelse = 'Fælles projektdag' AND Offentliggøres = '2018-03-29'

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