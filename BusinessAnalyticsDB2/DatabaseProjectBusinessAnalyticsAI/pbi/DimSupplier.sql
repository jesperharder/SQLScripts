CREATE VIEW [pbi].[DimSupplier]
AS
SELECT [SupplierKey]
      ,[SupplierCode] AS [Supplier Code]
      ,[SupplierName] AS [Supplier Name]
      ,[SupplierCodeName] AS [Supplier Code Name]
FROM [dim].[Supplier];

GO

