CREATE TABLE [stg_bc_api].[UnitOfMeasure] (
    [CompanyId]                 INT              NOT NULL,
    [code]                      NVARCHAR (10)    NOT NULL,
    [description]               NVARCHAR (100)   NULL,
    [internationalStandardCode] NVARCHAR (10)    NULL,
    [systemId]                  UNIQUEIDENTIFIER NULL,
    [systemCreatedAt]           DATETIME2 (7)    NULL,
    [systemCreatedBy]           NVARCHAR (250)   NULL,
    [systemModifiedAt]          DATETIME2 (7)    NULL,
    [systemModifiedBy]          NVARCHAR (250)   NULL,
    [PipelineName]              NVARCHAR (200)   NULL,
    [PipelineRunId]             NVARCHAR (100)   NULL,
    [PipelineTriggerTime]       DATETIME2 (7)    NULL,
    CONSTRAINT [PK_UnitOfMeasure] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_UnitOfMeasure_ISO]
    ON [stg_bc_api].[UnitOfMeasure]([CompanyId] ASC, [internationalStandardCode] ASC)
    INCLUDE([code], [description], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_UnitOfMeasure_Description]
    ON [stg_bc_api].[UnitOfMeasure]([CompanyId] ASC, [description] ASC)
    INCLUDE([code], [internationalStandardCode], [systemModifiedAt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_UnitOfMeasure_Upsert]
    ON [stg_bc_api].[UnitOfMeasure]([CompanyId] ASC, [code] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_UnitOfMeasure_ModifiedAt]
    ON [stg_bc_api].[UnitOfMeasure]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([code], [description], [internationalStandardCode]);


GO

