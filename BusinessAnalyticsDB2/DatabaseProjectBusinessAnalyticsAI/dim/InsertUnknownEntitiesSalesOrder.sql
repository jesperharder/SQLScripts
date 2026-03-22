/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesSalesOrder]
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

    
	 
	MERGE [dim].[SalesOrder] AS d
    USING (
			SELECT -1 AS [SalesOrderKey]
			, 'Unknown' AS [SalesOrderNumber]
			, 'Unknown' AS [SalesOrderStatus]
			, 'Unknown' AS [SalesPersonCode]
			, '1900-01-01' AS [RequestedDeliveryDateOrderHeader]
			, -1 AS [CompanyID]
			, 'Unknown' AS [SalesOrderHashKey]
			, 'Unknown' AS [AFD_DimensionSource]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [SalesOrderKey]
			, 'Blank' AS [SalesOrderNumber]
			, 'Blank' AS [SalesOrderStatus]
			, 'Blank' AS [SalesPersonCode]
			, '1900-01-01' AS [RequestedDeliveryDateOrderHeader]
			, -2 AS [CompanyID]
			, 'Blank' AS [SalesOrderHashKey]
			, 'Blank' AS [AFD_DimensionSource]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[SalesOrderKey] = d.[SalesOrderKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([SalesOrderKey]
	, [SalesOrderNumber]
	, [SalesOrderStatus]
	, [SalesPersonCode]
	, [RequestedDeliveryDateOrderHeader]
	, [CompanyID]
	, [SalesOrderHashKey]
	, [AFD_DimensionSource]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[SalesOrderKey]
		, s.[SalesOrderNumber]
		, s.[SalesOrderStatus]
		, s.[SalesPersonCode]
		, s.[RequestedDeliveryDateOrderHeader]
		, s.[CompanyID]
		, s.[SalesOrderHashKey]
		, s.[AFD_DimensionSource]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[SalesOrderNumber] = s.[SalesOrderNumber]
		, d.[SalesOrderStatus] = s.[SalesOrderStatus]
		, d.[SalesPersonCode] = s.[SalesPersonCode]
		, d.[RequestedDeliveryDateOrderHeader] = s.[RequestedDeliveryDateOrderHeader]
		, d.[CompanyID] = s.[CompanyID]
		, d.[SalesOrderHashKey] = s.[SalesOrderHashKey]
		, d.[AFD_DimensionSource] = s.[AFD_DimensionSource]
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

