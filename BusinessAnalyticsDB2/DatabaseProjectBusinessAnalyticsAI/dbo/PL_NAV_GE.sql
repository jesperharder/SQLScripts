Create view PL_NAV_GE as
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
AND   DATEADD(YEAR, DATEDIFF(YEAR, 0, [GLE].[Posting Date]), 0) = DATETIMEFROMPARTS(2022, 1, 1, 0, 0, 0, 0)

GO

