USE ElevplanStandard
GO

/*      BASALE INSERT
        Opgave 1
*/

INSERT INTO /* Tabel: */ dbo.Laerer /* Kolonner: */(LaererID, FORNAVN, EFTERNAVN, Telefon)
    VALUES (/* LaererID: */'HCA', /* FORNAVN: */ 'Hans Christian', /* EFTERNAVN: */ 'Andersen', /* Telefon: */ '21674539')

-- Opgave 2

INSERT INTO dbo.Elev (Fornavn, Efternavn, HoldID, LaererID, Telefon, cprnr)
    VALUES ('Nicki', 'Theis Yde Poulsen', 'H1a', 'VAT', '32345678', '1231790101')

--Opgave 3

INSERT INTO dbo.Fag (FagID, FagNavn)
    VALUES ('ITIL', 'IT Service Management'),
    ('Python', 'Python programmering')

--Opgave 4

INSERT INTO dbo.Lokale (LokaleID, LokaleNavn, antalPladser, Adresse, Postnr)
    VALUES ('204', 'Lokale 204', '40', 'Boulevarden 19a', '7100')

-- Kontrol
SELECT * FROM dbo.Laerer
SELECT * FROM dbo.Elev
SELECT * FROM dbo.Fag
SELECT * FROM dbo.Lokale
