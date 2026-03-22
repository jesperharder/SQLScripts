/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesMaintainance]
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

    
	 
	MERGE [dim].[Maintainance] AS d
    USING (
			SELECT -1 AS [MaintainanceKey]
			, 'Unknown' AS [MaintainanceCode]
			, 'Unknown' AS [MaintainanceName]
			, 'Unknown' AS [MaintainanceCodeName]
			, 'Unknown' AS [MaintainanceHashKey]
			, 'Unknown' AS [Dimension Code]
			, -1 AS [CompanyID]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [MaintainanceKey]
			, 'Blank' AS [MaintainanceCode]
			, 'Blank' AS [MaintainanceName]
			, 'Blank' AS [MaintainanceCodeName]
			, 'Blank' AS [MaintainanceHashKey]
			, 'Blank' AS [Dimension Code]
			, -2 AS [CompanyID]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[MaintainanceKey] = d.[MaintainanceKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([MaintainanceKey]
	, [MaintainanceCode]
	, [MaintainanceName]
	, [MaintainanceCodeName]
	, [MaintainanceHashKey]
	, [Dimension Code]
	, [CompanyID]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[MaintainanceKey]
		, s.[MaintainanceCode]
		, s.[MaintainanceName]
		, s.[MaintainanceCodeName]
		, s.[MaintainanceHashKey]
		, s.[Dimension Code]
		, s.[CompanyID]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[MaintainanceCode] = s.[MaintainanceCode]
		, d.[MaintainanceName] = s.[MaintainanceName]
		, d.[MaintainanceCodeName] = s.[MaintainanceCodeName]
		, d.[MaintainanceHashKey] = s.[MaintainanceHashKey]
		, d.[Dimension Code] = s.[Dimension Code]
		, d.[CompanyID] = s.[CompanyID]
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

