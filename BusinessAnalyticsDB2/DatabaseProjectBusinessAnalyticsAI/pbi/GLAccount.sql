CREATE VIEW [pbi].[GLAccount]
AS
SELECT [GLAccountKey]
      ,[AccountNo] AS [Account No]
      ,[AccountName] AS [Account Name]
      ,[AccountNoDescription] AS [Account No Description]
      ,[Account_Income_Balance] AS [Account Income Balance]
      ,[Account_Main] AS [Account Main]
FROM [dim].[GLAccount];

GO

