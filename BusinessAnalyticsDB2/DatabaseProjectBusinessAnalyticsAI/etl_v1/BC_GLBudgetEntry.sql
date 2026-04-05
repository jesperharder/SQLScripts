CREATE VIEW [etl_v1].[BC_GLBudgetEntry]
AS
SELECT
    [gbe].[CompanyId] AS [CompanyID],
    [gbe].[entryNo] AS [NK_EntryNo],
    CAST([gbe].[date] AS DATE) AS [PostingDate],
    [gbe].[budgetName] AS [BK_BudgetName],
    [gbe].[glAccountNo] AS [BK_GLAccountNo],
    NULLIF([gbe].[globalDimension1Code], N'') AS [BK_Department],
    NULLIF([gbe].[globalDimension2Code], N'') AS [BK_EmployeeCode],
    NULLIF(COALESCE(NULLIF([cr].[isoCode], N''), NULLIF([dims].[LAND], N''), NULLIF([ci].[countryRegionCode], N'')), N'') AS [BK_Country],
    NULLIF([dims].[KÆDE], N'') AS [BK_Chain],
    CAST([gbe].[amount] AS DECIMAL(18, 6)) AS [M_Amount_LCY],
    CAST([gbe].[systemModifiedAt] AS DATETIME2(7)) AS [ADF_SourceModifiedAt],
    CAST(0x AS VARBINARY(8)) AS [ADF_LastTimestamp],
    N'BC_GLBudgetEntry' AS [ADF_FactSource]
FROM [stg_bc_api].[GLBudgetEntry] AS [gbe]
OUTER APPLY
(
    SELECT TOP (1)
        [ci].[countryRegionCode]
    FROM [stg_bc_api].[CompanyInformation] AS [ci]
    WHERE [ci].[CompanyId] = [gbe].[CompanyId]
    ORDER BY [ci].[primaryKey]
) AS [ci]
OUTER APPLY
(
    SELECT
        MAX(CASE WHEN [dse].[dimensionCode] = N'LAND' THEN [dse].[dimensionValueCode] END) AS [LAND],
        MAX(CASE WHEN [dse].[dimensionCode] = N'KÆDE' THEN [dse].[dimensionValueCode] END) AS [KÆDE]
    FROM [stg_bc_api].[DimensionSetEntry] AS [dse]
    WHERE [dse].[CompanyID] = [gbe].[CompanyId]
      AND [dse].[dimensionSetId] = [gbe].[dimensionSetId]
) AS [dims]
LEFT JOIN [stg_bc_api].[CountryRegion] AS [cr]
    ON [cr].[CompanyId] = [gbe].[CompanyId]
   AND [cr].[code] = [dims].[LAND];


GO
