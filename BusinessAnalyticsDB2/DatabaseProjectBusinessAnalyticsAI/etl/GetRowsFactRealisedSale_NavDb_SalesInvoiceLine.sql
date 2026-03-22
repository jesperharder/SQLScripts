CREATE   PROCEDURE [etl].[GetRowsFactRealisedSale_NavDb_SalesInvoiceLine]

--2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
--2024.07.31JH:     Added CampaignNo
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

    SELECT
        --Basics
        [sih].[CompanyID]
       ,NULLIF([sil].[Shortcut Dimension 1 Code], '') AS [BK_Department]
       ,(
            SELECT MAX([value].[v])FROM(VALUES([sil].[timestamp]), ([sih].[timestamp])) AS [value]([v])
        ) AS [timestamp]

       --Customer
       -- laguda ,ISNULL([cn].[No_], [sih].[Sell-to Customer No_]) AS [BK_Customer]
       --fix1,ISNULL(NAVCHAIN.CustomerNo,'') AS [BK_Customer]
       ,TRIM(cast(ISNULL([OLDCUST].[NewCustomerNo], [sih].[Sell-to Customer No_]) as nvarchar(20))) AS [BK_Customer]

       -- CustomerGeographyKey, Composed by:
       ,TRIM([sih].[Sell-to Post Code]) AS [BK_PostCode]
       ,IIF([cr].[ISO A2] IS NULL, [ci].[Country_Region Code], [cr].[ISO A2]) AS [BK_Customer_Geography_Country]

       --Item
       ,CAST(CASE
                 WHEN [sil].[Type] = 2 THEN
                     [sil].[No_]
                 ELSE
                     NULL
             END AS nvarchar(20)) AS [BK_Item]

       --Order
       ,[sih].[Order No_] AS [BK_SalesOrder]
       ,[sih].[Order Date] AS [BK_Date_Intake]
       ,ISNULL(NULLIF([sih].[Salesperson Code], N''), [c].[Salesperson Code]) AS [BK_SalesPerson]
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
       ,[sil].[Yearcode Text] as [BK_YearCodeText]
       --LAGUDA ,NULLIF(ISNULL([cn].[ChainGroup], [c2].[ChainCode]), N'') AS [BK_ChainCode]
       --fix1 ,NULLIF(NAVCHAIN.[BC_Dimension Value Code], N'') AS [BK_ChainCode]
       --,NULLIF([DEFDIM].[Dimension Value Code], N'') AS [BK_ChainCode]
              ,CASE WHEN [sil].CompanyID = 2 THEN
                   NULLIF([NODIM].[Dimension Value Code], N'') 
                ELSE
                   NULLIF([DEFDIM].[Dimension Value Code], N'') 
            END AS [BK_ChainCode]

        --Campaign 2024.07.31
        ,CASE 
            WHEN [sil].[Campaign No_] = '' THEN 'No Campaign' 
            ELSE [sil].[Campaign No_] 
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
       ,CAST(N'NAVDB_SalesInvoiceLine' AS nvarchar(128)) AS [ADF_FactSource]
       ,[el].[UpdatedRow]
    FROM [stg_navdb].[SalesInvoiceLine] AS [sil]
    INNER JOIN [stg_navdb].[SalesInvoiceHeader] AS [sih]
    ON  [sil].[CompanyID] = [sih].[CompanyID]
    AND [sil].[Document No_] = [sih].[No_]
    INNER JOIN [stg_navdb].[CompanyInformation] AS [ci]
    ON [ci].[CompanyID] = [sil].[CompanyID]
    INNER JOIN [stg_navdb].[GeneralLedgerSetup] AS [gls]
    ON [sil].[CompanyID] = [gls].[CompanyID]
    INNER JOIN [stg_navdb].[Customer] AS [c]
    ON  [c].[CompanyID] = [sil].[CompanyID]
    AND [c].[No_] = [sih].[Sell-to Customer No_]
    LEFT JOIN [stg_navdb].[CountryRegion] AS [cr]
    ON  [cr].[CompanyID] = [sil].[CompanyID]
    AND [cr].[Code] = [sih].[Sell-to Country_Region Code]

    /*
    LEFT JOIN [etl].[NavChainLinked] AS [NAVCHAIN]
    ON [sil].[Sell-to Customer No_] = NAVCHAIN.NAV_CustomerNoFound
    AND [sil].[CompanyID] = NAVCHAIN.CustomerCompanyID
    */

    LEFT JOIN [stg_navdb].[DefaultDimension] AS DEFDIM
    ON [sih].[Sell-to Customer No_] = [DEFDIM].[No_]
    AND [DEFDIM].[Dimension Code] = 'KÆDE'
    AND [DEFDIM].[Table ID] = 18
    AND [sih].CompanyID = DEFDIM.CompanyID

    LEFT JOIN [etl].[OldCustomers] AS [OLDCUST]
    ON [sih].[Sell-to Customer No_] = [OLDCUST].[OldCustomerNo]
    AND [sih].[CompanyID] = [OLDCUST].[CompanyID]

    --Chain for Norway    
    LEFT JOIN [stg_bc].[DefaultDimension] AS NODIM
    ON OLDCUST.[NewCustomerNo] = [NODIM].[No_]
    AND [NODIM].[Dimension Code] = 'KÆDE'
    AND [NODIM].[Table ID] = 18
    AND [sih].CompanyID = NODIM.CompanyID

    /* laguda
    OUTER APPLY
    (
        SELECT TOP(1)[c2].[ChainCode]
        FROM [dim].[Chain] AS [c2]
        WHERE [c2].[CompanyID] = [sil].[CompanyID]
        AND   LEFT([c2].[ChainName], 20) = [sih].[Chain Group Code]
    ) AS [c2]
    OUTER APPLY
    (
        SELECT TOP(1)[cn].[No_]
                    ,[cn].[ChainGroup]
        FROM [stg_bc].[CustomerNotora] AS [cn]
        WHERE [cn].[CompanyID] = [sil].[CompanyID]
        AND   [cn].[Old Customer No_] = [sih].[Sell-to Customer No_]
        ORDER BY [cn].[ChainGroup] DESC
    ) AS [cn]
    */


    --2024.05.24JH:     Added CustomerTable for lookup to current Sell-To salesperson
    LEFT JOIN stg_navdb.Customer [CUST_SELLTO]
    ON [CUST_SELLTO].CompanyID = SIH.[CompanyID] 
    AND [CUST_SELLTO].No_ = [sih].[Sell-to Customer No_]


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
        AND   [rs].[ADF_FactSource] = N'NAVDB_SalesInvoiceLine'
    ) AS [el]
    WHERE 
        [sil].[Type] IN (1, 2)
        AND [sil].[Posting Date] >= '20180101'
        AND [sil].[VAT Prod_ Posting Group] <> N'EKSPORT'
        AND (
            ([sil].[CompanyID] IN (1, 2) AND [sil].[Posting Date] < '20230301')
            OR ([sil].[CompanyID] NOT IN (1, 2))
        )
        AND (
            [sil].[Posting Date] >= @PostingFrom
            OR [sil].[timestamp] > @ts
            OR [sih].[timestamp] > @ts
            OR @UpdateType IN (3, 31)
        );
END;

GO

