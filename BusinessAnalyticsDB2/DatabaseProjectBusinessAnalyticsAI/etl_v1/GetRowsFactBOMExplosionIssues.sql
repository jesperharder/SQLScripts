CREATE VIEW [etl_v1].[GetRowsFactBOMExplosionIssues]
AS
WITH [ItemsWithBom] AS
(
    SELECT
        [item].[CompanyId] AS [CompanyID],
        [item].[number] AS [ItemNo],
        [item].[productionBomNo] AS [ProductionBOMNo]
    FROM [stg_bc_api].[Item] AS [item]
    WHERE NULLIF(LTRIM(RTRIM([item].[productionBomNo])), N'') IS NOT NULL
),
[VersionCandidates] AS
(
    SELECT
        [line].[CompanyId] AS [CompanyID],
        [line].[productionBOMNo] AS [ProductionBOMNo],
        ISNULL(NULLIF(LTRIM(RTRIM([line].[versionCode])), N''), N'') AS [VersionCode],
        MAX([line].[systemModifiedAt]) AS [MaxLineModifiedAt]
    FROM [stg_bc_api].[ProductionBOMLine] AS [line]
    GROUP BY
        [line].[CompanyId],
        [line].[productionBOMNo],
        ISNULL(NULLIF(LTRIM(RTRIM([line].[versionCode])), N''), N'')
),
[VersionChoice] AS
(
    SELECT
        [candidate].[CompanyID],
        [candidate].[ProductionBOMNo],
        [candidate].[VersionCode],
        ROW_NUMBER() OVER
        (
            PARTITION BY [candidate].[CompanyID], [candidate].[ProductionBOMNo]
            ORDER BY
                CASE WHEN [candidate].[VersionCode] = N'' THEN 0 ELSE 1 END ASC,
                [candidate].[MaxLineModifiedAt] DESC,
                [candidate].[VersionCode] DESC
        ) AS [VersionRank]
    FROM [VersionCandidates] AS [candidate]
)
SELECT
    [item].[CompanyID],
    [item].[ItemNo],
    [item].[ProductionBOMNo],
    CAST(NULL AS NVARCHAR(20)) AS [VersionCode],
    N'MissingHeader' AS [IssueType],
    N'Item references a production BOM that has no matching ProductionBOMHeader row.' AS [IssueDescription]
FROM [ItemsWithBom] AS [item]
LEFT JOIN [stg_bc_api].[ProductionBOMHeader] AS [header]
    ON [header].[CompanyId] = [item].[CompanyID]
   AND [header].[no] = [item].[ProductionBOMNo]
WHERE [header].[no] IS NULL

UNION ALL

SELECT
    [item].[CompanyID],
    [item].[ItemNo],
    [item].[ProductionBOMNo],
    CAST(NULL AS NVARCHAR(20)) AS [VersionCode],
    N'MissingLines' AS [IssueType],
    N'Item references a production BOM that has no ProductionBOMLine rows.' AS [IssueDescription]
FROM [ItemsWithBom] AS [item]
LEFT JOIN [stg_bc_api].[ProductionBOMLine] AS [line]
    ON [line].[CompanyId] = [item].[CompanyID]
   AND [line].[productionBOMNo] = [item].[ProductionBOMNo]
WHERE [line].[productionBOMNo] IS NULL

UNION ALL

SELECT
    [item].[CompanyID],
    [item].[ItemNo],
    [item].[ProductionBOMNo],
    [choice].[VersionCode],
    N'MultipleVersionCandidates' AS [IssueType],
    N'Production BOM has multiple version candidates. Load logic will choose one deterministically.' AS [IssueDescription]
FROM [ItemsWithBom] AS [item]
INNER JOIN
(
    SELECT
        [candidate].[CompanyID],
        [candidate].[ProductionBOMNo],
        COUNT(*) AS [CandidateCount]
    FROM [VersionCandidates] AS [candidate]
    GROUP BY
        [candidate].[CompanyID],
        [candidate].[ProductionBOMNo]
    HAVING COUNT(*) > 1
) AS [multi]
    ON [multi].[CompanyID] = [item].[CompanyID]
   AND [multi].[ProductionBOMNo] = [item].[ProductionBOMNo]
INNER JOIN [VersionChoice] AS [choice]
    ON [choice].[CompanyID] = [item].[CompanyID]
   AND [choice].[ProductionBOMNo] = [item].[ProductionBOMNo]
   AND [choice].[VersionRank] = 1

UNION ALL

SELECT
    [source].[CompanyID],
    [source].[OwnerItemNo] AS [ItemNo],
    [source].[OwnerProductionBOMNo] AS [ProductionBOMNo],
    [source].[SelectedVersionCode] AS [VersionCode],
    N'MissingComponentItem' AS [IssueType],
    N'BOM line references a component number that does not match dim_v1.Item.' AS [IssueDescription]
FROM [etl_v1].[BOMExplosionSource] AS [source]
WHERE [source].[ComponentNo] IS NOT NULL
  AND [source].[ComponentItemKey] = -1
  AND [source].[ComponentTypeInt] IN (1, 2);

GO
