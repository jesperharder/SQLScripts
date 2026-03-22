CREATE TABLE [stg_bc_api].[StockkeepingUnit] (
    [CompanyId]              INT              NOT NULL,
    [itemNo]                 NVARCHAR (20)    NOT NULL,
    [variantCode]            NVARCHAR (10)    NOT NULL,
    [locationCode]           NVARCHAR (10)    NOT NULL,
    [systemId]               UNIQUEIDENTIFIER NULL,
    [replenishmentSystem]    NVARCHAR (50)    NULL,
    [replenishmentSystemInt] INT              NULL,
    [reorderingPolicy]       NVARCHAR (50)    NULL,
    [reorderingPolicyInt]    INT              NULL,
    [planningFlexibility]    NVARCHAR (50)    NULL,
    [planningFlexibilityInt] INT              NULL,
    [flushingMethod]         NVARCHAR (50)    NULL,
    [flushingMethodInt]      INT              NULL,
    [vendorNo]               NVARCHAR (20)    NULL,
    [leadTimeCalculation]    NVARCHAR (32)    NULL,
    [safetyLeadTime]         NVARCHAR (32)    NULL,
    [reorderPoint]           DECIMAL (38, 20) NULL,
    [reorderQuantity]        DECIMAL (38, 20) NULL,
    [maximumInventory]       DECIMAL (38, 20) NULL,
    [orderMultiple]          DECIMAL (38, 20) NULL,
    [minimumOrderQty]        DECIMAL (38, 20) NULL,
    [maximumOrderQty]        DECIMAL (38, 20) NULL,
    [lotAccumulationPeriod]  NVARCHAR (32)    NULL,
    [shelfNo]                NVARCHAR (10)    NULL,
    [assemblyPolicy]         NVARCHAR (50)    NULL,
    [productionBOMNo]        NVARCHAR (20)    NULL,
    [routingNo]              NVARCHAR (20)    NULL,
    [safetyStockQty]         DECIMAL (38, 20) NULL,
    [overflowLevel]          DECIMAL (38, 20) NULL,
    [putAwayTemplateCode]    NVARCHAR (10)    NULL,
    [systemCreatedAt]        DATETIME2 (7)    NULL,
    [systemCreatedBy]        NVARCHAR (250)   NULL,
    [systemModifiedAt]       DATETIME2 (7)    NULL,
    [systemModifiedBy]       NVARCHAR (250)   NULL,
    [PipelineName]           NVARCHAR (200)   NULL,
    [PipelineRunId]          NVARCHAR (100)   NULL,
    [PipelineTriggerTime]    DATETIME2 (7)    NULL,
    CONSTRAINT [PK_StockkeepingUnit] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [itemNo] ASC, [variantCode] ASC, [locationCode] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_StockkeepingUnit_ModifiedAt]
    ON [stg_bc_api].[StockkeepingUnit]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([itemNo], [variantCode], [locationCode]);


GO

CREATE NONCLUSTERED INDEX [IX_StockkeepingUnit_PlanningPolicy]
    ON [stg_bc_api].[StockkeepingUnit]([CompanyId] ASC, [replenishmentSystemInt] ASC, [reorderingPolicyInt] ASC)
    INCLUDE([itemNo], [variantCode], [locationCode], [vendorNo], [reorderPoint], [reorderQuantity], [maximumInventory], [orderMultiple], [minimumOrderQty], [maximumOrderQty], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_StockkeepingUnit_Vendor]
    ON [stg_bc_api].[StockkeepingUnit]([CompanyId] ASC, [vendorNo] ASC)
    INCLUDE([itemNo], [variantCode], [locationCode], [replenishmentSystemInt], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_StockkeepingUnit_RoutingBOM]
    ON [stg_bc_api].[StockkeepingUnit]([CompanyId] ASC, [routingNo] ASC, [productionBOMNo] ASC)
    INCLUDE([itemNo], [variantCode], [locationCode], [systemModifiedAt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_StockkeepingUnit_Upsert]
    ON [stg_bc_api].[StockkeepingUnit]([CompanyId] ASC, [itemNo] ASC, [variantCode] ASC, [locationCode] ASC);


GO

