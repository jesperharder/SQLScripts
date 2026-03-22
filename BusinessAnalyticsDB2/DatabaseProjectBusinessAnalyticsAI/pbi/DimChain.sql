CREATE VIEW [pbi].[DimChain]
AS
SELECT [ChainKey]
      ,[ChainCode] AS [Chain Code]
      ,[ChainName] AS [Chain Name]
      ,[ChainCodeName] AS [Chain Code Name]
FROM [dim].[Chain];

GO

