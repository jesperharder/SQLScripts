CREATE TABLE [stg_bc_api].[PipelineExecutionLog] (
    [LogId]               BIGINT           IDENTITY (1, 1) NOT NULL,
    [RunGroupId]          UNIQUEIDENTIFIER NOT NULL,
    [PipelineLevel]       NVARCHAR (20)    NOT NULL,
    [CountryCode]         NVARCHAR (10)    CONSTRAINT [DF_PipelineExecutionLog_CountryCode] DEFAULT ('') NOT NULL,
    [PipelineName]        NVARCHAR (200)   NOT NULL,
    [PipelineRunId]       NVARCHAR (100)   NOT NULL,
    [ParentPipelineName]  NVARCHAR (200)   NULL,
    [ParentPipelineRunId] NVARCHAR (100)   NULL,
    [Status]              NVARCHAR (30)    NOT NULL,
    [statusInt]           TINYINT          NOT NULL,
    [StartTime]           DATETIME2 (0)    NULL,
    [EndTime]             DATETIME2 (0)    NULL,
    [DurationSeconds]     INT              NULL,
    [TriggerTime]         DATETIME2 (0)    NULL,
    [TriggerName]         NVARCHAR (200)   NULL,
    [TriggerType]         NVARCHAR (100)   NULL,
    [WorkspaceName]       NVARCHAR (200)   NULL,
    [DataFactoryName]     NVARCHAR (200)   NULL,
    [PipelineFolderName]  NVARCHAR (300)   NULL,
    [PipelinesExpected]   INT              NULL,
    [PipelinesStarted]    INT              NULL,
    [PipelinesSucceeded]  INT              NULL,
    [PipelinesFailed]     INT              NULL,
    [Message]             NVARCHAR (1000)  NULL,
    [ErrorMessage]        NVARCHAR (4000)  NULL,
    [PipelineName_Audit]  NVARCHAR (200)   NULL,
    [PipelineRunId_Audit] NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (0)    NULL,
    [CreatedAt]           DATETIME2 (0)    CONSTRAINT [DF_PipelineExecutionLog_CreatedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedAt]          DATETIME2 (0)    CONSTRAINT [DF_PipelineExecutionLog_ModifiedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PipelineExecutionLog] PRIMARY KEY CLUSTERED ([LogId] ASC),
    CONSTRAINT [CK_PipelineExecutionLog_PipelineLevel] CHECK ([PipelineLevel]='Child' OR [PipelineLevel]='Country' OR [PipelineLevel]='Master'),
    CONSTRAINT [CK_PipelineExecutionLog_Status] CHECK ([Status]='CompletedWithErrors' OR [Status]='Failed' OR [Status]='Succeeded' OR [Status]='Started')
);


GO

CREATE NONCLUSTERED INDEX [IX_PipelineExecutionLog_ModifiedAt]
    ON [stg_bc_api].[PipelineExecutionLog]([ModifiedAt] ASC)
    INCLUDE([RunGroupId], [PipelineLevel], [CountryCode], [PipelineName], [Status]);


GO

CREATE NONCLUSTERED INDEX [IX_PipelineExecutionLog_RunGroup_Status]
    ON [stg_bc_api].[PipelineExecutionLog]([RunGroupId] ASC, [Status] ASC)
    INCLUDE([PipelineLevel], [CountryCode], [PipelineName], [PipelineRunId], [ErrorMessage]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_PipelineExecutionLog_RunKey]
    ON [stg_bc_api].[PipelineExecutionLog]([RunGroupId] ASC, [PipelineLevel] ASC, [CountryCode] ASC, [PipelineName] ASC, [PipelineRunId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_PipelineExecutionLog_RunGroup_Level_Country]
    ON [stg_bc_api].[PipelineExecutionLog]([RunGroupId] ASC, [PipelineLevel] ASC, [CountryCode] ASC)
    INCLUDE([Status], [statusInt], [StartTime], [EndTime], [DurationSeconds], [PipelinesExpected], [PipelinesStarted], [PipelinesSucceeded], [PipelinesFailed], [ErrorMessage]);


GO

