CREATE PROCEDURE [etl_v1].[GetRowsFactRealisedSale_BC_SalesCrMemoLine]
(
    @LastTimestamp nvarchar(50) = N'0x',
    @UpdateType int = 3
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LastModifiedAt datetimeoffset(7) = TRY_CONVERT(datetimeoffset(7), NULLIF(@LastTimestamp, N'0x'));
    DECLARE @PostingFrom date = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0));

    SELECT
        scmh.[CompanyId] AS [CompanyID],
        NULLIF(scml.[shortcutDim1Code], N'') AS [BK_Department],
        CONVERT(varbinary(8), 0) AS [timestamp],
        TRIM(CAST(scmh.[sellToCustomerNo] AS nvarchar(20))) AS [BK_Customer],
        TRIM(scmh.[sellToPostCode]) AS [BK_PostCode],
        CASE
            WHEN ISNULL(scmh.[sellToCountryRegionCode], N'') = N'' THEN ci.[countryRegionCode]
            ELSE scmh.[sellToCountryRegionCode]
        END AS [BK_Customer_Geography_Country],
        CAST(IIF(scml.[typeInt] = 2, scml.[no], NULL) AS nvarchar(20)) AS [BK_Item],
        ISNULL(NULLIF(sih.[orderNo], N''), N'Blank') AS [BK_SalesOrder],
        scmh.[documentDate] AS [BK_Date_Intake],
        scmh.[salespersonCode] AS [BK_SalesPerson],
        CAST(NULL AS nvarchar(20)) AS [BK_SalesPerson_SellToCustomer],
        ISNULL(NULLIF(scmh.[currencyCode], N''), gls.[lcyCode]) AS [BK_Currency_Document],
        gls.[lcyCode] AS [BK_Currency_Company],
        CASE
            WHEN ISNULL(scmh.[currencyCode], N'') = N'' THEN gls.[lcyCode]
            ELSE scmh.[currencyCode]
        END AS [BK_Currency_ExchangeRate],
        CONVERT(date, scmh.[postingDate]) AS [BK_Date_Posting],
        CAST(scmh.[postingDate] AS date) AS [BKFinaceVoucherPostingDate],
        CASE
            WHEN scmh.[postingDate] > GETDATE() THEN DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
            ELSE scmh.[postingDate]
        END AS [BK_Date_ExchangeRate],
        N'' AS [BK_CampaignNo],
        scml.[documentNo] AS [NK_DocumentNumber],
        scml.[lineNo] AS [NK_DocumentLineNumber],
        CAST(CASE WHEN scml.[typeInt] = 1 THEN scml.[no] ELSE NULL END AS nvarchar(100)) AS [BK_FinanceAccount],
        CAST(N'Credit Memo' AS nvarchar(50)) AS [BK_FinanceVoucherDocumentType],
        CONVERT(nvarchar(10), N'SALG') AS [BK_FinanceVoucherSourceCode],
        scmh.[shippingAgentCode] AS [BK_DeliveryMethod],
        scml.[locationCode] AS [BK_Location],
        scml.[genBusPostingGroup] AS [BK_GenBusPostingGroup],
        scml.[genProdPostingGroup] AS [BK_GenProdPostingGroup],
        ISNULL(NULLIF(scml.[returnReasonCode], N''), N'ALMSALG') AS [BK_ReturnReasonCode],
        scmh.[shipmentMethodCode] AS [BK_ShipmentMethodCode],
        scml.[yearcodeText] AS [BK_YearCodeText],
        NULLIF(currCustomerChain.[dimensionValueCode], N'') AS [BK_ChainCode],
        -CAST(IIF(scml.[typeInt] = 2, scml.[quantity], 0) AS decimal(18, 4)) AS [M_Quantity],
        CAST(scml.[unitCost] AS decimal(18, 4)) AS [M_UnitCost],
        CAST(scml.[unitCostLCY] AS decimal(18, 4)) AS [M_UnitCost_LCY],
        -CAST(scml.[amount] AS decimal(18, 4)) AS [M_Amount],
        -CAST(scml.[quantity] * scml.[unitCost] AS decimal(18, 4)) AS [M_COGS],
        -CAST(scml.[amount] - (scml.[quantity] * scml.[unitCost]) AS decimal(18, 4)) AS [M_GM],
        -CAST(CAST(scml.[amount] AS decimal(38, 6)) / CAST(ISNULL(NULLIF(scmh.[currencyFactor], 0.0), 1.0) AS decimal(38, 15)) AS decimal(18, 4)) AS [M_Amount_LCY],
        -CAST(scml.[quantity] * scml.[unitCostLCY] AS decimal(18, 4)) AS [M_COGS_LCY],
        -CAST((CAST(scml.[amount] AS decimal(38, 6)) / CAST(ISNULL(NULLIF(scmh.[currencyFactor], 0.0), 1.0) AS decimal(38, 15))) - (scml.[quantity] * scml.[unitCostLCY]) AS decimal(18, 4)) AS [M_GM_LCY],
        CAST(ISNULL(NULLIF(scmh.[currencyFactor], 0.0), 1.0) AS decimal(18, 15)) AS [M_CurrencyFactor],
        CAST(N'BC_SalesCrMemoLine' AS nvarchar(128)) AS [ADF_FactSource],
        existingLine.[UpdatedRow]
    FROM [stg_bc_api].[SalesCrMemoLine] AS scml
    INNER JOIN [stg_bc_api].[SalesCrMemoHeader] AS scmh
        ON scmh.[CompanyId] = scml.[CompanyId]
       AND scmh.[no] = scml.[documentNo]
    INNER JOIN [stg_bc_api].[CompanyInformation] AS ci
        ON ci.[CompanyId] = scml.[CompanyId]
    LEFT JOIN [stg_bc_api].[GeneralLedgerSetup] AS gls
        ON gls.[CompanyId] = scml.[CompanyId]
    LEFT JOIN [stg_bc_api].[SalesInvHeader] AS sih
        ON sih.[CompanyId] = scmh.[CompanyId]
       AND sih.[no] = scmh.[appliesToDocNo]
    OUTER APPLY
    (
        SELECT IIF(COUNT(*) > 0, 1, 0) AS [UpdatedRow]
        FROM [fct_v1].[RealisedSale] AS rs
        WHERE rs.[NK_PostingDate] = scmh.[postingDate]
          AND rs.[CompanyID] = scml.[CompanyId]
          AND rs.[NK_SalesOrderNumber] = ISNULL(NULLIF(sih.[orderNo], N''), N'Blank')
          AND rs.[NK_DocumentNumber] = scml.[documentNo]
          AND rs.[NK_DocumentLineNumber] = scml.[lineNo]
          AND rs.[NK_LineEntryType] = N'Credit Memo'
          AND rs.[ADF_FactSource] = N'BC_SalesCrMemoLine'
    ) AS existingLine
    LEFT JOIN [stg_bc_api].[DefaultDimension] AS currCustomerChain
        ON currCustomerChain.[CompanyId] = scmh.[CompanyId]
       AND currCustomerChain.[tableId] = 18
       AND currCustomerChain.[dimensionCode] = N'KÆDE'
       AND currCustomerChain.[no] = scmh.[sellToCustomerNo]
    WHERE scml.[typeInt] IN (1, 2)
      AND scml.[vatProdPostingGroup] <> N'EKSPORT'
      AND (
            scmh.[postingDate] >= @PostingFrom
         OR @LastModifiedAt IS NULL
         OR scml.[systemModifiedAt] > @LastModifiedAt
         OR scmh.[systemModifiedAt] > @LastModifiedAt
         OR @UpdateType IN (3, 31)
      );
END;

GO
