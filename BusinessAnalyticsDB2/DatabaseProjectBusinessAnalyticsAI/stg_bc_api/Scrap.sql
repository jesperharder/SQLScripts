CREATE TABLE [stg_bc_api].[Scrap] (
    [CompanyId]           INT                NOT NULL,
    [code]                NVARCHAR (20)      NOT NULL,
    [description]         NVARCHAR (100)     NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_Scrap] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_Scrap_CodeLookup]
    ON [stg_bc_api].[Scrap]([CompanyId] ASC, [code] ASC)
    INCLUDE([description], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_Scrap_SystemModifiedAt]
    ON [stg_bc_api].[Scrap]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([code], [description]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_Scrap_Upsert]
    ON [stg_bc_api].[Scrap]([CompanyId] ASC, [code] ASC);


GO

