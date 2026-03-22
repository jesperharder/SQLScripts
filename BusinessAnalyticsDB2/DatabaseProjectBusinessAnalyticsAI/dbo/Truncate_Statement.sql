CREATE PROCEDURE dbo.Truncate_Statement
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if the table exists
    IF OBJECT_ID('etl.Statement', 'U') IS NOT NULL
    BEGIN
        TRUNCATE TABLE etl.Statement;
        PRINT 'Table etl.Statement truncated successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Table etl.Statement does not exist.';
    END
END;

GO

