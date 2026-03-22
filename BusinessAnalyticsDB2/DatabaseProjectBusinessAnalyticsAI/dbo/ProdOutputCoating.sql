Create view ProdOutputCoating as
WITH MaxOperationPerDocument AS (
    SELECT
        [Document No_],
        MAX([Operation No_]) AS [MaxOperationNo]
    FROM [stg_bc].[CapacityLedgerEntry]
    WHERE [Work Center No_] IN ('CO1', 'CO2')
    GROUP BY [Document No_]
)
SELECT
    CLE.[Document No_],
    CLE.[Item No_],
    CLE.[Work Center No_],
    CLE.[Operation No_],
    CLE.[Posting Date],
    SUM(CLE.[Output Quantity]) AS [OutputQuantity]
FROM [stg_bc].[CapacityLedgerEntry] CLE
JOIN MaxOperationPerDocument MOD
    ON CLE.[Document No_] = MOD.[Document No_]
    AND CLE.[Operation No_] = MOD.[MaxOperationNo]
WHERE [Work Center No_] IN ('CO1', 'CO2')
GROUP BY CLE.[Document No_], CLE.[Item No_], CLE.[Work Center No_], CLE.[Operation No_],CLE.[Posting Date]
-- ORDER BY CLE.[Document No_], CLE.[Operation No_] DESC, CLE.[Work Center No_],CLE.[Posting Date];

GO

