/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesScrap]
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

    
	 
	MERGE [dim_v1].[Scrap] AS d
    USING (
			SELECT -1 AS [ScrapKey]
			, -1 AS [ScrapCompanyID]
			, 'Unknown' AS [ScrapCode]
			, 'Unknown' AS [ScrapName]
			, 'Unknown' AS [ScrapCodeName]
			, 'Unknown' AS [ScrapHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [ScrapKey]
			, -2 AS [ScrapCompanyID]
			, 'Blank' AS [ScrapCode]
			, 'Blank' AS [ScrapName]
			, 'Blank' AS [ScrapCodeName]
			, 'Blank' AS [ScrapHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[ScrapKey] = d.[ScrapKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([ScrapKey]
	, [ScrapCompanyID]
	, [ScrapCode]
	, [ScrapName]
	, [ScrapCodeName]
	, [ScrapHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[ScrapKey]
		, s.[ScrapCompanyID]
		, s.[ScrapCode]
		, s.[ScrapName]
		, s.[ScrapCodeName]
		, s.[ScrapHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[ScrapCompanyID] = s.[ScrapCompanyID]
		, d.[ScrapCode] = s.[ScrapCode]
		, d.[ScrapName] = s.[ScrapName]
		, d.[ScrapCodeName] = s.[ScrapCodeName]
		, d.[ScrapHashKey] = s.[ScrapHashKey]
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

