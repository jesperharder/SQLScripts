CREATE TABLE [stg_bc_api].[ProdBOMLineScrap] (
    [CompanyId]           INT                NOT NULL,
    [productionBOMNo]     NVARCHAR (20)      NOT NULL,
    [versionCode]         NVARCHAR (20)      NOT NULL,
    [lineNo]              INT                NOT NULL,
    [no]                  NVARCHAR (20)      NULL,
    [routingLinkCode]     NVARCHAR (20)      NULL,
    [position]            NVARCHAR (10)      NULL,
    [scrapPercent]        DECIMAL (18, 5)    NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ProdBOMLineScrap] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [productionBOMNo] ASC, [versionCode] ASC, [lineNo] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ProdBOMLineScrap_UpsertKey]
    ON [stg_bc_api].[ProdBOMLineScrap]([CompanyId] ASC, [productionBOMNo] ASC, [versionCode] ASC, [lineNo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ProdBOMLineScrap_Lookups]
    ON [stg_bc_api].[ProdBOMLineScrap]([CompanyId] ASC, [productionBOMNo] ASC, [versionCode] ASC)
    INCLUDE([lineNo], [no], [routingLinkCode], [position], [scrapPercent]);


GO

CREATE NONCLUSTERED INDEX [IX_ProdBOMLineScrap_SystemModifiedAt]
    ON [stg_bc_api].[ProdBOMLineScrap]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([productionBOMNo], [versionCode], [lineNo], [no]);


GO

