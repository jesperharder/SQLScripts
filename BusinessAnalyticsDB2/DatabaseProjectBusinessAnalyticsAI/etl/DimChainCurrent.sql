CREATE VIEW [etl].[DimChainCurrent]
AS
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
--AND DIM.ChainCode = '0300000'
--AND CU.No_ = '2325'

GO

