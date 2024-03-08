USE Gartneri
GO

-- Create a new stored procedure called 'SPUdtraekMaanedsStatistikker' in schema 'Gartner'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'Gartner'
    AND SPECIFIC_NAME = N'SPUdtraekMaanedsStatistikker'
)
DROP PROCEDURE Gartner.SPUdtraekMaanedsStatistikker
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE Gartner.SPUdtraekMaanedsStatistikker(@MaalerType NVARCHAR(50))
-- add more stored procedure parameters here
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
                    AND Gartner.Maaler.MaalerType = @MaalerType
            LEFT JOIN Administration.Maaling
                ON Gartner.Maaler.MaalerNr = Administration.Maaling.MaalerNr
            GROUP BY Medhjaelper.Plantetyper.Plantetype, Medhjaelper.Plantetyper.Plantebeskrivelse, Gartner.Maaler.Maaleenhed, FORMAT(Administration.Maaling.Tidspunkt, 'yyyy-MM')
            ORDER BY Medhjaelper.Plantetyper.Plantetype ASC
            
GO
-- example to execute the stored procedure we just created
EXECUTE Gartner.SPUdtraekMaanedsStatistikker 'temperatur' /*value_for_param1*/
GO

SELECT * FROM Gartner.V_Maalinger_Per_Plantetype