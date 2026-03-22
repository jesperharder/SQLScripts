CREATE VIEW [dbo].[DK_GL_Ledger_Simple1]
AS
SELECT TOP(100)PERCENT [gl].[CompanyID]
                      ,[G_L Account No_]
                      ,[gl].[Global Dimension 1 Code]
                      ,[gl].[Global Dimension 2 Code]
                      ,[gl].[Business Unit Code]
                      ,[gl].[Posting Date]
                      ,SUM([gl].[Amount]) AS [Actual]
                      ,CONVERT(varchar(11), [gl].[Posting Date], 114) AS [Tidspunkt]
                      ,[dimafd].[DimAfdeling]
                      ,[dimkaede].[dimkaede]
FROM [stg_navdb].[GLEntry] AS [gl]
LEFT OUTER JOIN [dbo].[GL_LedgerDimension] AS [dimafd]
ON  [gl].[Entry No_] = [dimafd].[Entry No_]
LEFT OUTER JOIN [dbo].[GL_LedgerDimension] AS [dimkaede]
ON  [gl].[Entry No_] = [dimkaede].[Entry No_]
WHERE [gl].[CompanyID] = 1
AND   [gl].[Posting Date] >= '01-01-2023'
GROUP BY [gl].[G_L Account No_]
        ,[gl].[Global Dimension 2 Code]
        ,[gl].[Global Dimension 1 Code]
        ,[gl].[Business Unit Code]
        ,[gl].[Posting Date]
        ,[gl].[CompanyID]
        ,[dimafd].[DimAfdeling]
        ,[dimkaede].[dimkaede];

GO

