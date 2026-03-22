/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesWorkcenter]
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

    
	 
	MERGE [dim].[Workcenter] AS d
    USING (
			SELECT -1 AS [WorkcenterKey]
			, -1 AS [WorkcenterCompanyID]
			, 'Unknown' AS [WorkcenterNumber]
			, 'Unknown' AS [WorkcenterName]
			, 'Unknown' AS [WorkcenterNumberName]
			, 'Unknown' AS [WorkcenterGroup]
			, 'Unknown' AS [WorkcenterDepartment]
			, 'Unknown' AS [WorkcenterSubContractor]
			, 'Unknown' AS [UnitOfMeasureCode]
			, 'Unknown' AS [IsWorkcenterBlocked]
			, 'Unknown' AS [WorkcenterLocation]
			, 'Unknown' AS [WorkcenterHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [WorkcenterKey]
			, -2 AS [WorkcenterCompanyID]
			, 'Blank' AS [WorkcenterNumber]
			, 'Blank' AS [WorkcenterName]
			, 'Blank' AS [WorkcenterNumberName]
			, 'Blank' AS [WorkcenterGroup]
			, 'Blank' AS [WorkcenterDepartment]
			, 'Blank' AS [WorkcenterSubContractor]
			, 'Blank' AS [UnitOfMeasureCode]
			, 'Blank' AS [IsWorkcenterBlocked]
			, 'Blank' AS [WorkcenterLocation]
			, 'Blank' AS [WorkcenterHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[WorkcenterKey] = d.[WorkcenterKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([WorkcenterKey]
	, [WorkcenterCompanyID]
	, [WorkcenterNumber]
	, [WorkcenterName]
	, [WorkcenterNumberName]
	, [WorkcenterGroup]
	, [WorkcenterDepartment]
	, [WorkcenterSubContractor]
	, [UnitOfMeasureCode]
	, [IsWorkcenterBlocked]
	, [WorkcenterLocation]
	, [WorkcenterHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[WorkcenterKey]
		, s.[WorkcenterCompanyID]
		, s.[WorkcenterNumber]
		, s.[WorkcenterName]
		, s.[WorkcenterNumberName]
		, s.[WorkcenterGroup]
		, s.[WorkcenterDepartment]
		, s.[WorkcenterSubContractor]
		, s.[UnitOfMeasureCode]
		, s.[IsWorkcenterBlocked]
		, s.[WorkcenterLocation]
		, s.[WorkcenterHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[WorkcenterCompanyID] = s.[WorkcenterCompanyID]
		, d.[WorkcenterNumber] = s.[WorkcenterNumber]
		, d.[WorkcenterName] = s.[WorkcenterName]
		, d.[WorkcenterNumberName] = s.[WorkcenterNumberName]
		, d.[WorkcenterGroup] = s.[WorkcenterGroup]
		, d.[WorkcenterDepartment] = s.[WorkcenterDepartment]
		, d.[WorkcenterSubContractor] = s.[WorkcenterSubContractor]
		, d.[UnitOfMeasureCode] = s.[UnitOfMeasureCode]
		, d.[IsWorkcenterBlocked] = s.[IsWorkcenterBlocked]
		, d.[WorkcenterLocation] = s.[WorkcenterLocation]
		, d.[WorkcenterHashKey] = s.[WorkcenterHashKey]
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

