CREATE VIEW [dbo].[GL_Budget]
AS
SELECT 'Budget' AS [Source]
      ,[b].[Budget Name]
      ,[b].[G_L Account No_]
      ,[b].[Date]
      ,[b].[Global Dimension 1 Code]
      ,[b].[Global Dimension 2 Code]
      ,[b].[Amount] AS [Budget]
      ,[b].[Business Unit Code]
      ,[b].[Budget Dimension 1 Code]
      ,[b].[Budget Dimension 2 Code]
      ,[b].[Budget Dimension 3 Code]
      ,[b].[Budget Dimension 4 Code]
FROM [stg_navdb].[GLBudgetEntry] AS [b]
WHERE([b].[Budget Name] IN ( N'BUD2023', N'BUD2020', N'BUD2021', N'BUD2024', N'BUD2022' ));

GO

