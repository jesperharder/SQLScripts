/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesInventoryMovementDocument]
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

    
	 
	MERGE [dim_v1].[InventoryMovementDocument] AS d
    USING (
			SELECT -1 AS [InventoryMovementDocumentKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [InventoryMovementDocumentNumber]
			, 'Unknown' AS [InventoryMovementCause]
			, 'Unknown' AS [ItemLedgerEntryType]
			, '1900-01-01' AS [InventoryPostingDate]
			, 'Unknown' AS [InventoryUserId]
			, 'Unknown' AS [InventoryNoSeries]
			, 'Unknown' AS [InventoryMovementDocumentHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [InventoryMovementDocumentKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [InventoryMovementDocumentNumber]
			, 'Blank' AS [InventoryMovementCause]
			, 'Blank' AS [ItemLedgerEntryType]
			, '1900-01-01' AS [InventoryPostingDate]
			, 'Blank' AS [InventoryUserId]
			, 'Blank' AS [InventoryNoSeries]
			, 'Blank' AS [InventoryMovementDocumentHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[InventoryMovementDocumentKey] = d.[InventoryMovementDocumentKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([InventoryMovementDocumentKey]
	, [CompanyID]
	, [InventoryMovementDocumentNumber]
	, [InventoryMovementCause]
	, [ItemLedgerEntryType]
	, [InventoryPostingDate]
	, [InventoryUserId]
	, [InventoryNoSeries]
	, [InventoryMovementDocumentHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[InventoryMovementDocumentKey]
		, s.[CompanyID]
		, s.[InventoryMovementDocumentNumber]
		, s.[InventoryMovementCause]
		, s.[ItemLedgerEntryType]
		, s.[InventoryPostingDate]
		, s.[InventoryUserId]
		, s.[InventoryNoSeries]
		, s.[InventoryMovementDocumentHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[InventoryMovementDocumentNumber] = s.[InventoryMovementDocumentNumber]
		, d.[InventoryMovementCause] = s.[InventoryMovementCause]
		, d.[ItemLedgerEntryType] = s.[ItemLedgerEntryType]
		, d.[InventoryPostingDate] = s.[InventoryPostingDate]
		, d.[InventoryUserId] = s.[InventoryUserId]
		, d.[InventoryNoSeries] = s.[InventoryNoSeries]
		, d.[InventoryMovementDocumentHashKey] = s.[InventoryMovementDocumentHashKey]
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

