SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#bc') IS NOT NULL DROP TABLE #bc;
IF OBJECT_ID('tempdb..#api') IS NOT NULL DROP TABLE #api;
IF OBJECT_ID('tempdb..#extra_api') IS NOT NULL DROP TABLE #extra_api;

SELECT
    [CompanyID],
    [Document Type] AS [DocumentType],
    [Document No_] AS [DocumentNo],
    [Line No_] AS [LineNo],
    [Quantity],
    [Quantity Invoiced] AS [QuantityInvoiced],
    [Outstanding Quantity] AS [OutstandingQuantity],
    [Shipped Not Invoiced] AS [QtyShippedNotInvoiced],
    [Line Amount] AS [LineAmount],
    [Outstanding Amount] AS [OutstandingAmount]
INTO #bc
FROM [stg_bc].[SalesLine]
WHERE [CompanyID] = 1;

SELECT
    [CompanyId] AS [CompanyID],
    [documentTypeInt] AS [DocumentType],
    [documentNo] AS [DocumentNo],
    [lineNo] AS [LineNo],
    [quantity] AS [Quantity],
    [quantityInvoiced] AS [QuantityInvoiced],
    [outstandingQuantity] AS [OutstandingQuantity],
    [qtyShippedNotInvoiced] AS [QtyShippedNotInvoiced],
    [lineAmount] AS [LineAmount],
    [outstandingAmount] AS [OutstandingAmount]
INTO #api
FROM [stg_bc_api].[SalesLine]
WHERE [CompanyId] = 1;

SELECT a.*
INTO #extra_api
FROM #api a
LEFT JOIN #bc b
    ON b.[CompanyID] = a.[CompanyID]
   AND b.[DocumentNo] = a.[DocumentNo]
   AND b.[LineNo] = a.[LineNo]
WHERE b.[CompanyID] IS NULL;

WITH header_compare AS
(
    SELECT
        eo.[DocumentNo],
        CASE WHEN bch.[No_] IS NULL THEN 0 ELSE 1 END AS [ExistsIn_stg_bc_Header],
        CASE WHEN apih.[no] IS NULL THEN 0 ELSE 1 END AS [ExistsIn_stg_bc_api_Header]
    FROM (SELECT DISTINCT [DocumentNo] FROM #extra_api) eo
    LEFT JOIN [stg_bc].[SalesHeader] bch
        ON bch.[CompanyID] = 1
       AND bch.[No_] = eo.[DocumentNo]
    LEFT JOIN [stg_bc_api].[SalesHeader] apih
        ON apih.[CompanyId] = 1
       AND apih.[no] = eo.[DocumentNo]
),
matched AS
(
    SELECT
        a.[DocumentNo],
        a.[LineNo],
        b.[DocumentType] AS [bc_DocumentType],
        a.[DocumentType] AS [api_DocumentType],
        b.[Quantity] AS [bc_Quantity],
        a.[Quantity] AS [api_Quantity],
        b.[QuantityInvoiced] AS [bc_QuantityInvoiced],
        a.[QuantityInvoiced] AS [api_QuantityInvoiced],
        b.[OutstandingQuantity] AS [bc_OutstandingQuantity],
        a.[OutstandingQuantity] AS [api_OutstandingQuantity],
        b.[QtyShippedNotInvoiced] AS [bc_QtyShippedNotInvoiced],
        a.[QtyShippedNotInvoiced] AS [api_QtyShippedNotInvoiced],
        b.[LineAmount] AS [bc_LineAmount],
        a.[LineAmount] AS [api_LineAmount],
        b.[OutstandingAmount] AS [bc_OutstandingAmount],
        a.[OutstandingAmount] AS [api_OutstandingAmount]
    FROM #api a
    INNER JOIN #bc b
        ON b.[CompanyID] = a.[CompanyID]
       AND b.[DocumentNo] = a.[DocumentNo]
       AND b.[LineNo] = a.[LineNo]
),
top_extra AS
(
    SELECT TOP (20)
        [DocumentNo],
        COUNT(*) AS [ExtraLineCount]
    FROM #extra_api
    GROUP BY [DocumentNo]
    ORDER BY COUNT(*) DESC, [DocumentNo]
)
SELECT
    'SUMMARY' AS [Section],
    'StageRowCount' AS [Metric],
    CAST((SELECT COUNT(*) FROM #bc) AS varchar(50)) AS [Value1],
    CAST((SELECT COUNT(*) FROM #api) AS varchar(50)) AS [Value2],
    CAST((SELECT COUNT(*) FROM #api) - (SELECT COUNT(*) FROM #bc) AS varchar(50)) AS [Value3],
    NULL AS [Value4]

UNION ALL

SELECT
    'EXTRA_API_PROFILE',
    'ExtraRows/DocType1/DocType5',
    CAST(COUNT(*) AS varchar(50)),
    CAST(SUM(CASE WHEN [DocumentType] = 1 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN [DocumentType] = 5 THEN 1 ELSE 0 END) AS varchar(50)),
    NULL
FROM #extra_api

UNION ALL

SELECT
    'EXTRA_API_PROFILE',
    'OutstandingQty0/OutstandingAmt0/ShippedNotInv0',
    CAST(SUM(CASE WHEN COALESCE([OutstandingQuantity], 0) = 0 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN COALESCE([OutstandingAmount], 0) = 0 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN COALESCE([QtyShippedNotInvoiced], 0) = 0 THEN 1 ELSE 0 END) AS varchar(50)),
    NULL
FROM #extra_api

UNION ALL

SELECT
    'EXTRA_API_PROFILE',
    'NotOpen_ByQtyLogic/NotOpen_ByAmountLogic',
    CAST(SUM(CASE WHEN COALESCE([OutstandingQuantity], 0) = 0
                   AND COALESCE([QtyShippedNotInvoiced], 0) = 0 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN COALESCE([OutstandingAmount], 0) = 0
                   AND COALESCE([QtyShippedNotInvoiced], 0) = 0 THEN 1 ELSE 0 END) AS varchar(50)),
    NULL,
    NULL
FROM #extra_api

UNION ALL

SELECT
    'HEADERS',
    'ExtraOrders_HeaderPresence',
    CAST(SUM(CASE WHEN [ExistsIn_stg_bc_Header] = 1 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN [ExistsIn_stg_bc_api_Header] = 1 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN [ExistsIn_stg_bc_Header] = 0 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN [ExistsIn_stg_bc_api_Header] = 0 THEN 1 ELSE 0 END) AS varchar(50))
FROM header_compare

UNION ALL

SELECT
    'MATCHED_DIFFS',
    'MatchedRows',
    CAST(COUNT(*) AS varchar(50)),
    NULL,
    NULL,
    NULL
FROM matched

UNION ALL

SELECT
    'MATCHED_DIFFS',
    'DocType/Qty/QtyInvoiced',
    CAST(SUM(CASE WHEN ISNULL([bc_DocumentType], -999) <> ISNULL([api_DocumentType], -999) THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN ABS(ISNULL([bc_Quantity], 0) - ISNULL([api_Quantity], 0)) > 0.0001 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN ABS(ISNULL([bc_QuantityInvoiced], 0) - ISNULL([api_QuantityInvoiced], 0)) > 0.0001 THEN 1 ELSE 0 END) AS varchar(50)),
    NULL
FROM matched

UNION ALL

SELECT
    'MATCHED_DIFFS',
    'OutstandingQty/ShippedNotInv/LineAmount',
    CAST(SUM(CASE WHEN ABS(ISNULL([bc_OutstandingQuantity], 0) - ISNULL([api_OutstandingQuantity], 0)) > 0.0001 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN ABS(ISNULL([bc_QtyShippedNotInvoiced], 0) - ISNULL([api_QtyShippedNotInvoiced], 0)) > 0.0001 THEN 1 ELSE 0 END) AS varchar(50)),
    CAST(SUM(CASE WHEN ABS(ISNULL([bc_LineAmount], 0) - ISNULL([api_LineAmount], 0)) > 0.01 THEN 1 ELSE 0 END) AS varchar(50)),
    NULL
FROM matched

UNION ALL

SELECT
    'MATCHED_DIFFS',
    'OutstandingAmount',
    CAST(SUM(CASE WHEN ABS(ISNULL([bc_OutstandingAmount], 0) - ISNULL([api_OutstandingAmount], 0)) > 0.01 THEN 1 ELSE 0 END) AS varchar(50)),
    NULL,
    NULL,
    NULL
FROM matched

UNION ALL

SELECT
    'TOP_EXTRA_ORDER',
    [DocumentNo],
    CAST([ExtraLineCount] AS varchar(50)),
    NULL,
    NULL,
    NULL
FROM top_extra

ORDER BY [Section], [Metric];

DROP TABLE #extra_api;
DROP TABLE #api;
DROP TABLE #bc;
