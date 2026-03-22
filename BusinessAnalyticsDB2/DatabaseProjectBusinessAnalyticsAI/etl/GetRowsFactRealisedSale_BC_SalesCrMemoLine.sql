CREATE   PROCEDURE [etl].[GetRowsFactRealisedSale_BC_SalesCrMemoLine]

--2024.04 JH: Changed Chain Dimension to Fetch Current Customer Setup
--2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
--2024.07.31JH:     Added dummy CampaignNo

(
    @LastTimestamp nvarchar(24) = N'0x'
   ,@UpdateType int = 3
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ts varbinary(8) = CAST(RIGHT(@LastTimestamp, LEN(@LastTimestamp) - 2) AS varbinary(8));
    DECLARE @PostingFrom datetime = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0));

    SELECT [scmh].[CompanyID]
          ,NULLIF([scml].[Shortcut Dimension 1 Code], '') AS [BK_Department]
          ,(
               SELECT MAX([value].[v])FROM(VALUES([scml].[timestamp]), ([scmh].[timestamp])) AS [value]([v])
           ) AS [timestamp]
          ,TRIM(CAST([scmh].[Sell-to Customer No_] as nvarchar(20))) AS [BK_Customer]
          ,TRIM([scmh].[Sell-to Post Code]) AS [BK_PostCode]
          ,CASE
               WHEN [scmh].[Sell-to Country_Region Code] = '' THEN
                   [ci].[Country_Region Code]
               ELSE
                   [scmh].[Sell-to Country_Region Code]
           END AS [BK_Customer_Geography_Country]
          ,CAST(IIF([scml].[Type] = 2, [scml].[No_], NULL) AS nvarchar(20)) AS [BK_Item]
          ,ISNULL([sih].[Order No_], N'') AS [BK_SalesOrder]
          ,[scmh].[Document Date] AS [BK_Date_Intake]
          ,[scmh].[Salesperson Code] AS [BK_SalesPerson]
        --2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
        ,[CUST_SELLTO].[Salesperson Code] AS [BK_SalesPerson_SellToCustomer]


          ,ISNULL(NULLIF([scmh].[Currency Code], N''), [gls].[LCY Code]) AS [BK_Currency_Document]
          ,[gls].[LCY Code] AS [BK_Currency_Company]
          ,CASE
               WHEN [scmh].[Currency Code] = '' THEN
                   [gls].[LCY Code]
               ELSE
                   [scmh].[Currency Code]
           END AS [BK_Currency_ExchangeRate]
          ,CONVERT(date, [scmh].[Posting Date]) AS [BK_Date_Posting]
          ,CAST([scmh].[Posting Date] AS date) AS [BKFinaceVoucherPostingDate]
          ,CASE
               WHEN [scmh].[Posting Date] > GETDATE() THEN
                   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
               ELSE
                   [scmh].[Posting Date]
           END AS [BK_Date_ExchangeRate]

        --Campaign 2024.07.31
        ,'' AS [BK_CampaignNo]


        --NaturalKey
          ,[scml].[Document No_] AS [NK_DocumentNumber]
          ,[scml].[Line No_] AS [NK_DocumentLineNumber]
          ,CAST(CASE
                    WHEN [scml].[Type] = 1 THEN
                        [scml].[No_]
                    ELSE
                        NULL
                END AS nvarchar(100)) AS [BK_FinanceAccount]
          ,CAST(N'Credit Memo' AS nvarchar(50)) AS [BK_FinanceVoucherDocumentType]
          ,CONVERT(nvarchar(10), N'SALG') AS [BK_FinanceVoucherSourceCode]
          ,[scmh].[Shipping Agent Code] AS [BK_DeliveryMethod]
          ,[scml].[Location Code] AS [BK_Location]
          ,[scml].[Gen_ Bus_ Posting Group] AS [BK_GenBusPostingGroup]
          ,[scml].[Gen_ Prod_ Posting Group] AS [BK_GenProdPostingGroup]
          ,ISNULL(NULLIF([scml].[Return Reason Code], N''), N'ALMSALG') AS [BK_ReturnReasonCode]
          ,[scmh].[Shipment Method Code] AS [BK_ShipmentMethodCode]
          ,[scml].[Yearcode Text] as [BK_YearCodeText]
          
          --,[dims].[AD HOC] AS [BK_AdHocCode]
          --,[dims].[AFDELING] AS [BK_DepartmentCode]
          
          --2024.04 JH: Changed Chain Dimension to Fetch Current Customer Setup
          --,NULLIF([dims].[KÆDE], '') AS [BK_ChainCode]
          ,NULLIF(CURR_CUSTOMER_CHAIN.DefaultDimensionDimensionValueCode, '') as [BK_ChainCode]

          --,[dims].[LAND] AS [BK_CountryCode]
          --,[dims].[LEVERANDØR] AS [BK_SupplierCode]
          --,[dims].[MARKEDSF] AS [BK_MarketingCode]
          --,[dims].[PERSONALE] AS [BK_EmployeeCode]
          --,[dims].[VEDLIGEH] AS [BK_MaintainanceCode]
          ,-CAST(IIF([scml].[Type] = 2, [scml].[Quantity], 0) AS decimal(18, 4)) AS [M_Quantity]
          ,CAST([scml].[Unit Cost] AS decimal(18, 4)) AS [M_UnitCost]
          ,CAST([scml].[Unit Cost (LCY)] AS decimal(18, 4)) AS [M_UnitCost_LCY]
          ,-CAST([scml].[Amount] AS decimal(18, 4)) AS [M_Amount]
          ,-CAST([scml].[Quantity] * [scml].[Unit Cost] AS decimal(18, 4)) AS [M_COGS]
          ,-CAST([scml].[Amount] - ([scml].[Quantity] * [scml].[Unit Cost]) AS decimal(18, 4)) AS [M_GM]
          ,-CAST(CAST([scml].[Amount] AS decimal(38, 6)) / CAST(ISNULL(NULLIF([scmh].[Currency Factor], 0.0), 1.0) AS decimal(38, 15)) AS decimal(18, 4)) AS [M_Amount_LCY]
          ,-CAST([scml].[Quantity] * [scml].[Unit Cost (LCY)] AS decimal(18, 4)) AS [M_COGS_LCY]
          ,-CAST((CAST([scml].[Amount] AS decimal(38, 6)) / CAST(ISNULL(NULLIF([scmh].[Currency Factor], 0.0), 1.0) AS decimal(38, 15))) - ([scml].[Quantity] * [scml].[Unit Cost (LCY)]) AS decimal(18, 4)) AS [M_GM_LCY]
          ,CAST(ISNULL(NULLIF([scmh].[Currency Factor], 0.0), 1.0) AS decimal(18, 15)) AS [M_CurrencyFactor]
          ,CAST(N'BC_SalesCrMemoLine' AS nvarchar(128)) AS [ADF_FactSource]
          ,[el].[UpdatedRow]
    FROM [stg_bc].[SalesCrMemoLine] AS [scml]
    INNER JOIN [stg_bc].[SalesCrMemoHeader] AS [scmh]
    ON  [scml].[CompanyID] = [scmh].[CompanyID]
    AND [scml].[Document No_] = [scmh].[No_]
    INNER JOIN [stg_bc].[CompanyInformation] AS [ci]
    ON [ci].[CompanyID] = [scml].[CompanyID]
    LEFT JOIN [stg_bc].[GeneralLedgerSetup] AS [gls]
    ON [scml].[CompanyID] = [gls].[CompanyID]
    LEFT JOIN [stg_bc].[SalesInvoiceHeader] AS [sih]
    ON  [sih].[CompanyID] = [scmh].[CompanyID]
    AND [sih].[No_] = [scmh].[Applies-to Doc_ No_]
    OUTER APPLY
    (
        SELECT IIF(COUNT(*) > 0, 1, 0) AS [UpdatedRow]
        FROM [fct].[RealisedSale] AS [rs]
        WHERE [rs].[NK_PostingDate] = [scml].[Posting Date]
        AND   [rs].[CompanyID] = [scml].[CompanyID]
        AND   [rs].[NK_SalesOrderNumber] = ISNULL([sih].[Order No_], N'')
        AND   [rs].[NK_DocumentNumber] = [scml].[Document No_]
        AND   [rs].[NK_DocumentLineNumber] = [scml].[Line No_]
        AND   [rs].[NK_LineEntryType] = N'Credit Memo'
        AND   [rs].[ADF_FactSource] = N'BC_SalesCrMemoLine'
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
            WHERE [dse].[Dimension Set ID] = [scml].[Dimension Set ID]
            AND   [dse].[CompanyID] = [scml].[CompanyID]
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
        on scmh.[Sell-to Customer No_] = CURR_CUSTOMER_CHAIN.DefaultDimensionCustomerNo
        and scmh.CompanyID = CURR_CUSTOMER_CHAIN.DefaultDimensionCompanyID

    --2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
    LEFT JOIN stg_bc.Customer [CUST_SELLTO]
    ON [CUST_SELLTO].CompanyID = SIH.[CompanyID] 
    AND [CUST_SELLTO].No_ = [sih].[Sell-to Customer No_]



    WHERE [scml].[Type] IN ( 1, 2 )
    AND   [scml].[Posting Date] >= '20230301'
    AND   [scml].[VAT Prod_ Posting Group] <> N'EKSPORT'
    AND
          (
              [scml].[Posting Date] >= @PostingFrom
        OR      [scml].[timestamp] > @ts
        OR    [scmh].[timestamp] > @ts
        OR    @UpdateType IN ( 3, 31 )
          );

END;

GO

