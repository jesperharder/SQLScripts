CREATE VIEW [etl_v1].[BC_GLEntry]
AS
SELECT
    [gle].[CompanyId] AS [CompanyID],
    [gle].[entryNo] AS [NK_EntryNo],
    CAST([gle].[postingDate] AS DATETIME) AS [PostingDate],
    [gle].[glAccountNo] AS [BK_GLAccountNo],
    NULLIF([dims].[AFDELING], N'') AS [BK_Department],
    NULLIF(LTRIM(RTRIM([dims].[KÆDE])), N'') AS [BK_Chain],
    NULLIF([dims].[LAND], N'') AS [BK_Country],
    NULLIF([dims].[LEVERANDØR], N'') AS [BK_Supplier],
    NULLIF([dims].[MARKEDSF], N'') AS [BK_Marketing],
    NULLIF([dims].[PERSONALE], N'') AS [BK_EmployeeCode],
    NULLIF([dims].[VEDLIGEH], N'') AS [BK_Maintainance],
    CAST([gle].[amount] AS DECIMAL(38, 6)) AS [M_Amount_LCY],
    CAST([gle].[systemModifiedAt] AS DATETIME2(7)) AS [ADF_SourceModifiedAt],
    CAST(0x AS VARBINARY(8)) AS [timestamp],
    N'BC_GLEntry' AS [FactSource]
FROM [stg_bc_api].[GLEntry] AS [gle]
OUTER APPLY
(
    SELECT
        MAX(CASE WHEN [dse].[dimensionCode] = N'AFDELING' THEN [dse].[dimensionValueCode] END) AS [AFDELING],
        MAX(CASE WHEN [dse].[dimensionCode] = N'KÆDE' THEN [dse].[dimensionValueCode] END) AS [KÆDE],
        MAX(CASE WHEN [dse].[dimensionCode] = N'LAND' THEN [dse].[dimensionValueCode] END) AS [LAND],
        MAX(CASE WHEN [dse].[dimensionCode] = N'LEVERANDØR' THEN [dse].[dimensionValueCode] END) AS [LEVERANDØR],
        MAX(CASE WHEN [dse].[dimensionCode] = N'MARKEDSF.' THEN [dse].[dimensionValueCode] END) AS [MARKEDSF],
        MAX(CASE WHEN [dse].[dimensionCode] = N'PERSONALE' THEN [dse].[dimensionValueCode] END) AS [PERSONALE],
        MAX(CASE WHEN [dse].[dimensionCode] = N'VEDLIGEH.' THEN [dse].[dimensionValueCode] END) AS [VEDLIGEH]
    FROM [stg_bc_api].[DimensionSetEntry] AS [dse]
    WHERE [dse].[dimensionSetId] = [gle].[dimensionSetId]
      AND [dse].[CompanyID] = [gle].[CompanyId]
) AS [dims]
WHERE [gle].[postingDate] IS NOT NULL
  AND [gle].[postingDate] >= '20230101'
  AND [gle].[postingDate] <> '20230219'
  AND
  (
      ([gle].[CompanyId] = 1 AND [gle].[glAccountNo] IN (N'91201', N'91202'))
      OR ([gle].[CompanyId] = 2 AND [gle].[glAccountNo] IN (N'491201', N'491202'))
      OR (CAST([gle].[postingDate] AS DATE) = [gle].[postingDate] AND [gle].[CompanyId] IN (1, 2))
  );


GO
