CREATE TABLE [stg_bc_api].[ProdOrderComponent] (
    [CompanyId]           INT                NOT NULL,
    [status]              NVARCHAR (50)      NOT NULL,
    [statusInt]           INT                NULL,
    [prodOrderNo]         NVARCHAR (20)      NOT NULL,
    [prodOrderLineNo]     INT                NOT NULL,
    [lineNo]              INT                NOT NULL,
    [typeInt]             INT                NULL,
    [itemNo]              NVARCHAR (20)      NULL,
    [variantCode]         NVARCHAR (10)      NULL,
    [description]         NVARCHAR (100)     NULL,
    [unitOfMeasureCode]   NVARCHAR (10)      NULL,
    [locationCode]        NVARCHAR (10)      NULL,
    [binCode]             NVARCHAR (20)      NULL,
    [routingLinkCode]     NVARCHAR (20)      NULL,
    [quantityPer]         DECIMAL (18, 5)    NULL,
    [expectedQuantity]    DECIMAL (18, 5)    NULL,
    [expectedQtyBase]     DECIMAL (18, 5)    NULL,
    [remainingQuantity]   DECIMAL (18, 5)    NULL,
    [remainingQtyBase]    DECIMAL (18, 5)    NULL,
    [scrapPercent]        DECIMAL (18, 5)    NULL,
    [indirectCostPct]     DECIMAL (18, 5)    NULL,
    [dueDate]             DATE               NULL,
    [flushingMethod]      NVARCHAR (50)      NULL,
    [flushingMethodInt]   INT                NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ProdOrderComponent] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [status] ASC, [prodOrderNo] ASC, [prodOrderLineNo] ASC, [lineNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ProdOrderComponent_Lookups]
    ON [stg_bc_api].[ProdOrderComponent]([CompanyId] ASC, [prodOrderNo] ASC, [prodOrderLineNo] ASC)
    INCLUDE([status], [lineNo], [itemNo], [variantCode], [unitOfMeasureCode], [locationCode], [binCode], [statusInt], [typeInt], [flushingMethodInt], [remainingQuantity], [remainingQtyBase], [dueDate]);


GO

CREATE NONCLUSTERED INDEX [IX_ProdOrderComponent_SystemModifiedAt]
    ON [stg_bc_api].[ProdOrderComponent]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([status], [prodOrderNo], [prodOrderLineNo], [lineNo]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ProdOrderComponent_UpsertKey]
    ON [stg_bc_api].[ProdOrderComponent]([CompanyId] ASC, [status] ASC, [prodOrderNo] ASC, [prodOrderLineNo] ASC, [lineNo] ASC);


GO

