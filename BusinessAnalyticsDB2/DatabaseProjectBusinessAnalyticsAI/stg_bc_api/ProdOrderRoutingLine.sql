CREATE TABLE [stg_bc_api].[ProdOrderRoutingLine] (
    [CompanyId]           INT                NOT NULL,
    [status]              NVARCHAR (50)      NOT NULL,
    [statusInt]           INT                NULL,
    [prodOrderNo]         NVARCHAR (20)      NOT NULL,
    [routingRefNo]        INT                NOT NULL,
    [operationNo]         NVARCHAR (30)      NOT NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [nextOperationNo]     NVARCHAR (30)      NULL,
    [type]                NVARCHAR (50)      NULL,
    [typeInt]             INT                NULL,
    [workCenterNo]        NVARCHAR (20)      NULL,
    [routingNo]           NVARCHAR (20)      NULL,
    [setupTime]           DECIMAL (18, 5)    NULL,
    [runTime]             DECIMAL (18, 5)    NULL,
    [waitTime]            DECIMAL (18, 5)    NULL,
    [moveTime]            DECIMAL (18, 5)    NULL,
    [locationCode]        NVARCHAR (10)      NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ProdOrderRoutingLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [status] ASC, [prodOrderNo] ASC, [routingRefNo] ASC, [operationNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ProdOrderRoutingLine_SystemModifiedAt]
    ON [stg_bc_api].[ProdOrderRoutingLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([status], [prodOrderNo], [routingRefNo], [operationNo]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ProdOrderRoutingLine_UpsertKey]
    ON [stg_bc_api].[ProdOrderRoutingLine]([CompanyId] ASC, [status] ASC, [prodOrderNo] ASC, [routingRefNo] ASC, [operationNo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ProdOrderRoutingLine_Lookups]
    ON [stg_bc_api].[ProdOrderRoutingLine]([CompanyId] ASC, [prodOrderNo] ASC, [routingRefNo] ASC)
    INCLUDE([status], [operationNo], [nextOperationNo], [typeInt], [workCenterNo], [routingNo], [setupTime], [runTime], [waitTime], [moveTime], [locationCode]);


GO

