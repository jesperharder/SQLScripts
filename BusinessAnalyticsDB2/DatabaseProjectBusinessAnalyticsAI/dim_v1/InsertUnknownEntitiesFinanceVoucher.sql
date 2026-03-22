/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesFinanceVoucher]
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

    
	 
	MERGE [dim_v1].[FinanceVoucher] AS d
    USING (
			SELECT -1 AS [FinanceVoucherKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [FinanceVoucherNumber]
			, 'Unknown' AS [FinanceVoucherType]
			, 'Unknown' AS [FinanceVoucherSourceCode]
			, '1900-01-01' AS [FinanceVoucherPostingDate]
			, 'Unknown' AS [FinanceVoucherIsClosingDate]
			, 'Unknown' AS [FinanceVoucherHashKey]
			, 0x AS [ADF_LastTimestamp]
			, 'Unknown' AS [ADF_DimensionSource]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [FinanceVoucherKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [FinanceVoucherNumber]
			, 'Blank' AS [FinanceVoucherType]
			, 'Blank' AS [FinanceVoucherSourceCode]
			, '1900-01-01' AS [FinanceVoucherPostingDate]
			, 'Blank' AS [FinanceVoucherIsClosingDate]
			, 'Blank' AS [FinanceVoucherHashKey]
			, 0x AS [ADF_LastTimestamp]
			, 'Blank' AS [ADF_DimensionSource]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[FinanceVoucherKey] = d.[FinanceVoucherKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([FinanceVoucherKey]
	, [CompanyID]
	, [FinanceVoucherNumber]
	, [FinanceVoucherType]
	, [FinanceVoucherSourceCode]
	, [FinanceVoucherPostingDate]
	, [FinanceVoucherIsClosingDate]
	, [FinanceVoucherHashKey]
	, [ADF_LastTimestamp]
	, [ADF_DimensionSource]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[FinanceVoucherKey]
		, s.[CompanyID]
		, s.[FinanceVoucherNumber]
		, s.[FinanceVoucherType]
		, s.[FinanceVoucherSourceCode]
		, s.[FinanceVoucherPostingDate]
		, s.[FinanceVoucherIsClosingDate]
		, s.[FinanceVoucherHashKey]
		, s.[ADF_LastTimestamp]
		, s.[ADF_DimensionSource]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[FinanceVoucherNumber] = s.[FinanceVoucherNumber]
		, d.[FinanceVoucherType] = s.[FinanceVoucherType]
		, d.[FinanceVoucherSourceCode] = s.[FinanceVoucherSourceCode]
		, d.[FinanceVoucherPostingDate] = s.[FinanceVoucherPostingDate]
		, d.[FinanceVoucherIsClosingDate] = s.[FinanceVoucherIsClosingDate]
		, d.[FinanceVoucherHashKey] = s.[FinanceVoucherHashKey]
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

