/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesDepartment]
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

    
	 
	MERGE [dim_v1].[Department] AS d
    USING (
			SELECT -1 AS [DepartmentKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [DepartmentCode]
			, 'Unknown' AS [DepartmentName]
			, 'Unknown' AS [DepartmentCodeName]
			, 'Unknown' AS [DepartmentHashKey]
			, 'Unknown' AS [Dimension Code]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [DepartmentKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [DepartmentCode]
			, 'Blank' AS [DepartmentName]
			, 'Blank' AS [DepartmentCodeName]
			, 'Blank' AS [DepartmentHashKey]
			, 'Blank' AS [Dimension Code]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[DepartmentKey] = d.[DepartmentKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([DepartmentKey]
	, [CompanyID]
	, [DepartmentCode]
	, [DepartmentName]
	, [DepartmentCodeName]
	, [DepartmentHashKey]
	, [Dimension Code]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[DepartmentKey]
		, s.[CompanyID]
		, s.[DepartmentCode]
		, s.[DepartmentName]
		, s.[DepartmentCodeName]
		, s.[DepartmentHashKey]
		, s.[Dimension Code]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[DepartmentCode] = s.[DepartmentCode]
		, d.[DepartmentName] = s.[DepartmentName]
		, d.[DepartmentCodeName] = s.[DepartmentCodeName]
		, d.[DepartmentHashKey] = s.[DepartmentHashKey]
		, d.[Dimension Code] = s.[Dimension Code]
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

