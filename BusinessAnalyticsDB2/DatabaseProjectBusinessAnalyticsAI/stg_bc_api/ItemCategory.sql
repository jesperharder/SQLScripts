CREATE TABLE [stg_bc_api].[ItemCategory] (
    [CompanyId]                 INT                NOT NULL,
    [code]                      NVARCHAR (20)      NOT NULL,
    [description]               NVARCHAR (100)     NULL,
    [parentCategory]            NVARCHAR (20)      NULL,
    [parentCategoryDescription] NVARCHAR (100)     NULL,
    [parentCategorySystemId]    UNIQUEIDENTIFIER   NULL,
    [additionalCaption]         NVARCHAR (150)     NULL,
    [systemId]                  UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]           DATETIME2 (7)      NULL,
    [systemCreatedBy]           UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]          DATETIME2 (7)      NULL,
    [systemModifiedBy]          UNIQUEIDENTIFIER   NULL,
    [PipelineName]              NVARCHAR (200)     NULL,
    [PipelineRunId]             UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime]       DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ItemCategory] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ItemCategory_Company_SystemModifiedAt]
    ON [stg_bc_api].[ItemCategory]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ItemCategory_Company_ParentCategory]
    ON [stg_bc_api].[ItemCategory]([CompanyId] ASC, [parentCategory] ASC);


GO

