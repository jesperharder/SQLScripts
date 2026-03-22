CREATE VIEW [pbi].[DimCompany]
AS
SELECT [CompanyKey]
      ,[CompanyID] AS [Company ID]
      ,[CompanyNameShort] AS [Company Name Short]
      ,[CompanyNameLong] AS [Company Name Long]
      ,[CompanyCountryCode] AS [Company Country Code]
FROM [dim].[Company];

GO

