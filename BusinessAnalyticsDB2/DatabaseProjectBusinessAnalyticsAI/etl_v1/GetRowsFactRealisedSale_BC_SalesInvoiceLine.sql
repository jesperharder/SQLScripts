CREATE PROCEDURE [etl_v1].[GetRowsFactRealisedSale_BC_SalesInvoiceLine]
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
        sih.[CompanyId] AS [CompanyID],
        NULLIF(sil.[shortcutDim1Code], N'') AS [BK_Department],
        CONVERT(varbinary(8), 0) AS [timestamp],
        TRIM(CAST(sih.[sellToCustomerNo] AS nvarchar(20))) AS [BK_Customer],
        TRIM(sih.[sellToPostCode]) AS [BK_PostCode],
        CASE
            WHEN ISNULL(sih.[sellToCountryRegionCode], N'') = N'' THEN ci.[countryRegionCode]
            ELSE sih.[sellToCountryRegionCode]
        END AS [BK_Customer_Geography_Country],
        CAST(IIF(sil.[typeInt] = 2, sil.[no], NULL) AS nvarchar(20)) AS [BK_Item],
        sih.[orderNo] AS [BK_SalesOrder],
        sih.[orderDate] AS [BK_Date_Intake],
        sih.[salespersonCode] AS [BK_SalesPerson],
        CAST(NULL AS nvarchar(20)) AS [BK_SalesPerson_SellToCustomer],
        ISNULL(NULLIF(sih.[currencyCode], N''), gls.[lcyCode]) AS [BK_Currency_Document],
        gls.[lcyCode] AS [BK_Currency_Company],
        CASE
            WHEN ISNULL(sih.[currencyCode], N'') = N'' THEN gls.[lcyCode]
            ELSE sih.[currencyCode]
        END AS [BK_Currency_ExchangeRate],
        CONVERT(date, sih.[postingDate]) AS [BK_Date_Posting],
        CAST(sih.[postingDate] AS date) AS [BKFinaceVoucherPostingDate],
        CASE
            WHEN sih.[postingDate] > GETDATE() THEN DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
            ELSE sih.[postingDate]
        END AS [BK_Date_ExchangeRate],
        sil.[documentNo] AS [NK_DocumentNumber],
        sil.[lineNo] AS [NK_DocumentLineNumber],
        CAST(CASE WHEN sil.[typeInt] = 1 THEN sil.[no] ELSE NULL END AS nvarchar(100)) AS [BK_FinanceAccount],
        CAST(N'Invoice' AS nvarchar(50)) AS [BK_FinanceVoucherDocumentType],
        CONVERT(nvarchar(10), N'SALG') AS [BK_FinanceVoucherSourceCode],
        sih.[shippingAgentCode] AS [BK_DeliveryMethod],
        sil.[locationCode] AS [BK_Location],
        sil.[genBusPostingGroup] AS [BK_GenBusPostingGroup],
        sil.[genProdPostingGroup] AS [BK_GenProdPostingGroup],
        ISNULL(NULLIF(sil.[returnReasonCode], N''), N'ALMSALG') AS [BK_ReturnReasonCode],
        sih.[shipmentMethodCode] AS [BK_ShipmentMethodCode],
        NULLIF(currCustomerChain.[dimensionValueCode], N'') AS [BK_ChainCode],
        sil.[yearCodeText] AS [BK_YearCodeText],
        CASE
            WHEN ISNULL(sih.[campaignNo], N'') = N'' THEN N'No Campaign'
            ELSE sih.[campaignNo]
        END AS [BK_CampaignNo],
        CAST(IIF(sil.[typeInt] = 2, sil.[quantity], 0) AS decimal(18, 4)) AS [M_Quantity],
        CAST(sil.[unitCost] AS decimal(18, 4)) AS [M_UnitCost],
        CAST(sil.[unitCostLCY] AS decimal(18, 4)) AS [M_UnitCost_LCY],
        CAST(sil.[amount] AS decimal(18, 4)) AS [M_Amount],
        CAST(sil.[quantity] * sil.[unitCost] AS decimal(18, 4)) AS [M_COGS],
        CAST(sil.[amount] - (sil.[quantity] * sil.[unitCost]) AS decimal(18, 4)) AS [M_GM],
        CAST(CAST(sil.[amount] AS decimal(38, 6)) / CAST(ISNULL(NULLIF(sih.[currencyFactor], 0.0), 1.0) AS decimal(38, 15)) AS decimal(18, 4)) AS [M_Amount_LCY],
        CAST(sil.[quantity] * sil.[unitCostLCY] AS decimal(18, 4)) AS [M_COGS_LCY],
        CAST((CAST(sil.[amount] AS decimal(38, 6)) / CAST(ISNULL(NULLIF(sih.[currencyFactor], 0.0), 1.0) AS decimal(38, 15))) - (sil.[quantity] * sil.[unitCostLCY]) AS decimal(18, 4)) AS [M_GM_LCY],
        CAST(ISNULL(NULLIF(sih.[currencyFactor], 0.0), 1.0) AS decimal(18, 15)) AS [M_CurrencyFactor],
        CAST(N'BC_SalesInvoiceLine' AS nvarchar(128)) AS [ADF_FactSource],
        existingLine.[UpdatedRow]
    FROM [stg_bc_api].[SalesInvLine] AS sil
    INNER JOIN [stg_bc_api].[SalesInvHeader] AS sih
        ON sih.[CompanyId] = sil.[CompanyId]
       AND sih.[no] = sil.[documentNo]
    INNER JOIN [stg_bc_api].[CompanyInformation] AS ci
        ON ci.[CompanyId] = sil.[CompanyId]
    LEFT JOIN [stg_bc_api].[GeneralLedgerSetup] AS gls
        ON gls.[CompanyId] = sil.[CompanyId]
    OUTER APPLY
    (
        SELECT IIF(COUNT(*) > 0, 1, 0) AS [UpdatedRow]
        FROM [fct_v1].[RealisedSale] AS rs
        WHERE rs.[NK_PostingDate] = sih.[postingDate]
          AND rs.[CompanyID] = sil.[CompanyId]
          AND rs.[NK_SalesOrderNumber] = sih.[orderNo]
          AND rs.[NK_DocumentNumber] = sil.[documentNo]
          AND rs.[NK_DocumentLineNumber] = sil.[lineNo]
          AND rs.[NK_LineEntryType] = N'Invoice'
          AND rs.[ADF_FactSource] = N'BC_SalesInvoiceLine'
    ) AS existingLine
    LEFT JOIN [stg_bc_api].[DefaultDimension] AS currCustomerChain
        ON currCustomerChain.[CompanyId] = sih.[CompanyId]
       AND currCustomerChain.[tableId] = 18
       AND currCustomerChain.[dimensionCode] = N'KÆDE'
       AND currCustomerChain.[no] = sih.[sellToCustomerNo]
    WHERE sil.[typeInt] IN (1, 2)
      AND sil.[vatProdPostingGroup] <> N'EKSPORT'
      AND (
            sih.[postingDate] >= @PostingFrom
         OR @LastModifiedAt IS NULL
         OR sil.[systemModifiedAt] > @LastModifiedAt
         OR sih.[systemModifiedAt] > @LastModifiedAt
         OR @UpdateType IN (3, 31)
      );
END;

GO
