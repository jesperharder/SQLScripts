CREATE TABLE [stg_bc_api].[TariffNumber] (
    [CompanyId]           INT              NOT NULL,
    [code]                NVARCHAR (20)    NOT NULL,
    [description]         NVARCHAR (100)   NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_TariffNumber] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_TariffNumber_Upsert]
    ON [stg_bc_api].[TariffNumber]([CompanyId] ASC, [code] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TariffNumber_ModifiedAt]
    ON [stg_bc_api].[TariffNumber]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([code], [description]);


GO

CREATE NONCLUSTERED INDEX [IX_TariffNumber_Description]
    ON [stg_bc_api].[TariffNumber]([CompanyId] ASC, [description] ASC)
    INCLUDE([code], [systemModifiedAt]);


GO

