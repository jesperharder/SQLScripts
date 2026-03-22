/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesPurchaseDocument]
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

    
	 
	MERGE [dim_v1].[PurchaseDocument] AS d
    USING (
			SELECT -1 AS [PurchaseDocumentKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [PurchaseDocumentNumber]
			, -1 AS [PurchaseDocumentLineNumber]
			, 'Unknown' AS [PurchaseDocumentType]
			, 'Unknown' AS [PurchaseDocumentLineType]
			, 'Unknown' AS [PurchaseOrderNumber]
			, 'Unknown' AS [ResponsiblePurchaserCode]
			, 'Unknown' AS [CurrencyCode]
			, '1900-01-01' AS [PurchaseOrderCreatedDate]
			, 'Unknown' AS [IsCompletelyReceived]
			, 'Unknown' AS [IsDropShipment]
			, 'Unknown' AS [SalesOrderNumber]
			, '1900-01-01' AS [ExpectedReceiptDate]
			, '1900-01-01' AS [RequestedReceiptDate]
			, '1900-01-01' AS [PromisedReceiptDate]
			, '1900-01-01' AS [PlannedReceiptDate]
			, '1900-01-01' AS [OrderDate]
			, 'Unknown' AS [PurchaseDocumentHashKey]
			, 0x AS [ADF_LastTimestamp]
			, 'Unknown' AS [ADF_DimensionSource]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [PurchaseDocumentKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [PurchaseDocumentNumber]
			, -2 AS [PurchaseDocumentLineNumber]
			, 'Blank' AS [PurchaseDocumentType]
			, 'Blank' AS [PurchaseDocumentLineType]
			, 'Blank' AS [PurchaseOrderNumber]
			, 'Blank' AS [ResponsiblePurchaserCode]
			, 'Blank' AS [CurrencyCode]
			, '1900-01-01' AS [PurchaseOrderCreatedDate]
			, 'Blank' AS [IsCompletelyReceived]
			, 'Blank' AS [IsDropShipment]
			, 'Blank' AS [SalesOrderNumber]
			, '1900-01-01' AS [ExpectedReceiptDate]
			, '1900-01-01' AS [RequestedReceiptDate]
			, '1900-01-01' AS [PromisedReceiptDate]
			, '1900-01-01' AS [PlannedReceiptDate]
			, '1900-01-01' AS [OrderDate]
			, 'Blank' AS [PurchaseDocumentHashKey]
			, 0x AS [ADF_LastTimestamp]
			, 'Blank' AS [ADF_DimensionSource]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[PurchaseDocumentKey] = d.[PurchaseDocumentKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([PurchaseDocumentKey]
	, [CompanyID]
	, [PurchaseDocumentNumber]
	, [PurchaseDocumentLineNumber]
	, [PurchaseDocumentType]
	, [PurchaseDocumentLineType]
	, [PurchaseOrderNumber]
	, [ResponsiblePurchaserCode]
	, [CurrencyCode]
	, [PurchaseOrderCreatedDate]
	, [IsCompletelyReceived]
	, [IsDropShipment]
	, [SalesOrderNumber]
	, [ExpectedReceiptDate]
	, [RequestedReceiptDate]
	, [PromisedReceiptDate]
	, [PlannedReceiptDate]
	, [OrderDate]
	, [PurchaseDocumentHashKey]
	, [ADF_LastTimestamp]
	, [ADF_DimensionSource]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[PurchaseDocumentKey]
		, s.[CompanyID]
		, s.[PurchaseDocumentNumber]
		, s.[PurchaseDocumentLineNumber]
		, s.[PurchaseDocumentType]
		, s.[PurchaseDocumentLineType]
		, s.[PurchaseOrderNumber]
		, s.[ResponsiblePurchaserCode]
		, s.[CurrencyCode]
		, s.[PurchaseOrderCreatedDate]
		, s.[IsCompletelyReceived]
		, s.[IsDropShipment]
		, s.[SalesOrderNumber]
		, s.[ExpectedReceiptDate]
		, s.[RequestedReceiptDate]
		, s.[PromisedReceiptDate]
		, s.[PlannedReceiptDate]
		, s.[OrderDate]
		, s.[PurchaseDocumentHashKey]
		, s.[ADF_LastTimestamp]
		, s.[ADF_DimensionSource]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[PurchaseDocumentNumber] = s.[PurchaseDocumentNumber]
		, d.[PurchaseDocumentLineNumber] = s.[PurchaseDocumentLineNumber]
		, d.[PurchaseDocumentType] = s.[PurchaseDocumentType]
		, d.[PurchaseDocumentLineType] = s.[PurchaseDocumentLineType]
		, d.[PurchaseOrderNumber] = s.[PurchaseOrderNumber]
		, d.[ResponsiblePurchaserCode] = s.[ResponsiblePurchaserCode]
		, d.[CurrencyCode] = s.[CurrencyCode]
		, d.[PurchaseOrderCreatedDate] = s.[PurchaseOrderCreatedDate]
		, d.[IsCompletelyReceived] = s.[IsCompletelyReceived]
		, d.[IsDropShipment] = s.[IsDropShipment]
		, d.[SalesOrderNumber] = s.[SalesOrderNumber]
		, d.[ExpectedReceiptDate] = s.[ExpectedReceiptDate]
		, d.[RequestedReceiptDate] = s.[RequestedReceiptDate]
		, d.[PromisedReceiptDate] = s.[PromisedReceiptDate]
		, d.[PlannedReceiptDate] = s.[PlannedReceiptDate]
		, d.[OrderDate] = s.[OrderDate]
		, d.[PurchaseDocumentHashKey] = s.[PurchaseDocumentHashKey]
		, d.[ADF_LastTimestamp] = s.[ADF_LastTimestamp]
		, d.[ADF_DimensionSource] = s.[ADF_DimensionSource]
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

