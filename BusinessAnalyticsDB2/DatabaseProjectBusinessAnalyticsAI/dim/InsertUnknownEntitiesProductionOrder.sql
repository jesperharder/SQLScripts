/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesProductionOrder]
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

    
	 
	MERGE [dim].[ProductionOrder] AS d
    USING (
			SELECT -1 AS [ProductionOrderKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [ProductionOrderNumber]
			, -1 AS [ProductionOrderLineNumber]
			, 'Unknown' AS [ProductionOrderStatus]
			, '1900-01-01' AS [StartingDate]
			, '1900-01-01' AS [DueDate]
			, '1900-01-01' AS [EndingDate]
            , -1 AS [ProductionOrderStatusID]
			, 'Unknown' AS [ProductionOrderHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			, 0x AS [ADF_LastTimestamp]
			, 'Unknown' AS [ADF_DimensionSource]
			
			UNION ALL

			SELECT -2 AS [ProductionOrderKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [ProductionOrderNumber]
			, -2 AS [ProductionOrderLineNumber]
			, 'Blank' AS [ProductionOrderStatus]
			, '1900-01-01' AS [StartingDate]
			, '1900-01-01' AS [DueDate]
			, '1900-01-01' AS [EndingDate]
            , -2 AS [ProductionOrderStatusID]
			, 'Blank' AS [ProductionOrderHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			, 0x AS [ADF_LastTimestamp]
			, 'Blank' AS [ADF_DimensionSource]
			
		  ) s
	ON s.[ProductionOrderKey] = d.[ProductionOrderKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([ProductionOrderKey]
	, [CompanyID]
	, [ProductionOrderNumber]
	, [ProductionOrderLineNumber]
	, [ProductionOrderStatus]
	, [StartingDate]
	, [DueDate]
	, [EndingDate]
    , [ProductionOrderStatusID]
	, [ProductionOrderHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	, [ADF_LastTimestamp]
	, [ADF_DimensionSource]
	
	)
    VALUES (s.[ProductionOrderKey]
		, s.[CompanyID]
		, s.[ProductionOrderNumber]
		, s.[ProductionOrderLineNumber]
		, s.[ProductionOrderStatus]
		, s.[StartingDate]
		, s.[DueDate]
		, s.[EndingDate]
        , s.[ProductionOrderStatusID]
		, s.[ProductionOrderHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		, s.[ADF_LastTimestamp]
		, s.[ADF_DimensionSource]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[ProductionOrderNumber] = s.[ProductionOrderNumber]
		, d.[ProductionOrderLineNumber] = s.[ProductionOrderLineNumber]
		, d.[ProductionOrderStatus] = s.[ProductionOrderStatus]
		, d.[StartingDate] = s.[StartingDate]
		, d.[DueDate] = s.[DueDate]
		, d.[EndingDate] = s.[EndingDate]
        , d.[ProductionOrderStatusID] = s.[ProductionOrderStatusID]
		, d.[ProductionOrderHashKey] = s.[ProductionOrderHashKey]
		, d.[ADF_BatchId_Insert] = s.[ADF_BatchId_Insert]
		, d.[ADF_BatchId_Update] = s.[ADF_BatchId_Update]
		, d.[ADF_LastTimestamp] = s.[ADF_LastTimestamp]
		, d.[ADF_DimensionSource] = s.[ADF_DimensionSource]
		

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

