CREATE   PROCEDURE [stg_bc_api].[usp_PipelineExecutionLog_Upsert]
(
    @RunGroupId           UNIQUEIDENTIFIER,
    @PipelineLevel        NVARCHAR(20),
    @CountryCode          NVARCHAR(10) = '',
    @PipelineName         NVARCHAR(200),
    @PipelineRunId        NVARCHAR(100),

    @ParentPipelineName   NVARCHAR(200) = NULL,
    @ParentPipelineRunId  NVARCHAR(100) = NULL,

    @Status               NVARCHAR(30),
    @StartTime            DATETIME2(0) = NULL,
    @EndTime              DATETIME2(0) = NULL,

    @TriggerTime          DATETIME2(0) = NULL,
    @TriggerName          NVARCHAR(200) = NULL,
    @TriggerType          NVARCHAR(100) = NULL,

    @WorkspaceName        NVARCHAR(200) = NULL,
    @DataFactoryName      NVARCHAR(200) = NULL,
    @PipelineFolderName   NVARCHAR(300) = NULL,

    @PipelinesExpected    INT = NULL,
    @PipelinesStarted     INT = NULL,
    @PipelinesSucceeded   INT = NULL,
    @PipelinesFailed      INT = NULL,

    @Message              NVARCHAR(1000) = NULL,
    @ErrorMessage         NVARCHAR(4000) = NULL,

    @PipelineName_Audit   NVARCHAR(200) = NULL,
    @PipelineRunId_Audit  NVARCHAR(100) = NULL,
    @PipelineTriggerTime  DATETIME2(0) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @statusInt TINYINT =
        CASE @Status
            WHEN 'Started'             THEN 0
            WHEN 'Succeeded'           THEN 1
            WHEN 'Failed'              THEN 2
            WHEN 'CompletedWithErrors' THEN 3
            ELSE 9
        END;

    UPDATE tgt
       SET [ParentPipelineName]  = COALESCE(@ParentPipelineName, tgt.[ParentPipelineName]),
           [ParentPipelineRunId] = COALESCE(@ParentPipelineRunId, tgt.[ParentPipelineRunId]),
           [Status]              = @Status,
           [statusInt]           = @statusInt,
           [StartTime]           = COALESCE(@StartTime, tgt.[StartTime]),
           [EndTime]             = COALESCE(@EndTime, tgt.[EndTime]),
           [DurationSeconds]     = CASE
                                       WHEN COALESCE(@EndTime, tgt.[EndTime]) IS NOT NULL
                                        AND COALESCE(@StartTime, tgt.[StartTime]) IS NOT NULL
                                       THEN DATEDIFF(SECOND, COALESCE(@StartTime, tgt.[StartTime]), COALESCE(@EndTime, tgt.[EndTime]))
                                       ELSE tgt.[DurationSeconds]
                                   END,
           [TriggerTime]         = COALESCE(@TriggerTime, tgt.[TriggerTime]),
           [TriggerName]         = COALESCE(@TriggerName, tgt.[TriggerName]),
           [TriggerType]         = COALESCE(@TriggerType, tgt.[TriggerType]),
           [WorkspaceName]       = COALESCE(@WorkspaceName, tgt.[WorkspaceName]),
           [DataFactoryName]     = COALESCE(@DataFactoryName, tgt.[DataFactoryName]),
           [PipelineFolderName]  = COALESCE(@PipelineFolderName, tgt.[PipelineFolderName]),
           [PipelinesExpected]   = COALESCE(@PipelinesExpected, tgt.[PipelinesExpected]),
           [PipelinesStarted]    = COALESCE(@PipelinesStarted, tgt.[PipelinesStarted]),
           [PipelinesSucceeded]  = COALESCE(@PipelinesSucceeded, tgt.[PipelinesSucceeded]),
           [PipelinesFailed]     = COALESCE(@PipelinesFailed, tgt.[PipelinesFailed]),
           [Message]             = COALESCE(@Message, tgt.[Message]),
           [ErrorMessage]        = COALESCE(@ErrorMessage, tgt.[ErrorMessage]),
           [PipelineName_Audit]  = COALESCE(@PipelineName_Audit, tgt.[PipelineName_Audit]),
           [PipelineRunId_Audit] = COALESCE(@PipelineRunId_Audit, tgt.[PipelineRunId_Audit]),
           [PipelineTriggerTime] = COALESCE(@PipelineTriggerTime, tgt.[PipelineTriggerTime]),
           [ModifiedAt]          = SYSUTCDATETIME()
    FROM [stg_bc_api].[PipelineExecutionLog] tgt
    WHERE tgt.[RunGroupId]    = @RunGroupId
      AND tgt.[PipelineLevel] = @PipelineLevel
      AND tgt.[CountryCode]   = ISNULL(@CountryCode, '')
      AND tgt.[PipelineName]  = @PipelineName
      AND tgt.[PipelineRunId] = @PipelineRunId;

    IF @@ROWCOUNT = 0
    BEGIN
        INSERT INTO [stg_bc_api].[PipelineExecutionLog]
        (
            [RunGroupId],
            [PipelineLevel],
            [CountryCode],
            [PipelineName],
            [PipelineRunId],
            [ParentPipelineName],
            [ParentPipelineRunId],
            [Status],
            [statusInt],
            [StartTime],
            [EndTime],
            [DurationSeconds],
            [TriggerTime],
            [TriggerName],
            [TriggerType],
            [WorkspaceName],
            [DataFactoryName],
            [PipelineFolderName],
            [PipelinesExpected],
            [PipelinesStarted],
            [PipelinesSucceeded],
            [PipelinesFailed],
            [Message],
            [ErrorMessage],
            [PipelineName_Audit],
            [PipelineRunId_Audit],
            [PipelineTriggerTime]
        )
        VALUES
        (
            @RunGroupId,
            @PipelineLevel,
            ISNULL(@CountryCode, ''),
            @PipelineName,
            @PipelineRunId,
            @ParentPipelineName,
            @ParentPipelineRunId,
            @Status,
            @statusInt,
            @StartTime,
            @EndTime,
            CASE
                WHEN @StartTime IS NOT NULL AND @EndTime IS NOT NULL
                THEN DATEDIFF(SECOND, @StartTime, @EndTime)
                ELSE NULL
            END,
            @TriggerTime,
            @TriggerName,
            @TriggerType,
            @WorkspaceName,
            @DataFactoryName,
            @PipelineFolderName,
            @PipelinesExpected,
            @PipelinesStarted,
            @PipelinesSucceeded,
            @PipelinesFailed,
            @Message,
            @ErrorMessage,
            @PipelineName_Audit,
            @PipelineRunId_Audit,
            @PipelineTriggerTime
        );
    END
END;

GO

