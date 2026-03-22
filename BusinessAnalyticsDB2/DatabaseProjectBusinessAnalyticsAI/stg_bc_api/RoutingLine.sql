CREATE TABLE [stg_bc_api].[RoutingLine] (
    [CompanyId]           INT              NOT NULL,
    [routingNo]           NVARCHAR (20)    NOT NULL,
    [versionCode]         NVARCHAR (20)    NOT NULL,
    [operationNo]         NVARCHAR (10)    NOT NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [nextOperationNo]     NVARCHAR (10)    NULL,
    [type]                NVARCHAR (50)    NULL,
    [typeInt]             INT              NULL,
    [no]                  NVARCHAR (20)    NULL,
    [setupTime]           DECIMAL (38, 20) NULL,
    [runTime]             DECIMAL (38, 20) NULL,
    [waitTime]            DECIMAL (38, 20) NULL,
    [moveTime]            DECIMAL (38, 20) NULL,
    [standardTaskCode]    NVARCHAR (20)    NULL,
    [routingLinkCode]     NVARCHAR (20)    NULL,
    [minimumProcessTime]  DECIMAL (38, 20) NULL,
    [maximumProcessTime]  DECIMAL (38, 20) NULL,
    [lotSize]             DECIMAL (38, 20) NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_RoutingLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [routingNo] ASC, [versionCode] ASC, [operationNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_RoutingLine_ModifiedAt]
    ON [stg_bc_api].[RoutingLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([routingNo], [versionCode], [operationNo]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_RoutingLine_Upsert]
    ON [stg_bc_api].[RoutingLine]([CompanyId] ASC, [routingNo] ASC, [versionCode] ASC, [operationNo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_RoutingLine_Capacity]
    ON [stg_bc_api].[RoutingLine]([CompanyId] ASC, [typeInt] ASC, [no] ASC)
    INCLUDE([routingNo], [versionCode], [operationNo], [setupTime], [runTime], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_RoutingLine_Routing]
    ON [stg_bc_api].[RoutingLine]([CompanyId] ASC, [routingNo] ASC, [versionCode] ASC)
    INCLUDE([operationNo], [nextOperationNo], [type], [typeInt], [no], [setupTime], [runTime], [waitTime], [moveTime], [standardTaskCode], [routingLinkCode], [minimumProcessTime], [maximumProcessTime], [lotSize], [systemModifiedAt]);


GO

