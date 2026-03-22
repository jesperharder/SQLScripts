CREATE VIEW [etl].[ItemProductionQuantity]
AS

--2024.06JH     Ensure Production Quantity is based on actual Item No_, include all Companies
SELECT
    ITM.CompanyID AS CompanyID
    ,ITM.No_ AS ItemNo
    ,ITM.[Description] AS ItemDescription
    ,ISNULL(BL.BOMQuantity,1) AS ProductionQuantity
FROM stg_bc.Item ITM
left join (
            SELECT  
                [bom].[CompanyID]
                ,[bom].[Production BOM No_]
                ,SUM([bom].[Quantity]) AS [BOMQuantity]
            FROM   
                [stg_bc].[ProductionBOMLine] AS [bom]
            INNER JOIN [stg_bc].[Item] AS [item]
            ON [bom].[No_] = [item].[No_]
            WHERE(
                    [item].[Gen_ Prod_ Posting Group] = 'MELLEM'
            AND    ([item].[Item Category Code] NOT IN ( 'LID', 'BOX' ))
                )
            GROUP BY [bom].[CompanyID], [bom].[Production BOM No_]
) as BL 
ON ITM.[Production BOM No_] = BL.[Production BOM No_]
AND ITM.CompanyID = BL.CompanyID
WHERE ITM.CompanyID in(1,2)

UNION 
SELECT
    ITM.CompanyID AS CompanyID
    ,ITM.No_ AS ItemNo
    ,ITM.[Description] AS ItemDescription
    ,1 AS ProductionQuantity
FROM stg_navdb.Item ITM
WHERE CompanyID not in(1,2)
;

GO

