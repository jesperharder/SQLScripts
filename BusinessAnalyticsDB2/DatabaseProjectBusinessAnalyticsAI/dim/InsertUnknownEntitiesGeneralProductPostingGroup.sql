/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesGeneralProductPostingGroup]
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

    
	 
	MERGE [dim].[GeneralProductPostingGroup] AS d
    USING (
			SELECT -1 AS [GeneralProductPostingGroupKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [GeneralProductPostingGroupCode]
			, 'Unknown' AS [GeneralProductPostingGroupName]
			, 'Unknown' AS [GeneralProductPostingGroupCodeName]
			, 'Unknown' AS [GeneralProductPostingGroupHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [GeneralProductPostingGroupKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [GeneralProductPostingGroupCode]
			, 'Blank' AS [GeneralProductPostingGroupName]
			, 'Blank' AS [GeneralProductPostingGroupCodeName]
			, 'Blank' AS [GeneralProductPostingGroupHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[GeneralProductPostingGroupKey] = d.[GeneralProductPostingGroupKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([GeneralProductPostingGroupKey]
	, [CompanyID]
	, [GeneralProductPostingGroupCode]
	, [GeneralProductPostingGroupName]
	, [GeneralProductPostingGroupCodeName]
	, [GeneralProductPostingGroupHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[GeneralProductPostingGroupKey]
		, s.[CompanyID]
		, s.[GeneralProductPostingGroupCode]
		, s.[GeneralProductPostingGroupName]
		, s.[GeneralProductPostingGroupCodeName]
		, s.[GeneralProductPostingGroupHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[GeneralProductPostingGroupCode] = s.[GeneralProductPostingGroupCode]
		, d.[GeneralProductPostingGroupName] = s.[GeneralProductPostingGroupName]
		, d.[GeneralProductPostingGroupCodeName] = s.[GeneralProductPostingGroupCodeName]
		, d.[GeneralProductPostingGroupHashKey] = s.[GeneralProductPostingGroupHashKey]
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

