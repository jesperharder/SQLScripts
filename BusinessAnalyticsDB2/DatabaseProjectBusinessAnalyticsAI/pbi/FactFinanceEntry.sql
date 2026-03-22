CREATE VIEW [pbi].[FactFinanceEntry]
AS
SELECT [PostingDateKey]
      ,[CompanyKey]
      ,[FinanceAccountKey]
      ,[DepartmentKey]
      ,[ChainKey]
      ,[CountryKey]
      ,[SupplierKey]
      ,[MarketingKey]
      ,[EmployeeKey]
      ,[MaintainanceKey]
      ,[M_Amount_LCY]
FROM [fct].[FinanceEntry];

GO

