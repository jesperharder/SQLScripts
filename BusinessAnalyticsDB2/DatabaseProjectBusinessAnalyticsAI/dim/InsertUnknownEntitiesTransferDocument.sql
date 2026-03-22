/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesTransferDocument]
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

    
	 
	MERGE [dim].[TransferDocument] AS d
    USING (
			SELECT -1 AS [TransferDocumentKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [TransferDocumentNumber]
			, -1 AS [TransferDocumentLineNumber]
			, 'Unknown' AS [IsCompletelyReceived]
			, 'Unknown' AS [TransferStatus]
			, '1900-01-01' AS [ReceiptDate]
			, '1900-01-01' AS [ShipmentDate]
			, 'Unknown' AS [TransferDocumentHashKey]
			, 0x AS [ADF_LastTimestamp]
			, 'Unknown' AS [ADF_DimensionSource]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [TransferDocumentKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [TransferDocumentNumber]
			, -2 AS [TransferDocumentLineNumber]
			, 'Blank' AS [IsCompletelyReceived]
			, 'Blank' AS [TransferStatus]
			, '1900-01-01' AS [ReceiptDate]
			, '1900-01-01' AS [ShipmentDate]
			, 'Blank' AS [TransferDocumentHashKey]
			, 0x AS [ADF_LastTimestamp]
			, 'Blank' AS [ADF_DimensionSource]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[TransferDocumentKey] = d.[TransferDocumentKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([TransferDocumentKey]
	, [CompanyID]
	, [TransferDocumentNumber]
	, [TransferDocumentLineNumber]
	, [IsCompletelyReceived]
	, [TransferStatus]
	, [ReceiptDate]
	, [ShipmentDate]
	, [TransferDocumentHashKey]
	, [ADF_LastTimestamp]
	, [ADF_DimensionSource]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[TransferDocumentKey]
		, s.[CompanyID]
		, s.[TransferDocumentNumber]
		, s.[TransferDocumentLineNumber]
		, s.[IsCompletelyReceived]
		, s.[TransferStatus]
		, s.[ReceiptDate]
		, s.[ShipmentDate]
		, s.[TransferDocumentHashKey]
		, s.[ADF_LastTimestamp]
		, s.[ADF_DimensionSource]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[TransferDocumentNumber] = s.[TransferDocumentNumber]
		, d.[TransferDocumentLineNumber] = s.[TransferDocumentLineNumber]
		, d.[IsCompletelyReceived] = s.[IsCompletelyReceived]
		, d.[TransferStatus] = s.[TransferStatus]
		, d.[ReceiptDate] = s.[ReceiptDate]
		, d.[ShipmentDate] = s.[ShipmentDate]
		, d.[TransferDocumentHashKey] = s.[TransferDocumentHashKey]
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

