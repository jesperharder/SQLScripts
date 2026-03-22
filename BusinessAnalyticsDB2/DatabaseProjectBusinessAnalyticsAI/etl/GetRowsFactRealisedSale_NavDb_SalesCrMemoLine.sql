CREATE   PROCEDURE [etl].[GetRowsFactRealisedSale_NavDb_SalesCrMemoLine]

--2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
--2024.07.31JH:     Added dummy CampaignNo
--2024.08.28JH:     Bug in CompanyInformation changed from stg_bc to, INNER JOIN [stg_navdb].[CompanyInformation] AS [ci]
--2024.09.03JH:     Adjusted Where to include all new dates from companies not in 1 and 2

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
          
          -- laguda ,ISNULL([cn].[No_], [scmh].[Sell-to Customer No_]) AS [BK_Customer]
          --fix1,ISNULL(NAVCHAIN.CustomerNo,'') AS [BK_Customer]

          --,ISNULL(NAVCHAIN.CustomerNo,'') AS [BK_Customer]
          ,TRIM(CAST(ISNULL([OLDCUST].[NewCustomerNo], [scmh].[Sell-to Customer No_]) as nvarchar(20))) AS [BK_Customer]  

          ,TRIM([scmh].[Sell-to Post Code]) AS [BK_PostCode]
          ,IIF([cr].[ISO A2] IS NULL, [ci].[Country_Region Code], [cr].[ISO A2]) AS [BK_Customer_Geography_Country]
          ,CAST(IIF([scml].[Type] = 2, [scml].[No_], NULL) AS nvarchar(20)) AS [BK_Item]
          ,ISNULL([sih].[Order No_], N'') AS [BK_SalesOrder]
          ,[scmh].[Document Date] AS [BK_Date_Intake]
          ,ISNULL(NULLIF([sih].[Salesperson Code], N''), [c].[Salesperson Code]) AS [BK_SalesPerson]
        --2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
        ,[CUST_SELLTO].[Salesperson Code] AS [BK_SalesPerson_SellToCustomer]

          
          --Currency
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

          --NatualKey
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
          ,CAST(N'Blank' AS nvarchar(10)) AS [BK_DeliveryMethod]
          ,[scml].[Location Code] AS [BK_Location]

          -- Lookup Columns
          ,[scml].[Gen_ Bus_ Posting Group] AS [BK_GenBusPostingGroup]
          ,[scml].[Gen_ Prod_ Posting Group] AS [BK_GenProdPostingGroup]
          ,ISNULL(NULLIF([scml].[Return Reason Code], N''), N'ALMSALG') AS [BK_ReturnReasonCode]
          ,[scmh].[Shipment Method Code] AS [BK_ShipmentMethodCode]
          ,[scml].[Yearcode Text] as [BK_YearCodeText]
          --LAGUDA,NULLIF(ISNULL([cn].[ChainGroup], [c2].[ChainCode]), N'') AS [BK_ChainCode]
          --fix1,NULLIF(NAVCHAIN.[BC_Dimension Value Code], N'') AS [BK_ChainCode]
          --,NULLIF([DEFDIM].[Dimension Value Code], N'') AS [BK_ChainCode]
          ,CASE WHEN [scml].CompanyID = 2 THEN
                   NULLIF([NODIM].[Dimension Value Code], N'') 
                ELSE
                   NULLIF([DEFDIM].[Dimension Value Code], N'') 
            END AS [BK_ChainCode]



          --measures
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
          ,CAST(N'NAVDB_SalesCrMemoLine' AS nvarchar(128)) AS [ADF_FactSource]
          ,[el].[UpdatedRow]
    FROM [stg_navdb].[SalesCrMemoLine] AS [scml]
    INNER JOIN [stg_navdb].[SalesCrMemoHeader] AS [scmh]
    ON  [scml].[CompanyID] = [scmh].[CompanyID]
    AND [scml].[Document No_] = [scmh].[No_]
    INNER JOIN [stg_navdb].[CompanyInformation] AS [ci]
    ON [ci].[CompanyID] = [scml].[CompanyID]
    INNER JOIN [stg_navdb].[GeneralLedgerSetup] AS [gls]
    ON [scml].[CompanyID] = [gls].[CompanyID]
    INNER JOIN [stg_navdb].[Customer] AS [c]
    ON  [c].[CompanyID] = [scml].[CompanyID]
    AND [c].[No_] = [scmh].[Sell-to Customer No_]
    LEFT JOIN [stg_navdb].[CountryRegion] AS [cr]
    ON  [cr].[CompanyID] = [scml].[CompanyID]
    AND [cr].[Code] = [scmh].[Sell-to Country_Region Code]
    LEFT JOIN [stg_navdb].[SalesInvoiceHeader] AS [sih]
    ON  [sih].[CompanyID] = [scmh].[CompanyID]
    AND [sih].[No_] = [scmh].[Applies-to Doc_ No_]
    
    LEFT JOIN [stg_navdb].[DefaultDimension] AS DEFDIM
    ON [scmh].[Sell-to Customer No_] = [DEFDIM].[No_]
    AND [DEFDIM].[Dimension Code] = 'KÆDE'
    AND [DEFDIM].[Table ID] = 18
    AND [scmh].CompanyID = DEFDIM.CompanyID

    LEFT JOIN [etl].[OldCustomers] AS [OLDCUST]
    ON [scmh].[Sell-to Customer No_] = [OLDCUST].[OldCustomerNo]
    AND [scmh].[CompanyID] = [OLDCUST].[CompanyID]

    --Chain for Norway    
    LEFT JOIN [stg_bc].[DefaultDimension] AS NODIM
    ON OLDCUST.[NewCustomerNo] = [NODIM].[No_]
    AND [NODIM].[Dimension Code] = 'KÆDE'
    AND [NODIM].[Table ID] = 18
    AND [scmh].CompanyID = NODIM.CompanyID

    --SellToCustomer from current customer card
    --2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
    LEFT JOIN stg_navdb.Customer [CUST_SELLTO]
    ON [CUST_SELLTO].CompanyID = scmh.[CompanyID] 
    AND [CUST_SELLTO].No_ = [scmh].[Sell-to Customer No_]



    /*
    LEFT JOIN [etl].[NavChainLinked] AS [NAVCHAIN]
    ON [sih].[Sell-to Customer No_] = NAVCHAIN.NAV_CustomerNoFound
    AND [sih].[CompanyID] = NAVCHAIN.CustomerCompanyID
    */

    /* laguda
    OUTER APPLY
    (
        SELECT TOP(1)[c2].[ChainCode]
        FROM [dim].[Chain] AS [c2]
        WHERE [c2].[CompanyID] = [scml].[CompanyID]
        AND   LEFT([c2].[ChainName], 20) = [scmh].[Chain Group Code]
    ) AS [c2]
    OUTER APPLY
    (
        SELECT TOP(1)[cn].[No_]
                    ,[cn].[ChainGroup]
        FROM [stg_bc].[CustomerNotora] AS [cn]
        WHERE [cn].[CompanyID] = [scml].[CompanyID]
        AND   [cn].[Old Customer No_] = [scmh].[Sell-to Customer No_]
        ORDER BY [cn].[ChainGroup] DESC
    ) AS [cn]
    */
        --2024.09.04 AND   [scmh].[Applies-to Doc_ Type] = 2 maybe should be 3=CreditNote
        --AND   [scmh].[Applies-to Doc_ Type] = 3
    
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
        AND   [rs].[ADF_FactSource] = N'NAVDB_SalesCrMemoLine'
    ) AS [el]



    WHERE 
        [scml].[Type] IN (1, 2)
        AND [scml].[Posting Date] >= '20180101'
        AND [scml].[VAT Prod_ Posting Group] <> N'EKSPORT'
        AND (
            ([scml].[CompanyID] IN (1, 2) AND [scml].[Posting Date] < '20230301')
            OR ([scml].[CompanyID] NOT IN (1, 2))
        )
        AND (
            [scml].[Posting Date] >= @PostingFrom
            OR [scml].[timestamp] > @ts
            OR [scmh].[timestamp] > @ts
            OR @UpdateType IN (3, 31)
        );
END;

GO

