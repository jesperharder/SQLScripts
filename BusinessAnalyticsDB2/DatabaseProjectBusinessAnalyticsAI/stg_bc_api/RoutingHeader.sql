CREATE TABLE [stg_bc_api].[RoutingHeader] (
    [CompanyId]           INT                NOT NULL,
    [no]                  NVARCHAR (20)      NOT NULL,
    [type]                NVARCHAR (50)      NULL,
    [typeInt]             INT                NULL,
    [description]         NVARCHAR (100)     NULL,
    [status]              NVARCHAR (50)      NULL,
    [statusInt]           INT                NULL,
    [versionNos]          NVARCHAR (20)      NULL,
    [lastDateModified]    DATE               NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_RoutingHeader] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_RoutingHeader_Status]
    ON [stg_bc_api].[RoutingHeader]([CompanyId] ASC, [statusInt] ASC)
    INCLUDE([no], [type], [typeInt], [description], [lastDateModified], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_RoutingHeader_ModifiedAt]
    ON [stg_bc_api].[RoutingHeader]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([no], [type], [typeInt], [description], [status], [statusInt], [lastDateModified]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_RoutingHeader_Upsert]
    ON [stg_bc_api].[RoutingHeader]([CompanyId] ASC, [no] ASC);


GO

