/* This file was generated automatically by a T4 Template */

CREATE PROCEDURE [dim].[InsertUnknownEntitiesGeography]
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

   
	 
	MERGE [dim].[Geography] AS d
    USING (
			SELECT -1 AS [GeographyKey]
			, 'Unknown' AS [CountryCode]
			, 'Unknown' AS [CountryName]
			, 'Unknown' AS [GeographyRegion]
			, 'Unknown' AS [GeographySubRegion]
			, 'Unknown' AS [GeographyIntermediateRegion]
			, 'Unknown' AS [GeographyLevel0]
			, 'Unknown' AS [GeographyLevel1]
			, 'Unknown' AS [GeographyLevel2]
			, 'Unknown' AS [GeographyLevel3]
			, 'Unknown' AS [GeographyLevel4]
            , 'Unknown' AS [GeographyHashKey]

			, -1 AS	[MarketType]
			, 'Unknown' AS [MarketTypeText] 
			, -1 AS [ChannelType] 
			, 'Unknown' AS [ChannelTypeText] 
			, 'Unknown' AS [SalesMarket]
			, 'Unknown' AS [SalesMarketCountryName] 
            , -1 AS [CompanyID]

			, 0x AS [ADF_LastTimestamp]
			, 'Unknown' AS [ADF_DimensionSource]
			, -1 AS [ADF_BatchId_Insert]
			, -1 AS [ADF_BatchId_Update]

			UNION ALL

			SELECT -2 AS [GeographyKey]
			, 'Blank' AS [CountryCode]
			, 'Blank' AS [CountryName]
			, 'Blank' AS [GeographyRegion]
			, 'Blank' AS [GeographySubRegion]
			, 'Blank' AS [GeographyIntermediateRegion]
			, 'Blank' AS [GeographyLevel0]
			, 'Blank' AS [GeographyLevel1]
			, 'Blank' AS [GeographyLevel2]
			, 'Blank' AS [GeographyLevel3]
			, 'Blank' AS [GeographyLevel4]
			, 'Blank' AS [GeographyHashKey]

			, -2 AS	[MarketType]
			, 'Blank' AS [MarketTypeText] 
			, -2 AS [ChannelType] 
			, 'Blank' AS [ChannelTypeText] 
			, 'Blank' AS [SalesMarket]
			, 'Blank' AS [SalesMarketCountryName] 
			, -2 AS [CompanyID]

			, 0x AS [ADF_LastTimestamp]
			, 'Blank' AS [ADF_DimensionSource]
			, -2 AS [ADF_BatchId_Insert]
			, -2 AS [ADF_BatchId_Update]

		  ) s
	ON s.[GeographyKey] = d.[GeographyKey]
	
	WHEN NOT MATCHED THEN -- Insert new records
    INSERT ([GeographyKey]
	, [CountryCode]
	, [CountryName]
	, [GeographyRegion]
	, [GeographySubRegion]
	, [GeographyIntermediateRegion]
	, [GeographyLevel0]
	, [GeographyLevel1]
	, [GeographyLevel2]
	, [GeographyLevel3]
	, [GeographyLevel4]
	, [GeographyHashKey]

	, [MarketType]
	, [MarketTypeText] 
	, [ChannelType] 
	, [ChannelTypeText] 
	, [SalesMarket]
	, [SalesMarketCountryName] 
	, [CompanyID]

	, [ADF_LastTimestamp]
	, [ADF_DimensionSource]
	, [ADF_BatchId_Insert]
	, [ADF_BatchId_Update]
	
	)
    VALUES (s.[GeographyKey]
		, s.[CountryCode]
		, s.[CountryName]
		, s.[GeographyRegion]
		, s.[GeographySubRegion]
		, s.[GeographyIntermediateRegion]
		, s.[GeographyLevel0]
		, s.[GeographyLevel1]
		, s.[GeographyLevel2]
		, s.[GeographyLevel3]
		, s.[GeographyLevel4]
		, s.[GeographyHashKey]
		
		, s.[MarketType]
		, s.[MarketTypeText] 
		, s.[ChannelType] 
		, s.[ChannelTypeText] 
		, s.[SalesMarket]
		, s.[SalesMarketCountryName] 
		, s.[CompanyID]

		, s.[ADF_LastTimestamp]
		, s.[ADF_DimensionSource]
		, s.[ADF_BatchId_Insert]
		, s.[ADF_BatchId_Update]
		)
	WHEN MATCHED
	THEN      						  -- update record with update flag
        UPDATE SET
		d.[CountryCode] = s.[CountryCode]
		, d.[CountryName] = s.[CountryName]
		, d.[GeographyRegion] = s.[GeographyRegion]
		, d.[GeographySubRegion] = s.[GeographySubRegion]
		, d.[GeographyIntermediateRegion] = s.[GeographyIntermediateRegion]
		, d.[GeographyLevel0] = s.[GeographyLevel0]
		, d.[GeographyLevel1] = s.[GeographyLevel1]
		, d.[GeographyLevel2] = s.[GeographyLevel2]
		, d.[GeographyLevel3] = s.[GeographyLevel3]
		, d.[GeographyLevel4] = s.[GeographyLevel4]
		, d.[GeographyHashKey] = s.[GeographyHashKey]

		, d.[MarketType] = s.[MarketType] 
		, d.[MarketTypeText]  = s.[MarketTypeText] 
		, d.[ChannelType] = s.[ChannelType] 
		, d.[ChannelTypeText] = s.[ChannelTypeText]
		, d.[SalesMarket] = s.[SalesMarket]
		, d.[SalesMarketCountryName] = s.[SalesMarketCountryName]
		, d.[CompanyID] = s.[CompanyID]

		, d.[ADF_LastTimestamp] = s.[ADF_LastTimestamp]
		, d.[ADF_DimensionSource] = s.[ADF_DimensionSource]
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

