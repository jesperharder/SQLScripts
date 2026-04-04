CREATE TABLE [stg_bc_api].[ProdOrderLine] (
    [CompanyId]           INT                NOT NULL,
    [status]              NVARCHAR (50)      NOT NULL,
    [statusInt]           INT                NULL,
    [prodOrderNo]         NVARCHAR (20)      NOT NULL,
    [lineNo]              INT                NOT NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [itemNo]              NVARCHAR (20)      NULL,
    [variantCode]         NVARCHAR (10)      NULL,
    [description]         NVARCHAR (100)     NULL,
    [unitOfMeasureCode]   NVARCHAR (10)      NULL,
    [locationCode]        NVARCHAR (10)      NULL,
    [binCode]             NVARCHAR (20)      NULL,
    [productionBOMNo]     NVARCHAR (20)      NULL,
    [routingNo]           NVARCHAR (20)      NULL,
    [routingRefNo]        INT                NULL,
    [quantity]            DECIMAL (18, 5)    NULL,
    [quantityBase]        DECIMAL (18, 5)    NULL,
    [remainingQuantity]   DECIMAL (18, 5)    NULL,
    [finishedQuantity]    DECIMAL (18, 5)    NULL,
    [scrapPercent]        DECIMAL (18, 5)    NULL,
    [startingDate]        DATE               NULL,
    [endingDate]          DATE               NULL,
    [dueDate]             DATE               NULL,
    [startingDateTime]    DATETIME2 (7)      NULL,
    [endingDateTime]      DATETIME2 (7)      NULL,
    [dimensionSetId]      INT                NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ProdOrderLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [status] ASC, [prodOrderNo] ASC, [lineNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ProdOrderLine_SystemModifiedAt]
    ON [stg_bc_api].[ProdOrderLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([status], [prodOrderNo], [lineNo]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ProdOrderLine_UpsertKey]
    ON [stg_bc_api].[ProdOrderLine]([CompanyId] ASC, [status] ASC, [prodOrderNo] ASC, [lineNo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ProdOrderLine_Lookups]
    ON [stg_bc_api].[ProdOrderLine]([CompanyId] ASC, [prodOrderNo] ASC)
    INCLUDE([status], [lineNo], [itemNo], [variantCode], [unitOfMeasureCode], [locationCode], [binCode], [productionBOMNo], [routingNo], [routingRefNo], [remainingQuantity], [finishedQuantity], [dueDate], [startingDateTime], [endingDateTime], [dimensionSetId]);


GO

