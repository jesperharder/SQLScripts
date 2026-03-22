CREATE VIEW [pbi].[DimDepartment]
AS
SELECT [DepartmentKey]
      ,[DepartmentCode] AS [Department Code]
      ,[DepartmentName] AS [Department Name]
      ,[DepartmentCodeName] AS [Department Code Name]
FROM [dim].[Department];

GO

