CREATE PROCEDURE dbo.Truncate_ReportAccountRules
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if the table exists
    IF OBJECT_ID('etl.ReportAccountRules', 'U') IS NOT NULL
    BEGIN
        TRUNCATE TABLE etl.ReportAccountRules;
        PRINT 'Table etl.ReportAccountRules truncated successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Table etl.ReportAccountRules does not exist.';
    END
END;

GO

