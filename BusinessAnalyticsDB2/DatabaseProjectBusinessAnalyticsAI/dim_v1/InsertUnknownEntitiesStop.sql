/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesStop]
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

    
	 
	MERGE [dim_v1].[Stop] AS d
    USING (
			SELECT -1 AS [StopKey]
			, -1 AS [StopCompanyID]
			, 'Unknown' AS [StopCode]
			, 'Unknown' AS [StopName]
			, 'Unknown' AS [StopCodeName]
			, 'Unknown' AS [StopHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [StopKey]
			, -2 AS [StopCompanyID]
			, 'Blank' AS [StopCode]
			, 'Blank' AS [StopName]
			, 'Blank' AS [StopCodeName]
			, 'Blank' AS [StopHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[StopKey] = d.[StopKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([StopKey]
	, [StopCompanyID]
	, [StopCode]
	, [StopName]
	, [StopCodeName]
	, [StopHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[StopKey]
		, s.[StopCompanyID]
		, s.[StopCode]
		, s.[StopName]
		, s.[StopCodeName]
		, s.[StopHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[StopCompanyID] = s.[StopCompanyID]
		, d.[StopCode] = s.[StopCode]
		, d.[StopName] = s.[StopName]
		, d.[StopCodeName] = s.[StopCodeName]
		, d.[StopHashKey] = s.[StopHashKey]
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

