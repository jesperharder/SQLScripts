CREATE PROCEDURE [etl_v1].[GetRowsFactBOMExplosion]
    @CompanyID INT,
    @TopItemNo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    WITH [ExplodableItems] AS
    (
        SELECT DISTINCT
            [source].[CompanyID],
            [source].[OwnerItemNo]
        FROM [etl_v1].[BOMExplosionSource] AS [source]
    ),
    [TopItems] AS
    (
        SELECT
            [source].[CompanyID],
            [source].[CompanyKey],
            [source].[OwnerItemKey] AS [TopItemKey],
            [source].[OwnerItemNo] AS [TopItemNo],
            [source].[OwnerItemDescription] AS [TopItemDescription],
            [source].[OwnerProductionBOMNo] AS [TopBOMNo],
            [source].[ParentBOMKey] AS [TopBOMKey],
            [source].[SelectedVersionCode],
            [source].[BOMStatus],
            MAX([source].[SystemModifiedAtMax]) AS [SystemModifiedAtMax]
        FROM [etl_v1].[BOMExplosionSource] AS [source]
        WHERE (@CompanyID IS NULL OR [source].[CompanyID] = @CompanyID)
          AND (@TopItemNo IS NULL OR [source].[OwnerItemNo] = @TopItemNo)
        GROUP BY
            [source].[CompanyID],
            [source].[CompanyKey],
            [source].[OwnerItemKey],
            [source].[OwnerItemNo],
            [source].[OwnerItemDescription],
            [source].[OwnerProductionBOMNo],
            [source].[ParentBOMKey],
            [source].[SelectedVersionCode],
            [source].[BOMStatus]
    ),
    [RecursiveExplosion] AS
    (
        SELECT
            [top].[CompanyKey],
            [top].[TopItemKey],
            CAST(-1 AS INT) AS [ParentItemKey],
            [top].[TopItemKey] AS [ComponentItemKey],
            [top].[TopBOMKey],
            CAST(NULL AS INT) AS [LocationKey],
            [top].[CompanyID],
            CAST(NULL AS NVARCHAR(20)) AS [LocationCode],
            [top].[TopItemNo],
            CAST(NULL AS NVARCHAR(20)) AS [ParentItemNo],
            [top].[TopItemNo] AS [ComponentNo],
            [top].[TopBOMNo],
            CAST(NULL AS NVARCHAR(20)) AS [ParentBOMNo],
            [top].[SelectedVersionCode],
            CAST(0 AS INT) AS [Level],
            CAST(NULL AS INT) AS [LineNo],
            CAST(N'Item' AS NVARCHAR(50)) AS [ComponentType],
            CAST(NULL AS INT) AS [ComponentTypeInt],
            [top].[TopItemDescription] AS [ComponentDescription],
            CAST(NULL AS NVARCHAR(10)) AS [ComponentVariantCode],
            CAST(NULL AS NVARCHAR(10)) AS [ComponentUOM],
            CAST(NULL AS NVARCHAR(10)) AS [Position],
            CAST(NULL AS NVARCHAR(20)) AS [RoutingLinkCode],
            CAST([top].[TopItemNo] AS NVARCHAR(4000)) AS [Path],
            CONVERT(CHAR(64), HASHBYTES('SHA2_256', CONCAT([top].[CompanyID], N'|', [top].[TopItemNo], N'|', [top].[TopItemNo])), 2) AS [PathKey],
            CAST(NULL AS CHAR(64)) AS [ParentPathKey],
            CAST(1 AS DECIMAL(38, 20)) AS [QuantityPerParent],
            CAST(0 AS DECIMAL(38, 20)) AS [ScrapPercent],
            CAST(1 AS DECIMAL(38, 20)) AS [QuantityPerTopItem],
            CAST(1 AS BIT) AS [IsTopNode],
            CAST(0 AS BIT) AS [IsLeaf],
            [top].[BOMStatus],
            [top].[SystemModifiedAtMax],
            CAST(CONCAT(N'|', [top].[TopItemNo], N'|') AS NVARCHAR(4000)) AS [ItemPath]
        FROM [TopItems] AS [top]

        UNION ALL

        SELECT
            [current].[CompanyKey],
            [current].[TopItemKey],
            CASE
                WHEN [current].[ComponentItemKey] > 0 THEN [current].[ComponentItemKey]
                ELSE -1
            END AS [ParentItemKey],
            [source].[ComponentItemKey],
            [current].[TopBOMKey],
            [source].[LocationKey],
            [current].[CompanyID],
            [source].[LocationCode],
            [current].[TopItemNo],
            [current].[ComponentNo] AS [ParentItemNo],
            [source].[ComponentNo],
            [current].[TopBOMNo],
            [source].[OwnerProductionBOMNo] AS [ParentBOMNo],
            [source].[SelectedVersionCode],
            [current].[Level] + 1 AS [Level],
            [source].[LineNo],
            [source].[ComponentType],
            [source].[ComponentTypeInt],
            [source].[ComponentDescription],
            [source].[ComponentVariantCode],
            [source].[ComponentUOM],
            [source].[Position],
            [source].[RoutingLinkCode],
            CAST(
                CONCAT(
                    [current].[Path],
                    N' > ',
                    COALESCE([source].[ComponentNo], CONCAT(N'(', COALESCE([source].[ComponentType], N'Unknown'), N')')),
                    N' [',
                    [source].[LineNo],
                    N']'
                ) AS NVARCHAR(4000)
            ) AS [Path],
            CONVERT(
                CHAR(64),
                HASHBYTES(
                    'SHA2_256',
                    CONCAT(
                        [current].[CompanyID],
                        N'|',
                        [current].[TopItemNo],
                        N'|',
                        [current].[Path],
                        N' > ',
                        COALESCE([source].[ComponentNo], CONCAT(N'(', COALESCE([source].[ComponentType], N'Unknown'), N')')),
                        N' [',
                        [source].[LineNo],
                        N']'
                    )
                ),
                2
            ) AS [PathKey],
            [current].[PathKey] AS [ParentPathKey],
            [source].[QuantityPerParent],
            [source].[ScrapPercent],
            CAST(
                [current].[QuantityPerTopItem]
                * [source].[QuantityPerParent]
                * (1 + ([source].[ScrapPercent] / 100.0))
                AS DECIMAL(38, 20)
            ) AS [QuantityPerTopItem],
            CAST(0 AS BIT) AS [IsTopNode],
            CAST(0 AS BIT) AS [IsLeaf],
            [source].[BOMStatus],
            CASE
                WHEN [current].[SystemModifiedAtMax] >= [source].[SystemModifiedAtMax] OR [source].[SystemModifiedAtMax] IS NULL THEN [current].[SystemModifiedAtMax]
                ELSE [source].[SystemModifiedAtMax]
            END AS [SystemModifiedAtMax],
            CASE
                WHEN [source].[ComponentItemKey] > 0 AND [source].[ComponentNo] IS NOT NULL THEN CONCAT([current].[ItemPath], [source].[ComponentNo], N'|')
                ELSE [current].[ItemPath]
            END AS [ItemPath]
        FROM [RecursiveExplosion] AS [current]
        INNER JOIN [etl_v1].[BOMExplosionSource] AS [source]
            ON [source].[CompanyID] = [current].[CompanyID]
           AND [source].[OwnerItemNo] = [current].[ComponentNo]
        WHERE [current].[ComponentItemKey] > 0
          AND (
                [source].[ComponentItemKey] <= 0
                OR [source].[ComponentNo] IS NULL
                OR CHARINDEX(CONCAT(N'|', [source].[ComponentNo], N'|'), [current].[ItemPath]) = 0
              )
    )
    SELECT
        [result].[CompanyKey],
        [result].[TopItemKey],
        [result].[ParentItemKey],
        [result].[ComponentItemKey],
        [result].[TopBOMKey],
        [result].[LocationKey],
        [result].[CompanyID],
        [result].[LocationCode] AS [NK_LocationCode],
        [result].[TopItemNo] AS [NK_TopItemNo],
        [result].[ParentItemNo] AS [NK_ParentItemNo],
        [result].[ComponentNo] AS [NK_ComponentNo],
        [result].[TopBOMNo] AS [NK_TopBOMNo],
        [result].[ParentBOMNo] AS [NK_ParentBOMNo],
        [result].[SelectedVersionCode] AS [NK_SelectedVersionCode],
        [result].[LocationCode],
        [result].[TopItemNo],
        [result].[ParentItemNo],
        [result].[ComponentNo],
        [result].[TopBOMNo],
        [result].[ParentBOMNo],
        [result].[SelectedVersionCode],
        [result].[Level],
        [result].[LineNo],
        [result].[ComponentType],
        [result].[ComponentTypeInt],
        [result].[ComponentDescription],
        [result].[ComponentVariantCode],
        [result].[ComponentUOM],
        [result].[Position],
        [result].[RoutingLinkCode],
        [result].[Path],
        [result].[PathKey],
        [result].[ParentPathKey],
        [result].[QuantityPerParent],
        [result].[ScrapPercent],
        [result].[QuantityPerTopItem],
        [result].[IsTopNode],
        CAST(
            CASE
                WHEN [explodable].[OwnerItemNo] IS NOT NULL AND [result].[ComponentItemKey] > 0 THEN 0
                ELSE 1
            END AS BIT
        ) AS [IsLeaf],
        [result].[BOMStatus],
        [result].[SystemModifiedAtMax]
    FROM [RecursiveExplosion] AS [result]
    LEFT JOIN [ExplodableItems] AS [explodable]
        ON [explodable].[CompanyID] = [result].[CompanyID]
       AND [explodable].[OwnerItemNo] = [result].[ComponentNo]
    OPTION (MAXRECURSION 32767);
END;


GO
