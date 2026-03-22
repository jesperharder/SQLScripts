CREATE VIEW [pbi].[DimMarketing]
AS
SELECT [MarketingKey]
      ,[MarketingCode] AS [Marketing Code]
      ,[MarketingName] AS [Marketing Name]
      ,[MarketingCodeName] AS [Marketing Code Name]
FROM [dim].[Marketing];

GO

