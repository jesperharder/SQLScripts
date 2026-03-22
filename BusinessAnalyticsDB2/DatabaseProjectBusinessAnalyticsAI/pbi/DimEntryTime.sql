CREATE VIEW [pbi].[DimEntryTime]
AS
SELECT [DW_SK_Time] AS [EntryTimeKey]
      ,[QuarterKey] AS [Entry Quarter Sort Key]
      ,[QuarterName] AS [Entry Quarter Name]
      ,[HalfHourKey] AS [Entry Half Hour Sort Key]
      ,[HalfHourName] AS [Entry Half Hour Name]
      ,[HourKey] AS [Entry Hour Sort Key]
      ,[HourName] AS [Entry Hour Name]
FROM [dim].[Time];

GO

