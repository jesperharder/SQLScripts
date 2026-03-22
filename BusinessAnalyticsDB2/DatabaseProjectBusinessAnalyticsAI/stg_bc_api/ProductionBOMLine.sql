CREATE TABLE [stg_bc_api].[ProductionBOMLine] (
    [CompanyId]           INT                NOT NULL,
    [productionBOMNo]     NVARCHAR (20)      NOT NULL,
    [versionCode]         NVARCHAR (20)      NOT NULL,
    [lineNo]              INT                NOT NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [type]                NVARCHAR (50)      NULL,
    [typeInt]             INT                NULL,
    [no]                  NVARCHAR (20)      NULL,
    [variantCode]         NVARCHAR (10)      NULL,
    [description]         NVARCHAR (100)     NULL,
    [unitOfMeasureCode]   NVARCHAR (10)      NULL,
    [quantityPer]         DECIMAL (18, 5)    NULL,
    [scrapPercent]        DECIMAL (18, 5)    NULL,
    [routingLinkCode]     NVARCHAR (20)      NULL,
    [position]            NVARCHAR (10)      NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ProductionBOMLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [productionBOMNo] ASC, [versionCode] ASC, [lineNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ProductionBOMLine_BOMVersion]
    ON [stg_bc_api].[ProductionBOMLine]([CompanyId] ASC, [productionBOMNo] ASC, [versionCode] ASC)
    INCLUDE([lineNo], [typeInt], [no], [variantCode], [unitOfMeasureCode], [quantityPer], [scrapPercent], [routingLinkCode], [position]);


GO

CREATE NONCLUSTERED INDEX [IX_ProductionBOMLine_SystemModifiedAt]
    ON [stg_bc_api].[ProductionBOMLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([productionBOMNo], [versionCode], [lineNo], [no], [typeInt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ProductionBOMLine_UpsertKey]
    ON [stg_bc_api].[ProductionBOMLine]([CompanyId] ASC, [productionBOMNo] ASC, [versionCode] ASC, [lineNo] ASC);


GO

