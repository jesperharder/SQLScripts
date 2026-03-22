/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesTeam]
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

    
	 
	MERGE [dim_v1].[Team] AS d
    USING (
			SELECT -1 AS [TeamKey]
			, 'Unknown' AS [TeamCode]
			, 'Unknown' AS [TeamName]
			, 'Unknown' AS [TeamCodeName]
			, 'Unknown' AS [TeamPersonCode]
			, 'Unknown' AS [TeamPersonName]
			, 'Unknown' AS [TeamPersonCodeName]
			, -1 AS [TeamCompanyID]
			, 'Unknown' AS [TeamHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [TeamKey]
			, 'Blank' AS [TeamCode]
			, 'Blank' AS [TeamName]
			, 'Blank' AS [TeamCodeName]
			, 'Blank' AS [TeamPersonCode]
			, 'Blank' AS [TeamPersonName]
			, 'Blank' AS [TeamPersonCodeName]
			, -2 AS [TeamCompanyID]
			, 'Blank' AS [TeamHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[TeamKey] = d.[TeamKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([TeamKey]
	, [TeamCode]
	, [TeamName]
	, [TeamCodeName]
	, [TeamPersonCode]
	, [TeamPersonName]
	, [TeamPersonCodeName]
	, [TeamCompanyID]
	, [TeamHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[TeamKey]
		, s.[TeamCode]
		, s.[TeamName]
		, s.[TeamCodeName]
		, s.[TeamPersonCode]
		, s.[TeamPersonName]
		, s.[TeamPersonCodeName]
		, s.[TeamCompanyID]
		, s.[TeamHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[TeamCode] = s.[TeamCode]
		, d.[TeamName] = s.[TeamName]
		, d.[TeamCodeName] = s.[TeamCodeName]
		, d.[TeamPersonCode] = s.[TeamPersonCode]
		, d.[TeamPersonName] = s.[TeamPersonName]
		, d.[TeamPersonCodeName] = s.[TeamPersonCodeName]
		, d.[TeamCompanyID] = s.[TeamCompanyID]
		, d.[TeamHashKey] = s.[TeamHashKey]
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

