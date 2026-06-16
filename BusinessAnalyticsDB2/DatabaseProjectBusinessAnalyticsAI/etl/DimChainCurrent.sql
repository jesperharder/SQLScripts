CREATE VIEW [etl].[DimChainCurrent]
AS
-- 2026-06-16 Codex: Company 3+4 resolve current customer chain from NAV customer card
-- values. Other companies keep the existing default-dimension based resolution.
SELECT CU.CompanyID as CustomerCompanyID
    , CU.No_ as CustomerNo
    , CU.Name as CustomerName
    , DEFDIM.[Dimension Value Code]
    , DIM.ChainCode
    , DIM.ChainName
    , DIM.ChainGroupCode
    , DIM.ChainGroupName
FROM stg_bc.Customer CU
LEFT JOIN stg_bc.DefaultDimension DEFDIM
    ON CU.CompanyID = DEFDIM.CompanyID
        AND CU.No_ = DEFDIM.No_
        AND DEFDIM.[Table ID] = 18
        AND DEFDIM.[Dimension Code] = 'KÆDE'
LEFT JOIN etl.DimChainSource DIM
    ON CU.CompanyID = DIM.CompanyID
        AND DEFDIM.[Dimension Value Code] = DIM.ChainGroupCode
        AND dim.ChainGroupCode not in ('')
WHERE 0=0
    AND CU.CompanyID > 0
    AND CU.CompanyID NOT IN (3,4)

UNION ALL

SELECT CU.CompanyID as CustomerCompanyID
    , CU.No_ as CustomerNo
    , CU.Name as CustomerName
    , CAST(NULL AS NVARCHAR(20)) AS [Dimension Value Code]
    , DIM.ChainCode
    , DIM.ChainName
    , DIM.ChainGroupCode
    , DIM.ChainGroupName
FROM stg_navdb.Customer CU
LEFT JOIN etl.DimChainSource DIM
    ON CU.CompanyID = DIM.CompanyID
        AND DIM.ChainCode = CASE
            WHEN NULLIF(TRIM(CU.[Chain Code]), '') IS NULL THEN N'Blank'
            ELSE TRIM(CU.[Chain Code])
        END
        AND DIM.ChainGroupCode = CASE
            WHEN NULLIF(TRIM(CU.[Chain Group Code]), '') IS NULL THEN N'Blank'
            ELSE TRIM(CU.[Chain Group Code])
        END
WHERE 0=0
    AND CU.CompanyID IN (3,4)
    AND (
        NULLIF(TRIM(CU.[Chain Code]), '') IS NOT NULL
        OR NULLIF(TRIM(CU.[Chain Group Code]), '') IS NOT NULL
    )
--AND DIM.ChainCode = '0300000'
--AND CU.No_ = '2325'

GO

