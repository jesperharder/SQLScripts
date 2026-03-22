CREATE VIEW [etl_v1].[DimGeographySource]
AS

WITH [base] AS (
    SELECT [alpha_2] AS [CountryCode]
          ,[name] AS [CountryName]
          ,[region] AS [GeographyRegion]
          ,[sub_region] AS [GeographySubRegion]
          ,[intermediate_region] AS [GeographyIntermediateRegion]
          ,CAST(N'World' AS nvarchar(7)) AS [GeographyLevel0]
          ,COALESCE([region], [sub_region], [intermediate_region], [name]) AS [GeographyLevel1]
          ,COALESCE([sub_region], [intermediate_region], [name]) AS [GeographyLevel2]
          ,COALESCE([intermediate_region], [name]) AS [GeographyLevel3]
          ,[name] AS [GeographyLevel4]
    FROM [meta].[ISO-3166-Countries-with-Regional-Codes]
)
SELECT [e].[CompanyId] as [CompanyID]  -- Adding CompanyId from etl.Company 
      ,[b].[CountryCode]
      ,[b].[CountryName]
      ,[b].[GeographyRegion]
      ,[b].[GeographySubRegion]
      ,[b].[GeographyIntermediateRegion]
      ,[b].[GeographyLevel0] AS [GeographyLevel0]
      ,[b].[GeographyLevel1] AS [GeographyLevel1]
      ,IIF([b].[GeographyLevel2] = [b].[GeographyLevel1], NULL, [b].[GeographyLevel2]) AS [GeographyLevel2]
      ,IIF([b].[GeographyLevel3] = [b].[GeographyLevel2], NULL, [b].[GeographyLevel3]) AS [GeographyLevel3]
      ,IIF([b].[GeographyLevel4] = [b].[GeographyLevel3], NULL, [b].[GeographyLevel4]) AS [GeographyLevel4]
      ,NULLIF([bc].[marketTypes], N'') AS [MarketType]
      ,[bc].[marketTypes] AS [MarketTypeText]
      ,NULLIF([bc].[channelTypes], N'') AS [ChannelType]
      ,[bc].[channelTypes] AS [ChannelTypeText]
      ,NULLIF([bc].[SalesMarket], N'') AS [SalesMarket]
      ,[bc2].Name as [SalesMarketCountryName]
      ,N'0x' AS [ADF_LastTimestamp]
      ,CAST(N'ETL_DimGeography' AS nvarchar(128)) AS [ADF_DimensionSource]
FROM [base] AS [b]
CROSS JOIN [etl].[Company] AS [e]  -- Cross join to include all companies
LEFT JOIN [stg_bc_api].[CountryRegion] AS [bc]
    ON [b].[CountryCode] = [bc].[Code] 
    AND [bc].[CompanyId] = [e].[CompanyId]  -- Modify the join condition to include CompanyId
LEFT JOIN [stg_bc_api].[CountryRegion] AS [bc2]
    ON [bc].[SalesMarket] = [bc2].[Code]
    AND [bc].[CompanyId] = [bc2].[CompanyId]  -- Modify the join condition to include CompanyId

GO

