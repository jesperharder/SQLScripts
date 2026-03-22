CREATE TABLE [stg_bc].[Campaign] (
    [timestamp]               VARBINARY (8)    NOT NULL,
    [No_]                     NVARCHAR (20)    NOT NULL,
    [Description]             NVARCHAR (100)   NULL,
    [Starting Date]           DATETIME         NULL,
    [Ending Date]             DATETIME         NULL,
    [Salesperson Code]        NVARCHAR (20)    NULL,
    [Last Date Modified]      DATETIME         NULL,
    [No_ Series]              NVARCHAR (20)    NULL,
    [Global Dimension 1 Code] NVARCHAR (20)    NULL,
    [Global Dimension 2 Code] NVARCHAR (20)    NULL,
    [Status Code]             NVARCHAR (10)    NULL,
    [$systemId]               UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]        DATETIME         NULL,
    [$systemCreatedBy]        UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]       DATETIME         NULL,
    [$systemModifiedBy]       UNIQUEIDENTIFIER NULL,
    [PipelineName]            NVARCHAR (MAX)   NULL,
    [PipelineRunId]           NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]     NVARCHAR (MAX)   NULL,
    [CompanyID]               INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_Campaign] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_Campaign_timestamp]
    ON [stg_bc].[Campaign]([CompanyID] ASC, [timestamp] ASC);


GO

