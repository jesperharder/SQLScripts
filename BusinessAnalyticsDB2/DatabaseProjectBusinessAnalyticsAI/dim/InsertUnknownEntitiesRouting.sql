/* This file was generated automatically by a T4 Template */

CREATE   PROCEDURE [dim].[InsertUnknownEntitiesRouting]
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

    
	 
	MERGE [dim].[Routing] AS d
    USING (
			SELECT -1 AS [RoutingKey]
			, -1 AS [RoutingCompanyID]
			, 'Unknown' AS [RoutingNumber]
			, 'Unknown' AS [RoutingName]
			, 'Unknown' AS [RoutingNumberName]
			, 'Unknown' AS [RoutingStatus]
			, 'Unknown' AS [RoutingType]
			, 'Unknown' AS [RoutingHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [RoutingKey]
			, -2 AS [RoutingCompanyID]
			, 'Blank' AS [RoutingNumber]
			, 'Blank' AS [RoutingName]
			, 'Blank' AS [RoutingNumberName]
			, 'Blank' AS [RoutingStatus]
			, 'Blank' AS [RoutingType]
			, 'Blank' AS [RoutingHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[RoutingKey] = d.[RoutingKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([RoutingKey]
	, [RoutingCompanyID]
	, [RoutingNumber]
	, [RoutingName]
	, [RoutingNumberName]
	, [RoutingStatus]
	, [RoutingType]
	, [RoutingHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[RoutingKey]
		, s.[RoutingCompanyID]
		, s.[RoutingNumber]
		, s.[RoutingName]
		, s.[RoutingNumberName]
		, s.[RoutingStatus]
		, s.[RoutingType]
		, s.[RoutingHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[RoutingCompanyID] = s.[RoutingCompanyID]
		, d.[RoutingNumber] = s.[RoutingNumber]
		, d.[RoutingName] = s.[RoutingName]
		, d.[RoutingNumberName] = s.[RoutingNumberName]
		, d.[RoutingStatus] = s.[RoutingStatus]
		, d.[RoutingType] = s.[RoutingType]
		, d.[RoutingHashKey] = s.[RoutingHashKey]
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

