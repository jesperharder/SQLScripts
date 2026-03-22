CREATE VIEW [etl_v1].[DimChainSource]
AS

SELECT ISNULL(Chain.Code,'') AS ChainCode
    , ISNULL(TRIM(Chain.Name),'') AS ChainName
    , ISNULL(ChainGroup.Code,'') AS ChainGroupCode
    , ISNULL(TRIM(ChainGroup.Name),'') AS ChainGroupName
    , Dim.CompanyID AS CompanyID 
FROM [stg_bc_api].[DimensionValue] AS Dim
LEFT JOIN [stg_bc_api].[DimensionValue] AS ChainGroup
    ON Dim.CompanyID = ChainGroup.CompanyID
        AND Dim.[DimensionCode] = ChainGroup.[DimensionCode]
        AND ChainGroup.Code BETWEEN LEFT(Dim.Totaling, CHARINDEX('..', Dim.Totaling) - 1) AND RIGHT(Dim.Totaling, CHARINDEX('..', Dim.Totaling) - 1)
        AND ChainGroup.[dimensionValueTypeInt] IN (0)
LEFT JOIN [stg_bc_api].[DimensionValue] AS Chain
    ON Chain.[dimensionValueTypeInt] IN (3)
        AND Dim.[DimensionCode] = Chain.[DimensionCode]
        AND Chain.Code = TRIM(LEFT(Dim.Totaling, CHARINDEX('..', Dim.Totaling) - 1))
WHERE 0 = 0
    AND Dim.[dimensionValueTypeInt] IN (4)
    AND Dim.[DimensionCode] IN ('KÆDE')
    --AND Dim.CompanyId IN(1,2,5,6)

GO

