CREATE PROCEDURE [dbo].[Truncate_CountryDistributionFactors]
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if the table exists
    IF OBJECT_ID('etl.CountryDistributionFactors', 'U') IS NOT NULL
    BEGIN
        TRUNCATE TABLE etl.CountryDistributionFactors;
        PRINT 'Table etl.CountryDistributionFactors truncated successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Table etl.CountryDistributionFactors does not exist.';
    END
END;

GO

