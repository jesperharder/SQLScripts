
CREATE PROCEDURE [etl].[GetRowsOpenSale_NavDb_SalesLine]
-- 2024.08 JH: Added Salesline lookup
(
    @LastTimestamp NVARCHAR(24) = N'0x',
    @UpdateType INT = 3
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Convert the last timestamp to binary format
    DECLARE @ts VARBINARY(8) = CAST(RIGHT(@LastTimestamp, LEN(@LastTimestamp) - 2) AS VARBINARY(8));
    -- Set the posting date to one month prior to the current date
    DECLARE @PostingFrom DATETIME = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0));

    SELECT 
        -- Basics
        [sl].[CompanyID],
        [sl].[Document Type],
        [sl].[Type],

        -- Keys
        [sl].[Document No_] AS [NK_SalesOrderNumber],
        [sl].[Location Code] AS [BK_Location],
        IIF([sl].[Type] = 2, [sl].[No_], NULL) AS [BK_ItemNo],
        IIF([sl].[Type] = 1, [sl].[No_], NULL) AS [BK_GL_AccountNo],
        [sh].[Sell-to Customer No_] AS [BK_CustomerNo],
        [c].[Country_Region Code] AS [BK_GeographyCustomerCountryRegionCode],
        [sh].[Sell-to Country_Region Code] AS [BK_GeographySellToCountryRegionCode],
        [sh].[Salesperson Code] AS [BK_EmployeeSalespersonCode],
        [sh].[Salesperson Code] AS [BK_TeamEmployeeCode],
        [sh].[Shipment Method Code] AS [BK_ShipmentMethodCode],
        [sl].[Campaign No_] AS [BK_CampaignNo],

        -- Date and Time
        CAST(NULLIF([sl].[Planned Delivery Date], '17530101') AS DATE) AS [BK_Date_PlannedDelivery],
        CAST([sh].[Order Date] AS DATE) AS [BK_Date_Intake],
        CAST([sh].[Posting Date] AS DATE) AS [BK_Date_Posting],
        CAST([sh].[Order Date] AS DATE) AS [BK_Date_Reporting],
        CAST([sh].[Order Date] AT TIME ZONE 'Romance Standard Time' AS TIME(0)) AS [BK_Time_Intake],
        CAST(DATEPART(tz, [sh].[Order Date] AT TIME ZONE 'Romance Standard Time') AS TINYINT) AS [BK_UTCOffsetMinutes_Intake],

        -- Currency
        [gls].[LCY Code] AS [BK_Currency_Company],
        CASE
            WHEN [sl].[Currency Code] = '' THEN [gls].[LCY Code]
            ELSE [sl].[Currency Code]
        END AS [BK_Currency_Document],

        -- Natural Keys
        [sl].[Line No_] AS [NK_DocumentLineNumber],

        -- Dimension
        [sl].[Gen_ Bus_ Posting Group],
        [sl].[Gen_ Prod_ Posting Group],
        NULLIF([sl].[Shortcut Dimension 1 Code], '') AS [BK_Department],
        CASE
            WHEN [sl].CompanyID = 2 THEN NULLIF([NODIM].[Dimension Value Code], N'') 
            ELSE NULLIF([DEFDIM].[Dimension Value Code], N'') 
        END AS [BK_ChainCode],

        -- Values
        CAST([sl].[Quantity] AS DECIMAL(18, 4)) AS [M_Quantity],
        CAST([sl].[Quantity Invoiced] AS DECIMAL(18, 4)) AS [M_QuantityInvoiced],
        CAST([sl].[Outstanding Quantity] AS DECIMAL(18, 4)) AS [M_OutstandingQuantity],
        CAST([sl].[Shipped Not Invoiced] AS DECIMAL(18, 4)) AS [M_QuantityShippedNotInvoiced],
        CAST([sl].[Unit Cost] AS DECIMAL(18, 4)) AS [M_UnitCost],
        CAST([sl].[Unit Cost (LCY)] AS DECIMAL(18, 4)) AS [M_UnitCost_LCY],
        CAST([sl].[Line Amount] * (100 / (100 + [sl].[VAT %])) AS DECIMAL(18, 4)) AS [M_Amount],
        CAST([sl].[Quantity] * [sl].[Unit Cost] AS DECIMAL(18, 4)) AS [M_COGS],
        CAST(([sl].[Amount] * (100 / (100 + [sl].[VAT %]))) - ([sl].[Quantity] * [sl].[Unit Cost]) AS DECIMAL(18, 4)) AS [M_GM],
        CAST(CAST([sl].[Line Amount] * (100 / (100 + [sl].[VAT %])) AS DECIMAL(38, 6)) / CAST(ISNULL(NULLIF([sh].[Currency Factor], 0.0), 1.0) AS DECIMAL(38, 6)) AS DECIMAL(18, 4)) AS [M_Amount_LCY],
        CAST([sl].[Quantity] * [sl].[Unit Cost (LCY)] AS DECIMAL(18, 4)) AS [M_COGS_LCY],
        CAST((CAST([sl].[Amount] * (100 / (100 + [sl].[VAT %])) AS DECIMAL(38, 6)) / CAST(ISNULL(NULLIF([sh].[Currency Factor], 0.0), 1.0) AS DECIMAL(38, 6))) - ([sl].[Quantity] * [sl].[Unit Cost (LCY)]) AS DECIMAL(18, 4)) AS [M_GM_LCY],
        CAST([sl].[Outstanding Amount] * (100 / (100 + [sl].[VAT %])) AS DECIMAL(18, 4)) AS [M_OutstandingAmount],
        CAST([sl].[Outstanding Quantity] * [sl].[Unit Cost] AS DECIMAL(18, 4)) AS [M_Outstanding_COGS],
        CAST(([sl].[Outstanding Amount] * (100 / (100 + [sl].[VAT %]))) - ([sl].[Outstanding Quantity] * [sl].[Unit Cost]) AS DECIMAL(18, 4)) AS [M_Outstanding_GM],
        CAST([sl].[Outstanding Amount (LCY)] * (100 / (100 + [sl].[VAT %])) AS DECIMAL(18, 4)) AS [M_OutstandingAmount_LCY],
        CAST([sl].[Outstanding Quantity] * [sl].[Unit Cost (LCY)] AS DECIMAL(18, 4)) AS [M_Outstanding_COGS_LCY],
        CAST(([sl].[Outstanding Amount (LCY)] * (100 / (100 + [sl].[VAT %]))) - ([sl].[Outstanding Quantity] * [sl].[Unit Cost (LCY)]) AS DECIMAL(18, 4)) AS [M_Outstanding_GM_LCY],
        CAST((100 / (100 + [sl].[VAT %])) AS DECIMAL(18, 4)) AS [M_VAT_NetFactor],
        CAST([sh].[Currency Factor] AS DECIMAL(18, 4)) AS [M_CurrencyFactor],

        -- Source
        CAST(N'NAV_SalesLine' AS NVARCHAR(128)) AS [ADF_FactSource]

    FROM [stg_navdb].[SalesLine] AS [sl]
    INNER JOIN [stg_navdb].[SalesHeader] AS [sh]
        ON [sh].[CompanyID] = [sl].[CompanyID]
        AND [sh].[No_] = [sl].[Document No_]
    INNER JOIN [stg_navdb].[Customer] AS [c]
        ON [c].[CompanyID] = [sl].[CompanyID]
        AND [c].[No_] = [sh].[Sell-to Customer No_]
    LEFT JOIN [stg_navdb].[GeneralLedgerSetup] AS [gls]
        ON [sl].[CompanyID] = [gls].[CompanyID]
    LEFT JOIN [stg_navdb].[DefaultDimension] AS DEFDIM
        ON [sh].[Sell-to Customer No_] = [DEFDIM].[No_]
        AND [DEFDIM].[Dimension Code] = 'KÆDE'
        AND [DEFDIM].[Table ID] = 18
        AND [sh].[CompanyID] = [DEFDIM].[CompanyID]
    LEFT JOIN [etl].[OldCustomers] AS [OLDCUST]
        ON [sh].[Sell-to Customer No_] = [OLDCUST].[OldCustomerNo]
        AND [sh].[CompanyID] = [OLDCUST].[CompanyID]
    LEFT JOIN [stg_bc].[DefaultDimension] AS NODIM
        ON [OLDCUST].[NewCustomerNo] = [NODIM].[No_]
        AND [NODIM].[Dimension Code] = 'KÆDE'
        AND [NODIM].[Table ID] = 18
        AND [sh].[CompanyID] = [NODIM].[CompanyID]

    WHERE 0 = 0
    AND [sl].[CompanyID] IN (3, 4);

END;

GO

