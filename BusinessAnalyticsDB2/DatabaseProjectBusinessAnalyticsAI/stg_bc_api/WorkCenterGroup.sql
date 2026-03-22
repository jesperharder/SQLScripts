CREATE TABLE [stg_bc_api].[WorkCenterGroup] (
    [CompanyId]           INT                NOT NULL,
    [code]                NVARCHAR (10)      NOT NULL,
    [name]                NVARCHAR (50)      NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_WorkCenterGroup] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_WorkCenterGroup_SystemModifiedAt]
    ON [stg_bc_api].[WorkCenterGroup]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([code], [name]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_WorkCenterGroup_Upsert]
    ON [stg_bc_api].[WorkCenterGroup]([CompanyId] ASC, [code] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_WorkCenterGroup_Name]
    ON [stg_bc_api].[WorkCenterGroup]([CompanyId] ASC, [name] ASC)
    INCLUDE([code], [systemModifiedAt]);


GO

