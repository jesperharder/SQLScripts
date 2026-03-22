CREATE VIEW [dbo].[PoulFactVal] as

SELECT a.[PostingDateKey]
      ,a.[CompanyKey]
      ,b.[CompanyNameShort]
      ,a.[FinanceAccountKey]
      ,a.[DepartmentKey]
      ,a.[ChainKey]
      ,a.[CountryKey]
      ,a.[SupplierKey]
      ,a.[MarketingKey]
      ,a.[EmployeeKey]
      ,a.[MaintainanceKey]
      ,a.[M_Amount_LCY]
      ,a.[CompanyID]
      ,c.[AccountNo]
      ,c.[AccountName]
      ,c.[Account_Income_Balance]
      ,CASE
        when a.[CompanyKey]=1 then 'DKK'
        when a.[CompanyKey]=2 then 'USD'
        when a.[CompanyKey]=3 then 'SGD'
        when a.[CompanyKey]=4 then 'NOK'
        when a.[CompanyKey]=5 then 'JPY'
        when a.[CompanyKey]=6 then 'RMB'
      End as LocalCurrency   
      ,CASE
        when a.[CompanyKey]=1 then 'DKK'
        when a.[CompanyKey]=2 then 'DKK'
        when a.[CompanyKey]=3 then 'DKK'
        when a.[CompanyKey]=4 then 'DKK'
        when a.[CompanyKey]=5 then 'DKK'
        when a.[CompanyKey]=6 then 'DKK'
      End as ReportingCurrencyDKK   

      
  FROM [fct].[FinanceEntry] a LEFT JOIN [dim].[Company] b on a.[CompanyKey]=b.[CompanyKey] left JOIN [dim].[GLAccount] c on a.[FinanceAccountKey]=c.[GLAccountKey] 
        
  where [PostingDateKey]>=20220101 and [PostingDateKey]<=20250630

GO

