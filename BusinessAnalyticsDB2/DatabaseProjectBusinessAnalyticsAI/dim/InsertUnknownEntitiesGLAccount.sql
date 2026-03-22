/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesGLAccount]
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

    
	 
	MERGE [dim].[GLAccount] AS d
    USING (
			SELECT -1 AS [GLAccountKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [AccountNo]
			, 'Unknown' AS [AccountName]
			, 'Unknown' AS [AccountNoDescription]
			, 'Unknown' AS [Account_Income_Balance]
			, 'Unknown' AS [Account_Main]
			, 'Unknown' AS [GLAccountHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [GLAccountKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [AccountNo]
			, 'Blank' AS [AccountName]
			, 'Blank' AS [AccountNoDescription]
			, 'Blank' AS [Account_Income_Balance]
			, 'Blank' AS [Account_Main]
			, 'Blank' AS [GLAccountHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[GLAccountKey] = d.[GLAccountKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([GLAccountKey]
	, [CompanyID]
	, [AccountNo]
	, [AccountName]
	, [AccountNoDescription]
	, [Account_Income_Balance]
	, [Account_Main]
	, [GLAccountHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[GLAccountKey]
		, s.[CompanyID]
		, s.[AccountNo]
		, s.[AccountName]
		, s.[AccountNoDescription]
		, s.[Account_Income_Balance]
		, s.[Account_Main]
		, s.[GLAccountHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[AccountNo] = s.[AccountNo]
		, d.[AccountName] = s.[AccountName]
		, d.[AccountNoDescription] = s.[AccountNoDescription]
		, d.[Account_Income_Balance] = s.[Account_Income_Balance]
		, d.[Account_Main] = s.[Account_Main]
		, d.[GLAccountHashKey] = s.[GLAccountHashKey]
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

