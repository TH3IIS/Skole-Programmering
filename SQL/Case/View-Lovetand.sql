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
    -- body of the view
    SELECT [Column1],
        [Column2],
        [Column3],
    FROM Gartner.TableName
GO