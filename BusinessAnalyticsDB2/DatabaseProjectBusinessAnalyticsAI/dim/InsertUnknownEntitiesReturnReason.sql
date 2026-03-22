/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesReturnReason]
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

    
	 
	MERGE [dim].[ReturnReason] AS d
    USING (
			SELECT -1 AS [ReturnReasonKey]
			, -1 AS [ReturnReasonCompanyID]
			, 'Unknown' AS [ReturnReasonCode]
			, 'Unknown' AS [ReturnReasonName]
			, 'Unknown' AS [ReturnReasonCodeName]
			, 'Unknown' AS [ReturnReasonHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [ReturnReasonKey]
			, -2 AS [ReturnReasonCompanyID]
			, 'Blank' AS [ReturnReasonCode]
			, 'Blank' AS [ReturnReasonName]
			, 'Blank' AS [ReturnReasonCodeName]
			, 'Blank' AS [ReturnReasonHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[ReturnReasonKey] = d.[ReturnReasonKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([ReturnReasonKey]
	, [ReturnReasonCompanyID]
	, [ReturnReasonCode]
	, [ReturnReasonName]
	, [ReturnReasonCodeName]
	, [ReturnReasonHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[ReturnReasonKey]
		, s.[ReturnReasonCompanyID]
		, s.[ReturnReasonCode]
		, s.[ReturnReasonName]
		, s.[ReturnReasonCodeName]
		, s.[ReturnReasonHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[ReturnReasonCompanyID] = s.[ReturnReasonCompanyID]
		, d.[ReturnReasonCode] = s.[ReturnReasonCode]
		, d.[ReturnReasonName] = s.[ReturnReasonName]
		, d.[ReturnReasonCodeName] = s.[ReturnReasonCodeName]
		, d.[ReturnReasonHashKey] = s.[ReturnReasonHashKey]
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

