
CREATE VIEW [dbo].[PL_GLEntry]
AS
SELECT [GLE].[CompanyID]
      ,[GLE].[Entry No_]
      ,[GLE].[G_L Account No_]
      ,[GLE].[Posting Date]
      ,[GLE].[Amount]
      ,[LED_AFDELING].[Dimension Value Code] AS [AFDELING]
      ,[LED_KÆDE].[Dimension Value Code] AS [KÆDE]
      --LAND
      ,[LED_LAND].[Dimension Value Code] AS [LAND]
      --LEVERANDØR
      ,[LED_LEVERANDØR].[Dimension Value Code] AS [LEVERANDØR]
      --MARKEDSF.
      ,[LED_MARKEDSF].[Dimension Value Code] AS [MARKEDSF]
      --PERSONALE
      ,[LED_PERSONALE].[Dimension Value Code] AS [PERSONALE]
      --VEDLIGEH.
      ,[LED_VEDLIGEH].[Dimension Value Code] AS [VEDLIGEH]
FROM [stg_navdb].[GLEntry] AS [GLE]
LEFT OUTER JOIN [stg_navdb].[LedgerEntryDimension] AS [LED_AFDELING]
ON  [GLE].[Entry No_] = [LED_AFDELING].[Entry No_]
AND [LED_AFDELING].[Table ID] = 17
AND [GLE].[CompanyID] = [LED_AFDELING].[CompanyID]
AND [LED_AFDELING].[Dimension Code] = 'AFDELING'
LEFT OUTER JOIN [stg_navdb].[LedgerEntryDimension] AS [LED_KÆDE]
ON  [GLE].[Entry No_] = [LED_KÆDE].[Entry No_]
AND [LED_KÆDE].[Table ID] = 17
AND [GLE].[CompanyID] = [LED_KÆDE].[CompanyID]
AND [LED_KÆDE].[Dimension Code] = 'KÆDE'
LEFT OUTER JOIN [stg_navdb].[LedgerEntryDimension] AS [LED_LAND]
ON  [GLE].[Entry No_] = [LED_LAND].[Entry No_]
AND [LED_LAND].[Table ID] = 17
AND [GLE].[CompanyID] = [LED_LAND].[CompanyID]
AND [LED_LAND].[Dimension Code] = 'LAND'
--LEVERANDØR
LEFT OUTER JOIN [stg_navdb].[LedgerEntryDimension] AS [LED_LEVERANDØR]
ON  [GLE].[Entry No_] = [LED_LEVERANDØR].[Entry No_]
AND [LED_LEVERANDØR].[Table ID] = 17
AND [GLE].[CompanyID] = [LED_LEVERANDØR].[CompanyID]
AND [LED_LEVERANDØR].[Dimension Code] = 'LEVERANDØR'
--MARKEDSF.
LEFT OUTER JOIN [stg_navdb].[LedgerEntryDimension] AS [LED_MARKEDSF]
ON  [GLE].[Entry No_] = [LED_MARKEDSF].[Entry No_]
AND [LED_MARKEDSF].[Table ID] = 17
AND [GLE].[CompanyID] = [LED_MARKEDSF].[CompanyID]
AND [LED_MARKEDSF].[Dimension Code] = 'MARKEDSF.'
--PERSONALE
LEFT OUTER JOIN [stg_navdb].[LedgerEntryDimension] AS [LED_PERSONALE]
ON  [GLE].[Entry No_] = [LED_PERSONALE].[Entry No_]
AND [LED_PERSONALE].[Table ID] = 17
AND [GLE].[CompanyID] = [LED_PERSONALE].[CompanyID]
AND [LED_PERSONALE].[Dimension Code] = 'PERSONALE'
--VEDLIGEH.
LEFT OUTER JOIN [stg_navdb].[LedgerEntryDimension] AS [LED_VEDLIGEH]
ON  [GLE].[Entry No_] = [LED_VEDLIGEH].[Entry No_]
AND [LED_VEDLIGEH].[Table ID] = 17
AND [GLE].[CompanyID] = [LED_VEDLIGEH].[CompanyID]
AND [LED_VEDLIGEH].[Dimension Code] = 'VEDLIGEH.'
WHERE [GLE].[CompanyID] = 1
AND   DATEADD(YEAR, DATEDIFF(YEAR, 0, [GLE].[Posting Date]), 0) = DATETIMEFROMPARTS(2023, 1, 1, 0, 0, 0, 0)
UNION ALL
SELECT [gle].[CompanyID]
      ,[gle].[Entry No_]
      ,[gle].[G_L Account No_]
      ,[gle].[Posting Date]
      ,[gle].[Amount]
      ,[dims].[AFDELING]
      ,[dims].[KÆDE]
      ,[dims].[LAND]
      ,[dims].[LEVERANDØR]
      ,[dims].[MARKEDSF]
      ,[dims].[PERSONALE]
      ,[dims].[VEDLIGEH]
FROM [stg_bc].[GLEntry] AS [gle]
OUTER APPLY
(
    SELECT [Dimension Set ID]
          ,[CompanyID]
          ,[AFDELING]
          ,[KÆDE]
          ,[LAND]
          ,[LEVERANDØR]
          ,[MARKEDSF.] AS [MARKEDSF]
          ,[PERSONALE]
          ,[VEDLIGEH.] AS [VEDLIGEH]
    FROM
    (
        SELECT [dse].[Dimension Set ID]
              ,[dse].[Dimension Code]
              ,[dse].[Dimension Value Code]
              ,[dse].[CompanyID]
        FROM [stg_bc].[DimensionSetEntry] AS [dse]
        WHERE [dse].[Dimension Set ID] = [gle].[Dimension Set ID]
        AND   [dse].[CompanyID] = [gle].[CompanyID]
    ) AS [scr]
    PIVOT
    (
        MAX([Dimension Value Code])
        FOR [Dimension Code] IN([AFDELING], [KÆDE], [LAND], [LEVERANDØR], [MARKEDSF.], [PERSONALE], [VEDLIGEH.])
    ) AS [pvt]
) AS [dims]
WHERE [gle].[CompanyID] = 1
AND   [gle].[Posting Date] >= DATETIMEFROMPARTS(2023, 3, 1, 0, 0, 0, 0);
-- AND   DATEADD(YEAR, DATEDIFF(YEAR, 0, [gle].[Posting Date]), 0) >= DATETIMEFROMPARTS(2023, 3, 1, 0, 0, 0, 0)
-- AND [gle].[Global Dimension 1 Code]<>'ÅBNING'

GO

