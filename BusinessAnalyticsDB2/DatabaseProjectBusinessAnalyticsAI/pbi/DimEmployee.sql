CREATE VIEW [pbi].[DimEmployee]
AS
SELECT [EmployeeKey]
      ,[EmployeeCode] AS [Employee Code]
      ,[EmployeeName] AS [Employee Name]
      ,[EmployeeCodeName] AS [Employee Code Name]
FROM [dim].[Employee];

GO

