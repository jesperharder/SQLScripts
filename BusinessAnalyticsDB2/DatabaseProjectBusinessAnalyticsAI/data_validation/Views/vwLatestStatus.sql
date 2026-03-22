CREATE VIEW [data_validation].[vwLatestStatus]
AS
WITH RankedRuns AS
(
    SELECT
        tp.[ValidationCode],
        tp.[ValidationGroup],
        r.[RunId],
        r.[StartedAt],
        r.[FinishedAt],
        r.[ExecutionStatus],
        r.[Message],
        ROW_NUMBER() OVER
        (
            PARTITION BY tp.[TablePairId]
            ORDER BY r.[StartedAt] DESC, r.[RunId] DESC
        ) AS [RunRank]
    FROM [data_validation].[TablePair] AS tp
    LEFT JOIN [data_validation].[Run] AS r
        ON r.[TablePairId] = tp.[TablePairId]
)
SELECT
    rr.[ValidationCode],
    rr.[ValidationGroup],
    rr.[RunId],
    rr.[StartedAt],
    rr.[FinishedAt],
    rr.[ExecutionStatus],
    rr.[Message],
    ISNULL(SUM(CASE WHEN res.[ResultStatus] = N'FAIL' THEN 1 ELSE 0 END), 0) AS [FailedRuleCount],
    ISNULL(SUM(res.[IssueCount]), 0) AS [TotalIssueCount]
FROM RankedRuns AS rr
LEFT JOIN [data_validation].[Result] AS res
    ON res.[RunId] = rr.[RunId]
WHERE rr.[RunRank] = 1
GROUP BY
    rr.[ValidationCode],
    rr.[ValidationGroup],
    rr.[RunId],
    rr.[StartedAt],
    rr.[FinishedAt],
    rr.[ExecutionStatus],
    rr.[Message];


GO
