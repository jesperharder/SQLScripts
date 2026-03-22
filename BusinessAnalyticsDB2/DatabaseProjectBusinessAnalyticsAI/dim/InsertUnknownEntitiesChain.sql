/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesChain]
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

    
	 
	MERGE [dim].[Chain] AS d
    USING (
			SELECT -1 AS [ChainKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [ChainGroupCode]
			, 'Unknown' AS [ChainGroupName]
			, 'Unknown' AS [ChainGroupCodeName]
			, 'Unknown' AS [ChainCode]
			, 'Unknown' AS [ChainName]
			, 'Unknown' AS [ChainCodeName]
			, 'Unknown' AS [ChainHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [ChainKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [ChainGroupCode]
			, 'Blank' AS [ChainGroupName]
			, 'Blank' AS [ChainGroupCodeName]
			, 'Blank' AS [ChainCode]
			, 'Blank' AS [ChainName]
			, 'Blank' AS [ChainCodeName]
			, 'Blank' AS [ChainHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[ChainKey] = d.[ChainKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([ChainKey]
	, [CompanyID]
	, [ChainGroupCode]
	, [ChainGroupName]
	, [ChainGroupCodeName]
	, [ChainCode]
	, [ChainName]
	, [ChainCodeName]
	, [ChainHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[ChainKey]
		, s.[CompanyID]
		, s.[ChainGroupCode]
		, s.[ChainGroupName]
		, s.[ChainGroupCodeName]
		, s.[ChainCode]
		, s.[ChainName]
		, s.[ChainCodeName]
		, s.[ChainHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[ChainGroupCode] = s.[ChainGroupCode]
		, d.[ChainGroupName] = s.[ChainGroupName]
		, d.[ChainGroupCodeName] = s.[ChainGroupCodeName]
		, d.[ChainCode] = s.[ChainCode]
		, d.[ChainName] = s.[ChainName]
		, d.[ChainCodeName] = s.[ChainCodeName]
		, d.[ChainHashKey] = s.[ChainHashKey]
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

