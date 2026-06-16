CREATE VIEW [etl].[DimChainSource]
AS
-- 2026-06-16 Codex: Company 3+4 now use NAV customer-card chain fields as canonical
-- chain source. The values are converted into the existing dim.Chain contract so the
-- classic path keeps one shared chain dimension across BC/API and NAV companies.
SELECT DISTINCT
      CASE
          WHEN NULLIF(TRIM([c].[Chain Code]), '') IS NULL THEN N'Blank'
          ELSE TRIM([c].[Chain Code])
      END AS ChainCode
    , CASE
          WHEN NULLIF(TRIM([c].[Chain Code]), '') IS NULL THEN N'Blank'
          ELSE TRIM([c].[Chain Code])
      END AS ChainName
    , CASE
          WHEN NULLIF(TRIM([c].[Chain Group Code]), '') IS NULL THEN N'Blank'
          ELSE TRIM([c].[Chain Group Code])
      END AS ChainGroupCode
    , CASE
          WHEN NULLIF(TRIM([c].[Chain Group Code]), '') IS NULL THEN N'Blank'
          ELSE TRIM([c].[Chain Group Code])
      END AS ChainGroupName
    , [c].[CompanyID] AS CompanyID
FROM [stg_navdb].[Customer] AS [c]
WHERE [c].[CompanyID] IN (3,4)
    AND (
        NULLIF(TRIM([c].[Chain Code]), '') IS NOT NULL
        OR NULLIF(TRIM([c].[Chain Group Code]), '') IS NOT NULL
    )

UNION ALL

SELECT ISNULL(Chain.Code,'') AS ChainCode
    , ISNULL(TRIM(Chain.Name),'') AS ChainName
    , ISNULL(ChainGroup.Code,'') AS ChainGroupCode
    , ISNULL(TRIM(ChainGroup.Name),'') AS ChainGroupName
    , Dim.CompanyID AS CompanyID 
FROM [stg_bc_api].[DimensionValue] AS Dim
LEFT JOIN [stg_bc_api].[DimensionValue] AS ChainGroup
    ON Dim.CompanyID = ChainGroup.CompanyID
        AND Dim.[DimensionCode] = ChainGroup.[DimensionCode]
        AND ChainGroup.Code BETWEEN LEFT(Dim.Totaling, CHARINDEX('..', Dim.Totaling) - 1) AND RIGHT(Dim.Totaling, CHARINDEX('..', Dim.Totaling) - 1)
        AND ChainGroup.[dimensionValueTypeInt] IN (0)
LEFT JOIN [stg_bc_api].[DimensionValue] AS Chain
    ON Chain.[dimensionValueTypeInt] IN (3)
        AND Dim.[DimensionCode] = Chain.[DimensionCode]
        AND Chain.Code = TRIM(LEFT(Dim.Totaling, CHARINDEX('..', Dim.Totaling) - 1))
WHERE 0 = 0
    AND Dim.[dimensionValueTypeInt] IN (4)
    AND Dim.[DimensionCode] IN ('KÆDE')
    AND Dim.CompanyId IN(1,2,5,6)

GO

