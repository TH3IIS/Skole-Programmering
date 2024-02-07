USE ElevplanStandard
GO

ALTER TABLE DBO.Aflevering -- Fortæller hvilken tabel der skal ændres
    ALTER COLUMN BesvarelsesID INT NOT NULL -- Fortæller hvilken kolonne der ændres, og at den ændres til INT

/*  IDENTITY COLUMN UDFØRT VIA GUI  */

ALTER TABLE DBO.Aflevering
    ADD FOREIGN KEY (OpgaveID) REFERENCES DBO.Opgave(OpgaveID) ON DELETE CASCADE -- Tilføjer FK på Kolonnen OpgaveID