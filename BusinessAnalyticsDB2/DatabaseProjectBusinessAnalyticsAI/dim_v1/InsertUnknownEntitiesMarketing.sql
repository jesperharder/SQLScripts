/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesMarketing]
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

    
	 
	MERGE [dim_v1].[Marketing] AS d
    USING (
			SELECT -1 AS [MarketingKey]
			, 'Unknown' AS [MarketingCode]
			, 'Unknown' AS [MarketingName]
			, 'Unknown' AS [MarketingCodeName]
			, 'Unknown' AS [MarketingHashKey]
			, 'Unknown' AS [Dimension Code]
			, -1 AS [CompanyID]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [MarketingKey]
			, 'Blank' AS [MarketingCode]
			, 'Blank' AS [MarketingName]
			, 'Blank' AS [MarketingCodeName]
			, 'Blank' AS [MarketingHashKey]
			, 'Blank' AS [Dimension Code]
			, -2 AS [CompanyID]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[MarketingKey] = d.[MarketingKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([MarketingKey]
	, [MarketingCode]
	, [MarketingName]
	, [MarketingCodeName]
	, [MarketingHashKey]
	, [Dimension Code]
	, [CompanyID]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[MarketingKey]
		, s.[MarketingCode]
		, s.[MarketingName]
		, s.[MarketingCodeName]
		, s.[MarketingHashKey]
		, s.[Dimension Code]
		, s.[CompanyID]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[MarketingCode] = s.[MarketingCode]
		, d.[MarketingName] = s.[MarketingName]
		, d.[MarketingCodeName] = s.[MarketingCodeName]
		, d.[MarketingHashKey] = s.[MarketingHashKey]
		, d.[Dimension Code] = s.[Dimension Code]
		, d.[CompanyID] = s.[CompanyID]
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

