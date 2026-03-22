CREATE VIEW [dbo].[PLBC_GL]
AS
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

GO

