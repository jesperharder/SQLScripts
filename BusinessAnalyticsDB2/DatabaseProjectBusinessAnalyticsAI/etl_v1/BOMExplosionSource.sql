CREATE VIEW [etl_v1].[BOMExplosionSource]
AS
WITH [ItemsWithBom] AS
(
    SELECT
        [item].[CompanyId] AS [CompanyID],
        [company].[CompanyKey],
        [item_dim].[ItemKey] AS [OwnerItemKey],
        [item].[number] AS [OwnerItemNo],
        [item].[description] AS [OwnerItemDescription],
        [item].[productionBomNo] AS [OwnerProductionBOMNo],
        [item].[systemModifiedAt] AS [OwnerSystemModifiedAt]
    FROM [stg_bc_api].[Item] AS [item]
    LEFT JOIN [dim_v1].[Company] AS [company]
        ON [company].[CompanyID] = [item].[CompanyId]
    LEFT JOIN [dim_v1].[Item] AS [item_dim]
        ON [item_dim].[ItemCompanyID] = [item].[CompanyId]
       AND [item_dim].[ItemNo] = [item].[number]
    WHERE NULLIF(LTRIM(RTRIM([item].[productionBomNo])), N'') IS NOT NULL
),
[VersionCandidates] AS
(
    SELECT
        [line].[CompanyId] AS [CompanyID],
        [line].[productionBOMNo] AS [ProductionBOMNo],
        ISNULL(NULLIF(LTRIM(RTRIM([line].[versionCode])), N''), N'') AS [VersionCode],
        MAX([line].[systemModifiedAt]) AS [MaxLineModifiedAt],
        COUNT_BIG(*) AS [LineCount]
    FROM [stg_bc_api].[ProductionBOMLine] AS [line]
    GROUP BY
        [line].[CompanyId],
        [line].[productionBOMNo],
        ISNULL(NULLIF(LTRIM(RTRIM([line].[versionCode])), N''), N'')
),
[ChosenVersions] AS
(
    SELECT
        [candidate].[CompanyID],
        [candidate].[ProductionBOMNo],
        [candidate].[VersionCode],
        [candidate].[MaxLineModifiedAt],
        [candidate].[LineCount],
        ROW_NUMBER() OVER
        (
            PARTITION BY [candidate].[CompanyID], [candidate].[ProductionBOMNo]
            ORDER BY
                CASE WHEN [candidate].[VersionCode] = N'' THEN 0 ELSE 1 END ASC,
                [candidate].[MaxLineModifiedAt] DESC,
                [candidate].[VersionCode] DESC
        ) AS [VersionRank]
    FROM [VersionCandidates] AS [candidate]
),
[SelectedVersions] AS
(
    SELECT
        [chosen].[CompanyID],
        [chosen].[ProductionBOMNo],
        [chosen].[VersionCode],
        [chosen].[MaxLineModifiedAt],
        [chosen].[LineCount]
    FROM [ChosenVersions] AS [chosen]
    WHERE [chosen].[VersionRank] = 1
)
SELECT
    [item].[CompanyID],
    ISNULL([item].[CompanyKey], -1) AS [CompanyKey],
    ISNULL([item].[OwnerItemKey], -1) AS [OwnerItemKey],
    [item].[OwnerItemNo],
    [item].[OwnerItemDescription],
    [item].[OwnerProductionBOMNo],
    ISNULL([bom_dim].[BOMKey], -1) AS [ParentBOMKey],
    [selected].[VersionCode] AS [SelectedVersionCode],
    [header].[status] AS [BOMStatus],
    [header].[lowLevelCode] AS [BOMLowLevelCode],
    [line].[lineNo] AS [LineNo],
    [line].[type] AS [ComponentType],
    [line].[typeInt] AS [ComponentTypeInt],
    [line].[no] AS [ComponentNo],
    ISNULL([component_dim].[ItemKey], -1) AS [ComponentItemKey],
    [line].[description] AS [ComponentDescription],
    [line].[variantCode] AS [ComponentVariantCode],
    [line].[unitOfMeasureCode] AS [ComponentUOM],
    [line].[position] AS [Position],
    [line].[routingLinkCode] AS [RoutingLinkCode],
    CAST(ISNULL([line].[quantityPer], 0) AS DECIMAL(38, 20)) AS [QuantityPerParent],
    CAST(ISNULL([scrap].[scrapPercent], ISNULL([line].[scrapPercent], 0)) AS DECIMAL(38, 20)) AS [ScrapPercent],
    CAST(
        (
            SELECT MAX([value])
            FROM
            (
                VALUES
                    ([item].[OwnerSystemModifiedAt]),
                    ([header].[systemModifiedAt]),
                    ([line].[systemModifiedAt]),
                    ([scrap].[systemModifiedAt])
            ) AS [modified]([value])
        ) AS DATETIME2(7)
    ) AS [SystemModifiedAtMax],
    CAST(NULL AS INT) AS [LocationKey],
    CAST(NULL AS NVARCHAR(20)) AS [LocationCode]
FROM [ItemsWithBom] AS [item]
INNER JOIN [SelectedVersions] AS [selected]
    ON [selected].[CompanyID] = [item].[CompanyID]
   AND [selected].[ProductionBOMNo] = [item].[OwnerProductionBOMNo]
INNER JOIN [stg_bc_api].[ProductionBOMLine] AS [line]
    ON [line].[CompanyId] = [selected].[CompanyID]
   AND [line].[productionBOMNo] = [selected].[ProductionBOMNo]
   AND ISNULL(NULLIF(LTRIM(RTRIM([line].[versionCode])), N''), N'') = [selected].[VersionCode]
LEFT JOIN [stg_bc_api].[ProductionBOMHeader] AS [header]
    ON [header].[CompanyId] = [selected].[CompanyID]
   AND [header].[no] = [selected].[ProductionBOMNo]
LEFT JOIN [stg_bc_api].[ProdBOMLineScrap] AS [scrap]
    ON [scrap].[CompanyId] = [line].[CompanyId]
   AND [scrap].[productionBOMNo] = [line].[productionBOMNo]
   AND ISNULL(NULLIF(LTRIM(RTRIM([scrap].[versionCode])), N''), N'') = [selected].[VersionCode]
   AND [scrap].[lineNo] = [line].[lineNo]
LEFT JOIN [dim_v1].[BOM] AS [bom_dim]
    ON [bom_dim].[BOMCompanyID] = [selected].[CompanyID]
   AND [bom_dim].[BOMNumber] = [selected].[ProductionBOMNo]
LEFT JOIN [dim_v1].[Item] AS [component_dim]
    ON [component_dim].[ItemCompanyID] = [line].[CompanyId]
   AND [component_dim].[ItemNo] = [line].[no];

GO
