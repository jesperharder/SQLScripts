CREATE TABLE [stg_bc_api].[ProductionBOMHeader] (
    [CompanyId]           INT              NOT NULL,
    [no]                  NVARCHAR (20)    NOT NULL,
    [description]         NVARCHAR (100)   NULL,
    [description2]        NVARCHAR (50)    NULL,
    [searchName]          NVARCHAR (100)   NULL,
    [unitOfMeasureCode]   NVARCHAR (10)    NULL,
    [lowLevelCode]        INT              NULL,
    [comment]             BIT              NULL,
    [creationDate]        DATE             NULL,
    [lastDateModified]    DATE             NULL,
    [status]              NVARCHAR (50)    NULL,
    [statusInt]           INT              NULL,
    [versionNos]          NVARCHAR (20)    NULL,
    [noSeries]            NVARCHAR (20)    NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (64)    NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_ProductionBOMHeader] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ProductionBOMHeader_Upsert]
    ON [stg_bc_api].[ProductionBOMHeader]([CompanyId] ASC, [no] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ProductionBOMHeader_SystemModifiedAt]
    ON [stg_bc_api].[ProductionBOMHeader]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

