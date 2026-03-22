CREATE view [dbo].[DimDept] as
SELECT       [CompanyID], [Dimension Code], Code AS Dept, Name AS Dept_Description, [Responsible Dimension], [Responsible Dimension Name], Code + '-' + Name AS [Dept Description]
FROM            stg_navdb.DimensionValue
WHERE        ([Dimension Code] = N'AFDELING')

GO

