Create View PL_Fact_SalesHistory as
SELECT distinct
    [CompanyID]
      ,[Item No_]
      ,[Posting Date]
      ,[Cust No]
      ,[Location Code]
      ,[Salespers__Purch_ Code]
      ,[Document Type]
      ,[Return Reason Code]
        ,Sum([Invoiced Quantity]) as [Invoiced Qty] -- Den her
        ,SUM([Cost Amount (Actual)])  as [Invoiced Cost Amount]-- Den her
        ,SUM([Sales Amount (Actual)]) as [Invoiced Sales Amount]--Den her
        ,SUM([Discount Amount]) as [Invoiced Discount Amount] -- Den her
  FROM [dbo].[PL_ValueEntry]
  group by 
  [CompanyID]
      ,[Item No_]
      ,[Posting Date]
      ,[Cust No]
      ,[Location Code]
      ,[Salespers__Purch_ Code]
      ,[Document Type]
      ,[Return Reason Code]

GO

