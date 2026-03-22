/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesCurrency]
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

    
	 
	MERGE [dim_v1].[Currency] AS d
    USING (
			SELECT -1 AS [CurrencyKey]
            , -1 AS [CurrencyCompanyID]
			, 'Unknown' AS [CurrencyCode]
			, 'Unknown' AS [CurrencyName]
			, 'Unknown' AS [CurrencyCodeName]
			, 'Unknown' AS [CurrencyHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [CurrencyKey]
            , -2 AS [CurrencyCompanyID]
			, 'Blank' AS [CurrencyCode]
			, 'Blank' AS [CurrencyName]
			, 'Blank' AS [CurrencyCodeName]
			, 'Blank' AS [CurrencyHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[CurrencyKey] = d.[CurrencyKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([CurrencyKey]
    , [CurrencyCompanyID]
	, [CurrencyCode]
	, [CurrencyName]
	, [CurrencyCodeName]
	, [CurrencyHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[CurrencyKey]
        , s.[CurrencyCompanyID]
		, s.[CurrencyCode]
		, s.[CurrencyName]
		, s.[CurrencyCodeName]
		, s.[CurrencyHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
        d.[CurrencyCompanyID] = s.[CurrencyCompanyID]
		, d.[CurrencyCode] = s.[CurrencyCode]
		, d.[CurrencyName] = s.[CurrencyName]
		, d.[CurrencyCodeName] = s.[CurrencyCodeName]
		, d.[CurrencyHashKey] = s.[CurrencyHashKey]
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

