CREATE VIEW [pbi].[DimCountry]
AS
SELECT [CountryKey]
      ,[CountryCode] AS [Country Code]
      ,[CountryName] AS [Country Name]
      ,[CountryCodeName] AS [Country Code Name]
FROM [dim].[Country];

GO

