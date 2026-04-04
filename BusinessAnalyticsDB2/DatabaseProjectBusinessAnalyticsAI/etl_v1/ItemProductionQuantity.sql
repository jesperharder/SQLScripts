CREATE VIEW [etl_v1].[ItemProductionQuantity]
AS

SELECT
    itm.[CompanyId] AS [CompanyID],
    itm.[number] AS [ItemNo],
    itm.[description] AS [ItemDescription],
    ISNULL(bom.[BOMQuantity], 1) AS [ProductionQuantity]
FROM [stg_bc_api].[Item] AS [itm]
LEFT JOIN
(
    SELECT
        bom.[CompanyId],
        bom.[productionBOMNo],
        SUM(bom.[quantityPer]) AS [BOMQuantity]
    FROM [stg_bc_api].[ProductionBOMLine] AS [bom]
    INNER JOIN [stg_bc_api].[Item] AS [component]
        ON component.[CompanyId] = bom.[CompanyId]
       AND component.[number] = bom.[no]
    WHERE component.[genProdPostingGroup] = 'MELLEM'
      AND component.[itemCategoryCode] NOT IN ('LID', 'BOX')
    GROUP BY
        bom.[CompanyId],
        bom.[productionBOMNo]
) AS [bom]
    ON bom.[CompanyId] = itm.[CompanyId]
   AND bom.[productionBOMNo] = itm.[productionBomNo];

GO
