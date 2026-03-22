CREATE   VIEW [etl].[DimCountryRegionSource]
AS
WITH [base]
AS
(
    SELECT [alpha_2] AS [CountryCode]
          ,[name] AS [CountryName]
          ,[region] AS [CountryRegion]
          ,[sub_region] AS [CountrySubRegion]
          ,[intermediate_region] AS [CountryIntermediateRegion]
          ,CAST(N'World' AS nvarchar(7)) AS [Level0]
          ,COALESCE([region], [sub_region], [intermediate_region], [name]) AS [Level1]
          ,COALESCE([sub_region], [intermediate_region], [name]) AS [Level2]
          ,COALESCE([intermediate_region], [name]) AS [Level3]
          ,[name] AS [Level4]
    FROM [meta].[ISO-3166-Countries-with-Regional-Codes]
)
SELECT [b].[CountryCode]
      ,[b].[CountryName]
      ,[b].[CountryRegion]
      ,[b].[CountrySubRegion]
      ,[b].[CountryIntermediateRegion]
      ,[b].[Level0] AS [CountryRegionLevel0]
      ,[b].[Level1] AS [CountryRegionLevel1]
      ,IIF([b].[Level2] = [b].[Level1], NULL, [b].[Level2]) AS [CountryRegionLevel2]
      ,IIF([b].[Level3] = [b].[Level2], NULL, [b].[Level3]) AS [CountryRegionLevel3]
      ,IIF([b].[Level4] = [b].[Level3], NULL, [b].[Level4]) AS [CountryRegionLevel4]
      ,NULLIF([cr].[Market Type], N'') AS [MarketType]
      ,NULLIF([cr].[Channel Type], N'') AS [ChannelType]
      ,ISNULL([cr].[timestamp], 0x) AS [ADF_LastTimestamp]
      ,CAST(N'ETL_DimCountryRegion' AS nvarchar(128)) AS [ADF_DimensionSource]
FROM [base] AS [b]
LEFT JOIN [stg_navdb].[CountryRegion] AS [cr]
ON  [cr].[ISO A2] = [b].[CountryCode]
AND [cr].[CompanyID] = 1
AND [cr].[ISO A2] <> [cr].[Name]
AND [cr].[ISO A2] = LEFT([cr].[ISO A3], 2);

GO

