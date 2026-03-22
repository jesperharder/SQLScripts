CREATE TABLE [stg_bc].[TeamSalesperson] (
    [timestamp]           VARBINARY (8)    NOT NULL,
    [Team Code]           NVARCHAR (20)    NOT NULL,
    [Salesperson Code]    NVARCHAR (20)    NOT NULL,
    [$systemId]           UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]    DATETIME         NULL,
    [$systemCreatedBy]    UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]   DATETIME         NULL,
    [$systemModifiedBy]   UNIQUEIDENTIFIER NULL,
    [PipelineName]        NVARCHAR (MAX)   NULL,
    [PipelineRunId]       NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime] NVARCHAR (MAX)   NULL,
    [CompanyID]           INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_TeamSalesperson] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Team Code] ASC, [Salesperson Code] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_TeamSalesperson_timestamp]
    ON [stg_bc].[TeamSalesperson]([CompanyID] ASC, [timestamp] ASC) WITH (DATA_COMPRESSION = ROW);


GO

