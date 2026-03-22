CREATE   PROCEDURE [etl].[GetRowsOpenSale_BC_SalesLine]

--2024.08 JH: Added Salesline lookup
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
        [sl].[CompanyID]
      ,[sl].[Document Type]
      ,[sl].[Type]

--Keys
      ,[sl].[Document No_] AS [NK_SalesOrderNumber]
      ,[sl].[Location Code] AS [BK_Location]
      ,IIF([sl].[Type] = 2, [sl].[No_], NULL) AS [BK_ItemNo]
      ,IIF([sl].[Type] = 1, [sl].[No_], NULL) AS [BK_GL_AccountNo]
      ,[sh].[Sell-to Customer No_] AS [BK_CustomerNo]
      ,[c].[Country_Region Code] AS [BK_GeographyCustomerCountryRegionCode]
      ,[sh].[Sell-to Country_Region Code] as [BK_GeographySellToCountryRegionCode]
      ,[sh].[Salesperson Code] AS [BK_EmployeeSalespersonCode]
      ,[sh].[Salesperson Code] AS [BK_TeamEmployeeCode]
      ,[sh].[Shipment Method Code] AS [BK_ShipmentMethodCode]
      ,[sl].[Used Campaign NOTO] AS [BK_CampaignNo]

--Date and Time
      ,CAST(NULLIF([sl].[Planned Delivery Date], '17530101') AS date) AS [BK_Date_PlannedDelivery]
      ,CAST([sh].[Order Date] AS date) AS [BK_Date_Intake]
      ,CAST([sh].[Posting Date] AS date) AS [BK_Date_Posting]
      ,CAST([sh].[Order Date] AS date) AS [BK_Date_Reporting]
      ,CAST([sh].[Order Date] AT TIME ZONE 'Romance Standard Time' AS time(0)) AS [BK_Time_Intake]
      ,CAST(DATEPART(tz, [sh].[Order Date] AT TIME ZONE 'Romance Standard Time') AS tinyint) AS [BK_UTCOffsetMinutes_Intake]

--Currency
      ,[gls].[LCY Code] AS [BK_Currency_Company]
      ,CASE
           WHEN [sl].[Currency Code] = '' THEN
               [gls].[LCY Code]
           ELSE
               [sl].[Currency Code]
       END AS [BK_Currency_Document]

--Natural Keys
      ,[sl].[Line No_] AS [NK_DocumentLineNumber]


--Dimension
      ,[sl].[Gen_ Bus_ Posting Group]
      ,[sl].[Gen_ Prod_ Posting Group]
      ,[dims].[AD HOC]
      ,[dims].[AFDELING]
      ,[dims].[KÆDE]
      ,[dims].[LAND]
      ,[dims].[LEVERANDØR]
      ,[dims].[MARKEDSF]
      ,[dims].[PERSONALE]
      ,[dims].[VEDLIGEH]

--Values
      ,CAST([sl].[Quantity] AS decimal(18, 4)) AS [M_Quantity]
      ,CAST([sl].[Quantity Invoiced] AS decimal(18, 4)) AS [M_QuantityInvoiced]
      ,CAST([sl].[Outstanding Quantity] AS decimal(18, 4)) AS [M_OutstandingQuantity]
      ,CAST([sl].[Shipped Not Invoiced] AS decimal(18, 4)) AS [M_QuantityShippedNotInvoiced]
      ,CAST([sl].[Unit Cost] AS decimal(18, 4)) AS [M_UnitCost]
      ,CAST([sl].[Unit Cost (LCY)] AS decimal(18, 4)) AS [M_UnitCost_LCY]
      ,CAST([sl].[Line Amount] * (100 / (100 + [sl].[VAT _])) AS decimal(18, 4)) AS [M_Amount]
      ,CAST([sl].[Quantity] * [sl].[Unit Cost] AS decimal(18, 4)) AS [M_COGS]
      ,CAST(([sl].[Amount] * (100 / (100 + [sl].[VAT _]))) - ([sl].[Quantity] * [sl].[Unit Cost]) AS decimal(18, 4)) AS [M_GM]
      ,CAST(CAST([sl].[Line Amount] * (100 / (100 + [sl].[VAT _])) AS decimal(38, 6)) / CAST(ISNULL(NULLIF([sh].[Currency Factor], 0.0), 1.0) AS decimal(38, 6)) AS decimal(18, 4)) AS [M_Amount_LCY]
      ,CAST([sl].[Quantity] * [sl].[Unit Cost (LCY)] AS decimal(18, 4)) AS [M_COGS_LCY]
      ,CAST((CAST([sl].[Amount] * (100 / (100 + [sl].[VAT _])) AS decimal(38, 6)) / CAST(ISNULL(NULLIF([sh].[Currency Factor], 0.0), 1.0) AS decimal(38, 6))) - ([sl].[Quantity] * [sl].[Unit Cost (LCY)]) AS decimal(18, 4)) AS [M_GM_LCY]
      ,CAST([sl].[Outstanding Amount] * (100 / (100 + [sl].[VAT _])) AS decimal(18, 4)) AS [M_OutstandingAmount]
      ,CAST([sl].[Outstanding Quantity] * [sl].[Unit Cost] AS decimal(18, 4)) AS [M_Outstanding_COGS]
      ,CAST(([sl].[Outstanding Amount] * (100 / (100 + [sl].[VAT _]))) - ([sl].[Outstanding Quantity] * [sl].[Unit Cost]) AS decimal(18, 4)) AS [M_Outstanding_GM]
      ,CAST([sl].[Outstanding Amount (LCY)] * (100 / (100 + [sl].[VAT _])) AS decimal(18, 4)) AS [M_OutstandingAmount_LCY]
      ,CAST([sl].[Outstanding Quantity] * [sl].[Unit Cost (LCY)] AS decimal(18, 4)) AS [M_Outstanding_COGS_LCY]
      ,CAST(([sl].[Outstanding Amount (LCY)] * (100 / (100 + [sl].[VAT _]))) - ([sl].[Outstanding Quantity] * [sl].[Unit Cost (LCY)]) AS decimal(18, 4)) AS [M_Outstanding_GM_LCY]
      ,CAST((100 / (100 + [sl].[VAT _])) AS decimal(18, 4)) AS [M_VAT_NetFactor]
      ,CAST([sh].[Currency Factor] AS decimal(18, 4)) AS [M_CurrencyFactor]


--Source
      ,CAST(N'BL_SalesLine' AS nvarchar(128)) AS [ADF_FactSource]

FROM [stg_bc].[SalesLine] AS [sl]
INNER JOIN [stg_bc].[SalesHeader] AS [sh]
ON  [sh].[CompanyID] = [sl].[CompanyID]
AND [sh].[No_] = [sl].[Document No_]
INNER JOIN [stg_bc].[Customer] AS [c]
ON  [c].[CompanyID] = [sl].[CompanyID]
AND [c].[No_] = [sh].[Sell-to Customer No_]
LEFT JOIN [stg_bc].[GeneralLedgerSetup] AS [gls]
ON [sl].[CompanyID] = [gls].[CompanyID]
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
        WHERE [dse].[Dimension Set ID] = [sl].[Dimension Set ID]
        AND   [dse].[CompanyID] = [sl].[CompanyID]
    ) AS [scr]
    PIVOT
    (
        MAX([Dimension Value Code])
        FOR [Dimension Code] IN([AD HOC], [AFDELING], [KÆDE], [LAND], [LEVERANDØR], [MARKEDSF.], [PERSONALE], [VEDLIGEH.])
    ) AS [pvt]
) AS [dims];

END;

GO

