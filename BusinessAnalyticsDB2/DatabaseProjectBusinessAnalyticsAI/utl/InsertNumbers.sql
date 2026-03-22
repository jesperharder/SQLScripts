CREATE PROCEDURE [utl].[InsertNumbers] @Count int = 1000000 /* Default 1,000,000 numbers (rows) */
AS
BEGIN
    SET NOCOUNT ON;
    /*
	Purpose: Populates the table utility.Numbers
*/

    BEGIN TRY

        -- Get the current transaction count
        DECLARE @TranCounter int = @@TRANCOUNT
               ,@SavePoint nvarchar(32) = CAST(@@PROCID AS nvarchar(20)) + N'_' + CAST(@@NESTLEVEL AS nvarchar(2));

        -- Decide to join existing transaction or start new
        IF @TranCounter > 0 SAVE TRANSACTION @SavePoint;
        ELSE BEGIN TRANSACTION;

        TRUNCATE TABLE [utl].[Numbers];
        WITH [Numbers]
        ([Number])
        AS
        (
            SELECT 1 AS [Number]
            UNION ALL
            SELECT ([n].[Number] + 1)
            FROM [Numbers] AS [n]
            WHERE [n].[Number] < @Count
        )
        INSERT INTO [utl].[Numbers]
        (
            [Number]
        )
        SELECT [n].[Number]
        FROM [Numbers] AS [n]
        OPTION(MAXRECURSION 0);

        -- Commit only if the transaction was started in this procedure
        IF @TranCounter = 0 COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        -- Only rollback if transaction was started in this procedure
        IF @TranCounter = 0 ROLLBACK TRANSACTION;
        -- It's not our transaction but it's still OK
        ELSE IF XACT_STATE() = 1 ROLLBACK TRANSACTION @SavePoint;
        -- All hope is lost - rollback!
        ELSE IF XACT_STATE() = -1 ROLLBACK TRANSACTION;

        THROW;
        RETURN 1;

    END CATCH;
END;

GO

