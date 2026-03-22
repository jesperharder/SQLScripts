CREATE VIEW [PL_SetQuantity]
AS
SELECT [bom].[Production BOM No_]
      ,SUM([bom].[Quantity]) AS [BOMQuantity]
FROM [stg_bc].[ProductionBOMLine] AS [bom]
INNER JOIN [stg_bc].[Item] AS [item]
ON [bom].[No_] = [item].[No_]
WHERE(
         [item].[Gen_ Prod_ Posting Group] = 'MELLEM'
  AND    ([item].[Item Category Code] NOT IN ( 'LID', 'BOX' ))
     )
GROUP BY [bom].[Production BOM No_];

GO

