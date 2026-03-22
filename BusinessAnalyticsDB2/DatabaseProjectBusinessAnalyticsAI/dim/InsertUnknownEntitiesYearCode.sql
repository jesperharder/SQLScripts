/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesYearCode]
AS
BEGIN
    SET NOCOUNT ON;
 
    BEGIN TRY
    -- Get the current transaction count
    DECLARE @TranCounter INT = @@TRANCOUNT
		,@SavePoint NVARCHAR(32) = CAST(@@PROCID AS NVARCHAR(20)) + N'_' + CAST(@@NESTLEVEL AS NVARCHAR(2));

    -- Decide to join existing transaction or start new
    IF @TranCounter > 0
      SAVE TRANSACTION @SavePoint;
    ELSE
      BEGIN TRANSACTION;

    
	 
	MERGE [dim].[YearCode] AS d
    USING (
			SELECT -1 AS [YearCodeKey]
			, -1 AS [YearCodeCompanyID]
			, 'Unknown' AS [YearCodeText]
			, 'Unknown' AS [YearCodeFromDate]
			, 'Unknown' AS [YearCodeToDate]
			, 'Unknown' AS [YearCodeHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [YearCodeKey]
			, -2 AS [YearCodeCompanyID]
			, 'Blank' AS [YearCodeText]
			, 'Blank' AS [YearCodeFromDate]
			, 'Blank' AS [YearCodeToDate]
			, 'Blank' AS [YearCodeHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[YearCodeKey] = d.[YearCodeKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([YearCodeKey]
	, [YearCodeCompanyID]
	, [YearCodeText]
	, [YearCodeFromDate]
	, [YearCodeToDate]
	, [YearCodeHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[YearCodeKey]
		, s.[YearCodeCompanyID]
		, s.[YearCodeText]
		, s.[YearCodeFromDate]
		, s.[YearCodeToDate]
		, s.[YearCodeHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[YearCodeCompanyID] = s.[YearCodeCompanyID]
		, d.[YearCodeText] = s.[YearCodeText]
		, d.[YearCodeFromDate] = s.[YearCodeFromDate]
		, d.[YearCodeToDate] = s.[YearCodeToDate]
		, d.[YearCodeHashKey] = s.[YearCodeHashKey]
		, d.[ADF_BatchId_Insert] = s.[ADF_BatchId_Insert]
		, d.[ADF_BatchId_Update] = s.[ADF_BatchId_Update]
		

	OPTION ( RECOMPILE );
 	
    
    -- Commit only if the transaction was started in this procedure
        IF @TranCounter = 0
            COMMIT TRANSACTION;
    END TRY
 
    BEGIN CATCH
 
    -- Only rollback if transaction was started in this procedure
        IF @TranCounter = 0
            ROLLBACK TRANSACTION;
    -- It's not our transaction but it's still OK
        ELSE
            IF XACT_STATE() = 1
                ROLLBACK TRANSACTION @SavePoint
    -- All hope is lost - rollback!
            ELSE
                IF XACT_STATE() = -1
                    ROLLBACK TRANSACTION;
 
        THROW;
        RETURN 1;
 
    END CATCH;
END

GO

