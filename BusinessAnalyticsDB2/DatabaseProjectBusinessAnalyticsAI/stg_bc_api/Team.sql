CREATE TABLE [stg_bc_api].[Team] (
    [CompanyId]           INT              NOT NULL,
    [code]                NVARCHAR (20)    NOT NULL,
    [name]                NVARCHAR (100)   NULL,
    [blocked]             BIT              NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_Team_ModifiedAt]
    ON [stg_bc_api].[Team]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([code], [name], [blocked]);


GO

CREATE NONCLUSTERED INDEX [IX_Team_Name]
    ON [stg_bc_api].[Team]([CompanyId] ASC, [name] ASC)
    INCLUDE([code], [systemModifiedAt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_Team_Upsert]
    ON [stg_bc_api].[Team]([CompanyId] ASC, [code] ASC);


GO

