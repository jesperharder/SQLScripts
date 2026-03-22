CREATE TABLE [stg_bc_api].[Stop] (
    [CompanyId]           INT              NOT NULL,
    [code]                NVARCHAR (20)    NOT NULL,
    [description]         NVARCHAR (100)   NULL,
    [blocked]             BIT              NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_Stop] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_Stop_Upsert]
    ON [stg_bc_api].[Stop]([CompanyId] ASC, [code] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Stop_ModifiedAt]
    ON [stg_bc_api].[Stop]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([code], [description], [blocked]);


GO

CREATE NONCLUSTERED INDEX [IX_Stop_Description]
    ON [stg_bc_api].[Stop]([CompanyId] ASC, [description] ASC)
    INCLUDE([code], [systemModifiedAt]);


GO

