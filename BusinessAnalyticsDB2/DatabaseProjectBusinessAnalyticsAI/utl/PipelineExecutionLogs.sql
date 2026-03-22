CREATE TABLE [utl].[PipelineExecutionLogs] (
    [LogID]           INT            IDENTITY (1, 1) NOT NULL,
    [PipelineName]    NVARCHAR (255) NOT NULL,
    [ActivityName]    NVARCHAR (255) NULL,
    [ExecutionStatus] NVARCHAR (50)  NOT NULL,
    [Message]         NVARCHAR (MAX) NULL,
    [StartTime]       DATETIME       NULL,
    [EndTime]         DATETIME       NULL,
    [Duration]        AS             (datediff(second,[StartTime],[EndTime])) PERSISTED,
    [CreatedAt]       DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);


GO

