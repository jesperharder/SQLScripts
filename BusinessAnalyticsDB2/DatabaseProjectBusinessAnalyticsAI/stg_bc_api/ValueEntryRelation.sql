CREATE TABLE [stg_bc_api].[ValueEntryRelation] (
    [CompanyId]           INT              NOT NULL,
    [valueEntryNo]        INT              NOT NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_ValueEntryRelation] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [valueEntryNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ValueEntryRelation_ModifiedAt]
    ON [stg_bc_api].[ValueEntryRelation]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([valueEntryNo], [systemId]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ValueEntryRelation_Upsert]
    ON [stg_bc_api].[ValueEntryRelation]([CompanyId] ASC, [valueEntryNo] ASC);


GO

