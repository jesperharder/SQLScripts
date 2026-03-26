SELECT COUNT(*) AS [RowCount]
FROM [fct_v1].[OpenSale];

SELECT TOP (100)
    [CompanyID],
    [NK_SalesOrderNumber],
    [NK_DocumentLineNumber],
    [DocumentType],
    [ADF_FactSource]
FROM [fct_v1].[OpenSale]
ORDER BY [IntakeDateKey] DESC, [NK_SalesOrderNumber] DESC;

SELECT TOP (100) *
FROM [fct_v1].[OpenSale]
ORDER BY [IntakeDateKey] DESC, [NK_SalesOrderNumber] DESC;



/* 
Kontrolblok for OpenSale V1 mod original

Bemærk:
- Sammenligningen bruger business key:
  CompanyID + NK_SalesOrderNumber + NK_DocumentLineNumber
- ADF_FactSource bruges ikke som join-nøgle, fordi source-navnet kan være forskelligt mellem original og V1
- Scope er sat til CompanyID 1,2,5,6. Juster listen hvis du vil
*/

SET NOCOUNT ON;

DECLARE @CompareCompanies TABLE (CompanyID INT PRIMARY KEY);
INSERT INTO @CompareCompanies (CompanyID)
VALUES (1), (2), (5), (6);

IF OBJECT_ID('tempdb..#old') IS NOT NULL DROP TABLE #old;
IF OBJECT_ID('tempdb..#new') IS NOT NULL DROP TABLE #new;

SELECT *
INTO #old
FROM [fct].[OpenSale]
WHERE [CompanyID] IN (SELECT [CompanyID] FROM @CompareCompanies);

SELECT *
INTO #new
FROM [fct_v1].[OpenSale]
WHERE [CompanyID] IN (SELECT [CompanyID] FROM @CompareCompanies);

/* 1. Overordnet rækkeantal */
SELECT
    'RowCount' AS [CheckName],
    (SELECT COUNT(*) FROM #old) AS [OldCount],
    (SELECT COUNT(*) FROM #new) AS [NewCount],
    (SELECT COUNT(*) FROM #new) - (SELECT COUNT(*) FROM #old) AS [Delta];

/* 2. Rækkeantal pr company */
SELECT
    COALESCE(o.CompanyID, n.CompanyID) AS [CompanyID],
    ISNULL(o.RowCountOld, 0) AS [OldRowCount],
    ISNULL(n.RowCountNew, 0) AS [NewRowCount],
    ISNULL(n.RowCountNew, 0) - ISNULL(o.RowCountOld, 0) AS [Delta]
FROM
(
    SELECT [CompanyID], COUNT(*) AS [RowCountOld]
    FROM #old
    GROUP BY [CompanyID]
) o
FULL OUTER JOIN
(
    SELECT [CompanyID], COUNT(*) AS [RowCountNew]
    FROM #new
    GROUP BY [CompanyID]
) n
    ON o.CompanyID = n.CompanyID
ORDER BY [CompanyID];

/* 3. Coverage på business key */
WITH key_compare AS
(
    SELECT
        COALESCE(o.CompanyID, n.CompanyID) AS [CompanyID],
        COALESCE(o.NK_SalesOrderNumber, n.NK_SalesOrderNumber) AS [NK_SalesOrderNumber],
        COALESCE(o.NK_DocumentLineNumber, n.NK_DocumentLineNumber) AS [NK_DocumentLineNumber],
        CASE WHEN o.CompanyID IS NOT NULL THEN 1 ELSE 0 END AS [ExistsInOld],
        CASE WHEN n.CompanyID IS NOT NULL THEN 1 ELSE 0 END AS [ExistsInNew]
    FROM #old o
    FULL OUTER JOIN #new n
        ON o.CompanyID = n.CompanyID
       AND o.NK_SalesOrderNumber = n.NK_SalesOrderNumber
       AND o.NK_DocumentLineNumber = n.NK_DocumentLineNumber
)
SELECT
    [CompanyID],
    SUM(CASE WHEN [ExistsInOld] = 1 AND [ExistsInNew] = 1 THEN 1 ELSE 0 END) AS [MatchedBusinessKeys],
    SUM(CASE WHEN [ExistsInOld] = 1 AND [ExistsInNew] = 0 THEN 1 ELSE 0 END) AS [OnlyInOld],
    SUM(CASE WHEN [ExistsInOld] = 0 AND [ExistsInNew] = 1 THEN 1 ELSE 0 END) AS [OnlyInNew]
FROM key_compare
GROUP BY [CompanyID]
ORDER BY [CompanyID];

/* 4. Aggregerede måltal pr company */
SELECT
    COALESCE(o.CompanyID, n.CompanyID) AS [CompanyID],
    ISNULL(o.SumQtyOld, 0) AS [Old_M_Quantity],
    ISNULL(n.SumQtyNew, 0) AS [New_M_Quantity],
    ISNULL(n.SumQtyNew, 0) - ISNULL(o.SumQtyOld, 0) AS [Delta_M_Quantity],
    ISNULL(o.SumAmountOld, 0) AS [Old_M_Amount],
    ISNULL(n.SumAmountNew, 0) AS [New_M_Amount],
    ISNULL(n.SumAmountNew, 0) - ISNULL(o.SumAmountOld, 0) AS [Delta_M_Amount],
    ISNULL(o.SumOutstandingOld, 0) AS [Old_M_OutstandingAmount],
    ISNULL(n.SumOutstandingNew, 0) AS [New_M_OutstandingAmount],
    ISNULL(n.SumOutstandingNew, 0) - ISNULL(o.SumOutstandingOld, 0) AS [Delta_M_OutstandingAmount]
FROM
(
    SELECT
        [CompanyID],
        SUM(ISNULL([M_Quantity], 0)) AS [SumQtyOld],
        SUM(ISNULL([M_Amount], 0)) AS [SumAmountOld],
        SUM(ISNULL([M_OutstandingAmount], 0)) AS [SumOutstandingOld]
    FROM #old
    GROUP BY [CompanyID]
) o
FULL OUTER JOIN
(
    SELECT
        [CompanyID],
        SUM(ISNULL([M_Quantity], 0)) AS [SumQtyNew],
        SUM(ISNULL([M_Amount], 0)) AS [SumAmountNew],
        SUM(ISNULL([M_OutstandingAmount], 0)) AS [SumOutstandingNew]
    FROM #new
    GROUP BY [CompanyID]
) n
    ON o.CompanyID = n.CompanyID
ORDER BY [CompanyID];

/* 5. Deltakontrol på matchede business keys */
WITH matched AS
(
    SELECT
        n.CompanyID,
        n.NK_SalesOrderNumber,
        n.NK_DocumentLineNumber,
        o.M_Quantity AS [Old_M_Quantity],
        n.M_Quantity AS [New_M_Quantity],
        o.M_Amount AS [Old_M_Amount],
        n.M_Amount AS [New_M_Amount],
        o.M_OutstandingAmount AS [Old_M_OutstandingAmount],
        n.M_OutstandingAmount AS [New_M_OutstandingAmount]
    FROM #new n
    INNER JOIN #old o
        ON o.CompanyID = n.CompanyID
       AND o.NK_SalesOrderNumber = n.NK_SalesOrderNumber
       AND o.NK_DocumentLineNumber = n.NK_DocumentLineNumber
)
SELECT
    [CompanyID],
    COUNT(*) AS [MatchedRows],
    SUM(CASE WHEN ABS(ISNULL([New_M_Quantity], 0) - ISNULL([Old_M_Quantity], 0)) > 0.0001 THEN 1 ELSE 0 END) AS [Diff_M_Quantity],
    SUM(CASE WHEN ABS(ISNULL([New_M_Amount], 0) - ISNULL([Old_M_Amount], 0)) > 0.01 THEN 1 ELSE 0 END) AS [Diff_M_Amount],
    SUM(CASE WHEN ABS(ISNULL([New_M_OutstandingAmount], 0) - ISNULL([Old_M_OutstandingAmount], 0)) > 0.01 THEN 1 ELSE 0 END) AS [Diff_M_OutstandingAmount]
FROM matched
GROUP BY [CompanyID]
ORDER BY [CompanyID];

/* 6. Unknown/manglende dim-nøgler i V1 */
SELECT
    [CompanyID],
    SUM(CASE WHEN [CompanyKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_CompanyKey],
    SUM(CASE WHEN [SalesOrderKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_SalesOrderKey],
    SUM(CASE WHEN [ItemKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_ItemKey],
    SUM(CASE WHEN [GLAccountKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_GLAccountKey],
    SUM(CASE WHEN [CustomerKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_CustomerKey],
    SUM(CASE WHEN [LocationKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_LocationKey],
    SUM(CASE WHEN [EmployeeSalespersonKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_EmployeeSalespersonKey],
    SUM(CASE WHEN [TeamKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_TeamKey],
    SUM(CASE WHEN [GeographyCustomerKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_GeographyCustomerKey],
    SUM(CASE WHEN [GeographySellToCustomerKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_GeographySellToCustomerKey],
    SUM(CASE WHEN [ShipmentMethodKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_ShipmentMethodKey],
    SUM(CASE WHEN [ChainKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_ChainKey],
    SUM(CASE WHEN [CampaignKey] = -1 THEN 1 ELSE 0 END) AS [Unknown_CampaignKey]
FROM #new
GROUP BY [CompanyID]
ORDER BY [CompanyID];

/* 7. Eksempelrækker som kun findes i V1 */
SELECT TOP (100)
    n.CompanyID,
    n.NK_SalesOrderNumber,
    n.NK_DocumentLineNumber,
    n.DocumentType,
    n.ADF_FactSource
FROM #new n
LEFT JOIN #old o
    ON o.CompanyID = n.CompanyID
   AND o.NK_SalesOrderNumber = n.NK_SalesOrderNumber
   AND o.NK_DocumentLineNumber = n.NK_DocumentLineNumber
WHERE o.CompanyID IS NULL
ORDER BY n.CompanyID, n.NK_SalesOrderNumber, n.NK_DocumentLineNumber;

/* 8. Eksempelrækker som kun findes i original */
SELECT TOP (100)
    o.CompanyID,
    o.NK_SalesOrderNumber,
    o.NK_DocumentLineNumber,
    o.DocumentType,
    o.ADF_FactSource
FROM #old o
LEFT JOIN #new n
    ON o.CompanyID = n.CompanyID
   AND o.NK_SalesOrderNumber = n.NK_SalesOrderNumber
   AND o.NK_DocumentLineNumber = n.NK_DocumentLineNumber
WHERE n.CompanyID IS NULL
ORDER BY o.CompanyID, o.NK_SalesOrderNumber, o.NK_DocumentLineNumber;

DROP TABLE #old;
DROP TABLE #new;
