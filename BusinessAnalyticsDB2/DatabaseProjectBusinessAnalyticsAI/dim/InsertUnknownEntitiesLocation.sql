/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesLocation]
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

    
	 
	MERGE [dim].[Location] AS d
    USING (
			SELECT -1 AS [LocationKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [LocationCode]
			, 'Unknown' AS [LocationName]
			, 'Unknown' AS [LocationCodeName]
			, 'Unknown' AS [LocationCountry]
			, 'Unknown' AS [LocationHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [LocationKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [LocationCode]
			, 'Blank' AS [LocationName]
			, 'Blank' AS [LocationCodeName]
			, 'Blank' AS [LocationCountry]
			, 'Blank' AS [LocationHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[LocationKey] = d.[LocationKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([LocationKey]
	, [CompanyID]
	, [LocationCode]
	, [LocationName]
	, [LocationCodeName]
	, [LocationCountry]
	, [LocationHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[LocationKey]
		, s.[CompanyID]
		, s.[LocationCode]
		, s.[LocationName]
		, s.[LocationCodeName]
		, s.[LocationCountry]
		, s.[LocationHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[LocationCode] = s.[LocationCode]
		, d.[LocationName] = s.[LocationName]
		, d.[LocationCodeName] = s.[LocationCodeName]
		, d.[LocationCountry] = s.[LocationCountry]
		, d.[LocationHashKey] = s.[LocationHashKey]
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

