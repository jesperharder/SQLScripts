CREATE VIEW [etl].[DimGeographySource]
AS
/* Original <2024.05.31 TV code
WITH [base]
AS
(
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
SELECT [b].[CountryCode]
      ,[b].[CountryName]
      ,[b].[GeographyRegion]
      ,[b].[GeographySubRegion]
      ,[b].[GeographyIntermediateRegion]
      ,[b].[GeographyLevel0] AS [GeographyLevel0]
      ,[b].[GeographyLevel1] AS [GeographyLevel1]
      ,IIF([b].[GeographyLevel2] = [b].[GeographyLevel1], NULL, [b].[GeographyLevel2]) AS [GeographyLevel2]
      ,IIF([b].[GeographyLevel3] = [b].[GeographyLevel2], NULL, [b].[GeographyLevel3]) AS [GeographyLevel3]
      ,IIF([b].[GeographyLevel4] = [b].[GeographyLevel3], NULL, [b].[GeographyLevel4]) AS [GeographyLevel4]
      ,NULLIF([cr].[Market Type], N'') AS [MarketType]
      ,NULLIF([cr].[Channel Type], N'') AS [ChannelType]
      ,ISNULL([cr].[timestamp], 0x) AS [ADF_LastTimestamp]
      ,CAST(N'ETL_DimGeography' AS nvarchar(128)) AS [ADF_DimensionSource]
FROM [base] AS [b]
LEFT JOIN [stg_navdb].[CountryRegion] AS [cr]
ON  [cr].[ISO A2] = [b].[CountryCode]
AND [cr].[CompanyID] = 1
AND [cr].[ISO A2] <> [cr].[Name]
AND [cr].[ISO A2] = LEFT([cr].[ISO A3], 2);
*/

--2024.05.31JH      Changed code to include CompanyID, MarketType, ChannelType, SalesMarket
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
      ,NULLIF([bc].[Market Types], N'') AS [MarketType]
      ,CASE
        WHEN [bc].[Market Types] IS NULL THEN NULL
        WHEN [bc].[Market Types] = 0 THEN NULL
        WHEN [bc].[Market Types] = 1 THEN 'Focus'
        WHEN [bc].[Market Types] = 2 THEN 'Secondary'
        WHEN [bc].[Market Types] = 3 THEN 'Growth'
        ELSE 'Unknown' END AS [MarketTypeText]
      ,NULLIF([bc].[Channel Types], N'') AS [ChannelType]
      ,CASE 
        WHEN [bc].[Channel Types] IS NULL THEN NULL
        WHEN [bc].[Channel Types] = 0 THEN NULL
        WHEN [bc].[Channel Types] = 1 THEN 'Agent'
        WHEN [bc].[Channel Types] = 2 THEN 'Distributor'
        WHEN [bc].[Channel Types] = 3 THEN 'Own'
        ELSE 'Unknown' END AS [ChannelTypeText]

      ,NULLIF([bc].[SalesMarket], N'') AS [SalesMarket]
      ,[bc2].Name as [SalesMarketCountryName]
      ,ISNULL([bc].[timestamp], 0x) AS [ADF_LastTimestamp]
      ,CAST(N'ETL_DimGeography' AS nvarchar(128)) AS [ADF_DimensionSource]
FROM [base] AS [b]
CROSS JOIN [etl].[Company] AS [e]  -- Cross join to include all companies
LEFT JOIN [stg_bc].[CountryRegion] AS [bc]
    ON [b].[CountryCode] = [bc].[Code] 
    AND [bc].[CompanyId] = [e].[CompanyId]  -- Modify the join condition to include CompanyId
LEFT JOIN [stg_bc].[CountryRegion] AS [bc2]
    ON [bc].[SalesMarket] = [bc2].[Code]
    AND [bc].[CompanyId] = [bc2].[CompanyId]  -- Modify the join condition to include CompanyId

GO

