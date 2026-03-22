/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesVendor]
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

    
	 
	MERGE [dim].[Vendor] AS d
    USING (
			SELECT -1 AS [VendorKey]
			, -1 AS [CompanyID]
			, 'Unknown' AS [VendorNumber]
			, 'Unknown' AS [VendorName]
			, 'Unknown' AS [VendorCountry]
			, 'Unknown' AS [VendorNumberName]
			, 'Unknown' AS [VendorCompanyPublicRegNumber]
			, 'Unknown' AS [VendorHashKey]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]
			
			UNION ALL

			SELECT -2 AS [VendorKey]
			, -2 AS [CompanyID]
			, 'Blank' AS [VendorNumber]
			, 'Blank' AS [VendorName]
			, 'Blank' AS [VendorCountry]
			, 'Blank' AS [VendorNumberName]
			, 'Blank' AS [VendorCompanyPublicRegNumber]
			, 'Blank' AS [VendorHashKey]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]
			
		  ) s
	ON s.[VendorKey] = d.[VendorKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([VendorKey]
	, [CompanyID]
	, [VendorNumber]
	, [VendorName]
	, [VendorCountry]
	, [VendorNumberName]
	, [VendorCompanyPublicRegNumber]
	, [VendorHashKey]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[VendorKey]
		, s.[CompanyID]
		, s.[VendorNumber]
		, s.[VendorName]
		, s.[VendorCountry]
		, s.[VendorNumberName]
		, s.[VendorCompanyPublicRegNumber]
		, s.[VendorHashKey]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CompanyID] = s.[CompanyID]
		, d.[VendorNumber] = s.[VendorNumber]
		, d.[VendorName] = s.[VendorName]
		, d.[VendorCountry] = s.[VendorCountry]
		, d.[VendorNumberName] = s.[VendorNumberName]
		, d.[VendorCompanyPublicRegNumber] = s.[VendorCompanyPublicRegNumber]
		, d.[VendorHashKey] = s.[VendorHashKey]
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

