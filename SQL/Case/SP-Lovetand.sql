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
CREATE PROCEDURE Gartner.SPUdtraekMaanedsStatistikker
    @param1 /*parameter name*/ int /*datatype_for_param1*/ = 0, /*default_value_for_param1*/
    @param2 /*parameter name*/ int /*datatype_for_param1*/ = 0 /*default_value_for_param2*/
-- add more stored procedure parameters here
AS
    -- body of the stored procedure
    SELECT @param1, @param2
GO
-- example to execute the stored procedure we just created
EXECUTE Gartner.SPUdtraekMaanedsStatistikker 1 /*value_for_param1*/, 2 /*value_for_param2*/
GO