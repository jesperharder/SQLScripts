CREATE TABLE [stg_bc_api].[ProductionOrder] (
    [CompanyId]           INT                NOT NULL,
    [status]              NVARCHAR (50)      NOT NULL,
    [statusInt]           INT                NULL,
    [no]                  NVARCHAR (20)      NOT NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [description]         NVARCHAR (100)     NULL,
    [variantCode]         NVARCHAR (10)      NULL,
    [locationCode]        NVARCHAR (10)      NULL,
    [binCode]             NVARCHAR (20)      NULL,
    [routingNo]           NVARCHAR (20)      NULL,
    [quantity]            DECIMAL (18, 5)    NULL,
    [startingDate]        DATE               NULL,
    [endingDate]          DATE               NULL,
    [dueDate]             DATE               NULL,
    [assignedUserId]      NVARCHAR (50)      NULL,
    [shortcutDim1Code]    NVARCHAR (20)      NULL,
    [shortcutDim2Code]    NVARCHAR (20)      NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ProductionOrder] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [status] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ProductionOrder_SystemModifiedAt]
    ON [stg_bc_api].[ProductionOrder]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([status], [no], [statusInt], [dueDate]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ProductionOrder_UpsertKey]
    ON [stg_bc_api].[ProductionOrder]([CompanyId] ASC, [status] ASC, [no] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ProductionOrder_Lookups]
    ON [stg_bc_api].[ProductionOrder]([CompanyId] ASC, [no] ASC)
    INCLUDE([status], [statusInt], [startingDate], [endingDate], [dueDate], [locationCode], [routingNo], [quantity], [shortcutDim1Code], [shortcutDim2Code]);


GO

