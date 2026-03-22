CREATE VIEW [dbo].[DK_GL_Ledger]
AS
SELECT TOP(100)PERCENT [gl].[G_L Account No_]
                      ,[gl].[Global Dimension 1 Code]
                      ,[gl].[Global Dimension 2 Code]
                      ,[gl].[Business Unit Code]
                      ,[gl].[Posting Date]
                      ,SUM([gl].[Amount]) AS [Actual]
                      ,CONVERT(varchar(11), [gl].[Posting Date], 114) AS [Tidspunkt]
                      ,[d].[DimKaede]
                      ,[d].[DimAfdeling]
                      ,[d].[DimLand]
FROM [stg_navdb].[GLEntry] AS [gl]
LEFT OUTER JOIN [dbo].[GL_LedgerDimension] AS [d]
ON [gl].[Entry No_] = [d].[Entry No_]
WHERE [gl].[CompanyID] = 1
AND   [gl].[Posting Date] >= '01-01-2023'
GROUP BY [gl].[G_L Account No_]
        ,[gl].[Global Dimension 2 Code]
        ,[gl].[Global Dimension 1 Code]
        ,[gl].[Business Unit Code]
        ,[gl].[Posting Date]
        ,[d].[DimKaede]
        ,[d].[DimAfdeling]
        ,[d].[DimLand];

GO

