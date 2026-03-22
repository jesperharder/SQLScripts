/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim_v1].[InsertUnknownEntitiesCountry]
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

    
	 
	MERGE [dim_v1].[Country] AS d
    USING (
			SELECT -1 AS [CountryKey]
			, 'Unknown' AS [CountryCode]
			, 'Unknown' AS [CountryName]
			, 'Unknown' AS [CountryCodeName]
			, 'Unknown' AS [CountryHashKey]
			, 'Unknown' AS [Dimension Code]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [CountryKey]
			, 'Blank' AS [CountryCode]
			, 'Blank' AS [CountryName]
			, 'Blank' AS [CountryCodeName]
			, 'Blank' AS [CountryHashKey]
			, 'Blank' AS [Dimension Code]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[CountryKey] = d.[CountryKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([CountryKey]
	, [CountryCode]
	, [CountryName]
	, [CountryCodeName]
	, [CountryHashKey]
	, [Dimension Code]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[CountryKey]
		, s.[CountryCode]
		, s.[CountryName]
		, s.[CountryCodeName]
		, s.[CountryHashKey]
		, s.[Dimension Code]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CountryCode] = s.[CountryCode]
		, d.[CountryName] = s.[CountryName]
		, d.[CountryCodeName] = s.[CountryCodeName]
		, d.[CountryHashKey] = s.[CountryHashKey]
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

