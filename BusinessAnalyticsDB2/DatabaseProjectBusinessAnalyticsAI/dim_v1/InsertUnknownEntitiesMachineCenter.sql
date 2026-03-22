/* This file was generated automatically by a T4 Template */

CREATE   PROCEDURE [dim_v1].[InsertUnknownEntitiesMachineCenter]
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

    
	 
	MERGE [dim_v1].[MachineCenter] AS d
    USING (
			SELECT -1 AS [MachineCenterKey]
			, -1 AS [MachineCenterCompanyID]
			, 'Unknown' AS [MachineCenterNumber]
			, 'Unknown' AS [MachineCenterName]
			, 'Unknown' AS [MachineCenterNumberName]
			, 'Unknown' AS [MachineCenterHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [MachineCenterKey]
			, -2 AS [MachineCenterCompanyID]
			, 'Blank' AS [MachineCenterNumber]
			, 'Blank' AS [MachineCenterName]
			, 'Blank' AS [MachineCenterNumberName]
			, 'Blank' AS [MachineCenterHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[MachineCenterKey] = d.[MachineCenterKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([MachineCenterKey]
	, [MachineCenterCompanyID]
	, [MachineCenterNumber]
	, [MachineCenterName]
	, [MachineCenterNumberName]
	, [MachineCenterHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[MachineCenterKey]
		, s.[MachineCenterCompanyID]
		, s.[MachineCenterNumber]
		, s.[MachineCenterName]
		, s.[MachineCenterNumberName]
		, s.[MachineCenterHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[MachineCenterCompanyID] = s.[MachineCenterCompanyID]
		, d.[MachineCenterNumber] = s.[MachineCenterNumber]
		, d.[MachineCenterName] = s.[MachineCenterName]
		, d.[MachineCenterNumberName] = s.[MachineCenterNumberName]
		, d.[MachineCenterHashKey] = s.[MachineCenterHashKey]
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

