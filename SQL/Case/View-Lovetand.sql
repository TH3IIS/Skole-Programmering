USE Gartneri
GO

-- Create a new view called 'V_Maalinger_Per_Plantetype' in schema 'Gartner'
-- Drop the view if it already exists
IF EXISTS (
SELECT *
    FROM sys.views
    JOIN sys.schemas
    ON sys.views.schema_id = sys.schemas.schema_id
    WHERE sys.schemas.name = N'Gartner'
    AND sys.views.name = N'V_Maalinger_Per_Plantetype'
)
DROP VIEW Gartner.V_Maalinger_Per_Plantetype
GO
-- Create the view in the specified schema
CREATE VIEW Gartner.V_Maalinger_Per_Plantetype
AS
   SELECT
        TOP (100) PERCENT
        Medhjaelper.Plantetyper.Plantetype,
        Medhjaelper.Plantetyper.Plantebeskrivelse,
        Gartner.Maaler.Maaleenhed,
        FORMAT(Administration.Maaling.Tidspunkt, 'yyyy-MM') AS Tidspunkt,
        CAST(AVG(Administration.Maaling.MaaltVaerdi) AS Decimal(10,2)) AS Gennemsnitstemperatur,
        MIN(Administration.Maaling.MaaltVaerdi) AS Minimumstemperatur,
        MAX(Administration.Maaling.MaaltVaerdi) AS Maximumtemperatur
        FROM Medhjaelper.Plantetyper
            LEFT JOIN Medhjaelper.Bord
                ON Medhjaelper.Plantetyper.Plantetype = Medhjaelper.Bord.Plantetype
            LEFT JOIN Gartner.BordMaaler
                ON Medhjaelper.Bord.Drivhus = Gartner.BordMaaler.Drivhus
                    AND Medhjaelper.Bord.Bord = Gartner.BordMaaler.Bord
            LEFT JOIN Gartner.Maaler
                ON Gartner.BordMaaler.MaalerNr = Gartner.Maaler.MaalerNr 
                    AND Gartner.Maaler.MaalerType = 'Temperatur'
            LEFT JOIN Administration.Maaling
                ON Gartner.Maaler.MaalerNr = Administration.Maaling.MaalerNr
            GROUP BY Medhjaelper.Plantetyper.Plantetype, Medhjaelper.Plantetyper.Plantebeskrivelse, Gartner.Maaler.Maaleenhed, FORMAT(Administration.Maaling.Tidspunkt, 'yyyy-MM')
            ORDER BY Medhjaelper.Plantetyper.Plantetype ASC
    
GO

