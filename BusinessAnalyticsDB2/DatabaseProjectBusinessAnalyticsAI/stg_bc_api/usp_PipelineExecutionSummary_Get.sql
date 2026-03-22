CREATE   PROCEDURE [stg_bc_api].[usp_PipelineExecutionSummary_Get]
(
    @RunGroupId UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH ChildRows AS
    (
        SELECT
            [CountryCode],
            [PipelineName],
            [Status],
            [ErrorMessage]
        FROM [stg_bc_api].[PipelineExecutionLog]
        WHERE [RunGroupId] = @RunGroupId
          AND [PipelineLevel] = 'Child'
    ),
    CountryAgg AS
    (
        SELECT
            [CountryCode],
            COUNT(*) AS [TotalPipelines],
            SUM(CASE WHEN [Status] = 'Succeeded' THEN 1 ELSE 0 END) AS [SucceededCount],
            SUM(CASE WHEN [Status] = 'Failed' THEN 1 ELSE 0 END) AS [FailedCount],
            SUM(CASE WHEN [Status] = 'CompletedWithErrors' THEN 1 ELSE 0 END) AS [CompletedWithErrorsCount]
        FROM ChildRows
        GROUP BY [CountryCode]
    ),
    RunHeader AS
    (
        SELECT TOP (1)
            [RunGroupId],
            [PipelineName]       AS [MasterPipelineName],
            [Status]             AS [MasterStatus],
            [StartTime],
            [EndTime],
            [DurationSeconds],
            [TriggerTime],
            [TriggerName],
            [TriggerType],
            [WorkspaceName],
            [DataFactoryName],
            [PipelineFolderName]
        FROM [stg_bc_api].[PipelineExecutionLog]
        WHERE [RunGroupId] = @RunGroupId
          AND [PipelineLevel] = 'Master'
        ORDER BY [LogId] DESC
    )
    SELECT
        h.[RunGroupId],
        h.[MasterPipelineName],
        h.[MasterStatus],
        h.[StartTime],
        h.[EndTime],
        h.[DurationSeconds],
        h.[TriggerTime],
        h.[TriggerName],
        h.[TriggerType],
        h.[WorkspaceName],
        h.[DataFactoryName],
        h.[PipelineFolderName],
        ISNULL(SUM(c.[TotalPipelines]), 0) AS [TotalPipelines],
        ISNULL(SUM(c.[SucceededCount]), 0) AS [SucceededCount],
        ISNULL(SUM(c.[FailedCount]), 0) AS [FailedCount],
        ISNULL(SUM(c.[CompletedWithErrorsCount]), 0) AS [CompletedWithErrorsCount]
    FROM RunHeader h
    LEFT JOIN CountryAgg c
        ON 1 = 1
    GROUP BY
        h.[RunGroupId],
        h.[MasterPipelineName],
        h.[MasterStatus],
        h.[StartTime],
        h.[EndTime],
        h.[DurationSeconds],
        h.[TriggerTime],
        h.[TriggerName],
        h.[TriggerType],
        h.[WorkspaceName],
        h.[DataFactoryName],
        h.[PipelineFolderName];

    SELECT
        [CountryCode],
        [TotalPipelines],
        [SucceededCount],
        [FailedCount],
        [CompletedWithErrorsCount]
    FROM CountryAgg
    ORDER BY [CountryCode];

    SELECT
        [CountryCode],
        [PipelineName],
        [Status],
        [ErrorMessage]
    FROM ChildRows
    WHERE [Status] IN ('Failed', 'CompletedWithErrors')
    ORDER BY [CountryCode], [PipelineName];
END;

GO

