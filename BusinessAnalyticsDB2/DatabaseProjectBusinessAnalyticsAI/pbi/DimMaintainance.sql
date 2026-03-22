CREATE VIEW [pbi].[DimMaintainance]
AS
SELECT [MaintainanceKey]
      ,[MaintainanceCode] AS [Maintainance Code]
      ,[MaintainanceName] AS [Maintainance Name]
      ,[MaintainanceCodeName] AS [Maintainance Code Name]
FROM [dim].[Maintainance];

GO

