CREATE view [fct].[FinanceRealisedBudget] as

-- 2025.01.21 JH     First version combined Realised and Budget tables
SELECT 
    'REALISED' AS Source, 
    [PostingDateKey],
    [CompanyKey],
    -2 AS [BudgetVersionKey],    -- Budget-specific column, not present in REALISED
    [FinanceAccountKey] AS [GLAccountKey], -- Rename to match BUDGET column
    [DepartmentKey],
    [ChainKey],
    [CountryKey],
    [SupplierKey],                 -- REALISED-specific column
    [MarketingKey],                -- REALISED-specific column
    [EmployeeKey],
    [MaintainanceKey],             -- REALISED-specific column
    [M_Amount_LCY],
    [CompanyID],
    [NK_EntryNo],
    [NK_PostingDate],
    [FactSource] AS [ADF_FactSource], -- Rename to match BUDGET column
    [timestamp] AS [ADF_LastTimestamp] -- Rename to match BUDGET column
FROM [fct].[FinanceEntry]

UNION ALL

SELECT
    'BUDGET' AS Source,
    [PostingDateKey],
    [CompanyKey],
    [BudgetVersionKey],
    [GLAccountKey],
    [DepartmentKey],
    [ChainKey],
    [CountryKey],
    -2 AS [SupplierKey],         -- REALISED-specific column, not present in BUDGET
    -2 AS [MarketingKey],        -- REALISED-specific column, not present in BUDGET
    [EmployeeKey],
    -2 AS [MaintainanceKey],     -- REALISED-specific column, not present in BUDGET
    [M_Amount_LCY],
    [CompanyID],
    [NK_EntryNo],
    [NK_PostingDate],
    [ADF_FactSource],
    [ADF_LastTimestamp]
FROM [fct].[BudgetEntry];

GO

