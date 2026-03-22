CREATE   PROCEDURE [etl].[GetRowsFactRealisedSale_BC_SalesInvoiceLine]

--2024.04 JH: Changed Chain Dimension to Fetch Current Customer Setup
--2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
--2024.07.31JH:     Added CampaignNo
(
    @LastTimestamp nvarchar(24) = N'0x'
   ,@UpdateType int = 3
)
AS
BEGIN



--DECLARE    @LastTimestamp nvarchar(24) = N'0x'
--DECLARE @UpdateType int = 3

    SET NOCOUNT ON;

    DECLARE @ts varbinary(8) = CAST(RIGHT(@LastTimestamp, LEN(@LastTimestamp) - 2) AS varbinary(8));
    DECLARE @PostingFrom datetime = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0));

    SELECT
        --Basics
        [sih].[CompanyID]
       ,NULLIF([sil].[Shortcut Dimension 1 Code], '') AS [BK_Department]
       ,(
            SELECT MAX([value].[v])FROM(VALUES([sil].[timestamp]), ([sih].[timestamp])) AS [value]([v])
        ) AS [timestamp]

       --Customer
       ,TRIM(CAST([sih].[Sell-to Customer No_] as nvarchar(20))) AS [BK_Customer]
       -- CustomerGeographyKey, Composed by:
       ,TRIM([sih].[Sell-to Post Code]) AS [BK_PostCode]
       ,CASE
            WHEN [sih].[Sell-to Country_Region Code] = '' THEN
                [ci].[Country_Region Code]
            ELSE
                [sih].[Sell-to Country_Region Code]
        END AS [BK_Customer_Geography_Country]

       --Item
       ,CAST(IIF([sil].[Type] = 2, [sil].[No_], NULL) AS nvarchar(20)) AS [BK_Item]

       --Order
       ,[sih].[Order No_] AS [BK_SalesOrder]
       ,[sih].[Order Date] AS [BK_Date_Intake]
       ,[sih].[Salesperson Code] AS [BK_SalesPerson]
        --2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
        ,[CUST_SELLTO].[Salesperson Code] AS [BK_SalesPerson_SellToCustomer]

       -- Currency
       ,ISNULL(NULLIF([sih].[Currency Code], N''), [gls].[LCY Code]) AS [BK_Currency_Document]
       ,[gls].[LCY Code] AS [BK_Currency_Company]
       ,CASE
            WHEN [sih].[Currency Code] = '' THEN
                [gls].[LCY Code]
            ELSE
                [sih].[Currency Code]
        END AS [BK_Currency_ExchangeRate]

       --Posting
       ,CONVERT(date, [sih].[Posting Date]) AS [BK_Date_Posting]
       ,CAST([sih].[Posting Date] AS date) AS [BKFinaceVoucherPostingDate]
       ,CASE
            WHEN [sih].[Posting Date] > GETDATE() THEN
                DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
            ELSE
                [sih].[Posting Date]
        END AS [BK_Date_ExchangeRate]
       ,[sil].[Document No_] AS [NK_DocumentNumber]
       ,[sil].[Line No_] AS [NK_DocumentLineNumber]
       ,CAST(CASE
                 WHEN [sil].[Type] = 1 THEN
                     [sil].[No_]
                 ELSE
                     NULL
             END AS nvarchar(100)) AS [BK_FinanceAccount]
       ,CAST(N'Invoice' AS nvarchar(50)) AS [BK_FinanceVoucherDocumentType]
       ,CONVERT(nvarchar(10), N'SALG') AS [BK_FinanceVoucherSourceCode]

       --Logistics
       ,[sih].[Shipping Agent Code] AS [BK_DeliveryMethod]
       ,[sil].[Location Code] AS [BK_Location]

       -- Lookup Columns
       ,[sil].[Gen_ Bus_ Posting Group] AS [BK_GenBusPostingGroup]
       ,[sil].[Gen_ Prod_ Posting Group] AS [BK_GenProdPostingGroup]
       ,ISNULL(NULLIF([sil].[Return Reason Code], N''), N'ALMSALG') AS [BK_ReturnReasonCode]
       ,[sih].[Shipment Method Code] AS [BK_ShipmentMethodCode]
       --,[dims].[AD HOC] AS [BK_AdHocCode]
       --,[dims].[AFDELING] AS [BK_DepartmentCode]
       
       --2024.04 JH: Changed Chain Dimension to Fetch Current Customer Setup
       --,NULLIF([dims].[KÆDE], '') AS [BK_ChainCode]
       ,NULLIF(CURR_CUSTOMER_CHAIN.DefaultDimensionDimensionValueCode, '') as [BK_ChainCode]
       ,[sil].[Yearcode Text] as [BK_YearCodeText]
       --,[dims].[LAND] AS [BK_CountryCode]
       --,[dims].[LEVERANDØR] AS [BK_SupplierCode]
       --,[dims].[MARKEDSF] AS [BK_MarketingCode]
       --,[dims].[PERSONALE] AS [BK_EmployeeCode]
       --,[dims].[VEDLIGEH] AS [BK_MaintainanceCode]

        --Campaign 2024.07.31
        --Campaign 2024.07.31
        ,CASE 
            WHEN [sil].[Used Campaign] = '' THEN 'No Campaign' 
            ELSE [sil].[Used Campaign] 
        END AS [BK_CampaignNo]

       -- Measures
       ,CAST(IIF([sil].[Type] = 2, [sil].[Quantity], 0) AS decimal(18, 4)) AS [M_Quantity]
       ,CAST([sil].[Unit Cost] AS decimal(18, 4)) AS [M_UnitCost]
       ,CAST([sil].[Unit Cost (LCY)] AS decimal(18, 4)) AS [M_UnitCost_LCY]
       ,CAST([sil].[Amount] AS decimal(18, 4)) AS [M_Amount]
       ,CAST([sil].[Quantity] * [sil].[Unit Cost] AS decimal(18, 4)) AS [M_COGS]
       ,CAST([sil].[Amount] - ([sil].[Quantity] * [sil].[Unit Cost]) AS decimal(18, 4)) AS [M_GM]
       ,CAST(CAST([sil].[Amount] AS decimal(38, 6)) / CAST(ISNULL(NULLIF([sih].[Currency Factor], 0.0), 1.0) AS decimal(38, 15)) AS decimal(18, 4)) AS [M_Amount_LCY]
       ,CAST([sil].[Quantity] * [sil].[Unit Cost (LCY)] AS decimal(18, 4)) AS [M_COGS_LCY]
       ,CAST((CAST([sil].[Amount] AS decimal(38, 6)) / CAST(ISNULL(NULLIF([sih].[Currency Factor], 0.0), 1.0) AS decimal(38, 15))) - ([sil].[Quantity] * [sil].[Unit Cost (LCY)]) AS decimal(18, 4)) AS [M_GM_LCY]
       ,CAST(ISNULL(NULLIF([sih].[Currency Factor], 0.0), 1.0) AS decimal(18, 15)) AS [M_CurrencyFactor]
       ,CAST(N'BC_SalesInvoiceLine' AS nvarchar(128)) AS [ADF_FactSource]
       ,[el].[UpdatedRow]
    FROM [stg_bc].[SalesInvoiceLine] AS [sil]
    INNER JOIN [stg_bc].[SalesInvoiceHeader] AS [sih]
    ON  [sil].[CompanyID] = [sih].[CompanyID]
    AND [sil].[Document No_] = [sih].[No_]
    INNER JOIN [stg_bc].[CompanyInformation] AS [ci]
    ON [ci].[CompanyID] = [sil].[CompanyID]
    LEFT JOIN [stg_bc].[GeneralLedgerSetup] AS [gls]
    ON [sil].[CompanyID] = [gls].[CompanyID]
    OUTER APPLY
    (
        SELECT IIF(COUNT(*) > 0, 1, 0) AS [UpdatedRow]
        FROM [fct].[RealisedSale] AS [rs]
        WHERE [rs].[NK_PostingDate] = [sil].[Posting Date]
        AND   [rs].[CompanyID] = [sil].[CompanyID]
        AND   [rs].[NK_SalesOrderNumber] = [sih].[Order No_]
        AND   [rs].[NK_DocumentNumber] = [sil].[Document No_]
        AND   [rs].[NK_DocumentLineNumber] = [sil].[Line No_]
        AND   [rs].[NK_LineEntryType] = N'Invoice'
        AND   [rs].[ADF_FactSource] = N'BC_SalesInvoiceLine'
    ) AS [el]
    OUTER APPLY
    (
        SELECT [Dimension Set ID]
              ,[CompanyID]
              ,[AD HOC]
              ,[AFDELING]
              ,[KÆDE]
              ,[LAND]
              ,[LEVERANDØR]
              ,[MARKEDSF.] AS [MARKEDSF]
              ,[PERSONALE]
              ,[VEDLIGEH.] AS [VEDLIGEH]
        FROM
        (
            SELECT [dse].[Dimension Set ID]
                  ,[dse].[Dimension Code]
                  ,[dse].[Dimension Value Code]
                  ,[dse].[CompanyID]
            FROM [stg_bc].[DimensionSetEntry] AS [dse]
            WHERE [dse].[Dimension Set ID] = [sil].[Dimension Set ID]
            AND   [dse].[CompanyID] = [sil].[CompanyID]
        ) AS [scr]
        PIVOT
        (
            MAX([Dimension Value Code])
            FOR [Dimension Code] IN([AD HOC], [AFDELING], [KÆDE], [LAND], [LEVERANDØR], [MARKEDSF.], [PERSONALE], [VEDLIGEH.])
        ) AS [pvt]
    ) AS [dims]

--2024.04 JH: Changed Chain Dimension to Fetch Current Customer Setup
LEFT JOIN 
    (SELECT 
      [No_] as DefaultDimensionCustomerNo
      ,[Dimension Value Code] as DefaultDimensionDimensionValueCode
      ,[CompanyID] as DefaultDimensionCompanyID
  FROM [stg_bc].[DefaultDimension]
  WHERE 0=0
    --and CompanyID = 2
    and [Table ID] = 18
    and [Dimension Code] = 'KÆDE'
    ) as CURR_CUSTOMER_CHAIN 
        on sih.[Sell-to Customer No_] = CURR_CUSTOMER_CHAIN.DefaultDimensionCustomerNo
        and sih.CompanyID = CURR_CUSTOMER_CHAIN.DefaultDimensionCompanyID

--2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
LEFT JOIN stg_bc.Customer [CUST_SELLTO]
ON [CUST_SELLTO].CompanyID = SIH.[CompanyID] 
AND [CUST_SELLTO].No_ = [sih].[Sell-to Customer No_]






    WHERE [sil].[Type] IN ( 1, 2 )
    AND   [sil].[Posting Date] >= '20230301'
    AND   [sil].[VAT Prod_ Posting Group] <> N'EKSPORT'
    AND
          (
              [sil].[Posting Date] >= @PostingFrom
        OR      [sil].[timestamp] > @ts
        OR    [sih].[timestamp] > @ts
        OR    @UpdateType IN ( 3, 31 )
          );

END;

GO

