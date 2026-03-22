/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesBOM]
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

    
	 
	MERGE [dim].[BOM] AS d
    USING (
			SELECT -1 AS [BOMKey]
			, -1 AS [BOMCompanyID]
			, 'Unknown' AS [BOMNumber]
			, 'Unknown' AS [BOMName]
			, 'Unknown' AS [BOMNumberName]
			, 'Unknown' AS [BOMUnitOfMeasureCode]
			, -1 AS [BOMLowLevelCode]
			, 'Unknown' AS [BOMStatus]
			, 'Unknown' AS [BOMHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [BOMKey]
			, -2 AS [BOMCompanyID]
			, 'Blank' AS [BOMNumber]
			, 'Blank' AS [BOMName]
			, 'Blank' AS [BOMNumberName]
			, 'Blank' AS [BOMUnitOfMeasureCode]
			, -2 AS [BOMLowLevelCode]
			, 'Blank' AS [BOMStatus]
			, 'Blank' AS [BOMHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[BOMKey] = d.[BOMKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([BOMKey]
	, [BOMCompanyID]
	, [BOMNumber]
	, [BOMName]
	, [BOMNumberName]
	, [BOMUnitOfMeasureCode]
	, [BOMLowLevelCode]
	, [BOMStatus]
	, [BOMHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[BOMKey]
		, s.[BOMCompanyID]
		, s.[BOMNumber]
		, s.[BOMName]
		, s.[BOMNumberName]
		, s.[BOMUnitOfMeasureCode]
		, s.[BOMLowLevelCode]
		, s.[BOMStatus]
		, s.[BOMHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[BOMCompanyID] = s.[BOMCompanyID]
		, d.[BOMNumber] = s.[BOMNumber]
		, d.[BOMName] = s.[BOMName]
		, d.[BOMNumberName] = s.[BOMNumberName]
		, d.[BOMUnitOfMeasureCode] = s.[BOMUnitOfMeasureCode]
		, d.[BOMLowLevelCode] = s.[BOMLowLevelCode]
		, d.[BOMStatus] = s.[BOMStatus]
		, d.[BOMHashKey] = s.[BOMHashKey]
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

