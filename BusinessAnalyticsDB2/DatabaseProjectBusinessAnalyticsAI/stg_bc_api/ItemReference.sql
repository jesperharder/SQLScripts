CREATE TABLE [stg_bc_api].[ItemReference] (
    [CompanyId]           INT                NOT NULL,
    [itemNo]              NVARCHAR (20)      NOT NULL,
    [variantCode]         NVARCHAR (10)      NOT NULL,
    [unitOfMeasure]       NVARCHAR (10)      NOT NULL,
    [referenceType]       NVARCHAR (50)      NOT NULL,
    [referenceTypeInt]    INT                NULL,
    [referenceTypeNo]     NVARCHAR (20)      NOT NULL,
    [referenceNo]         NVARCHAR (50)      NOT NULL,
    [description]         NVARCHAR (100)     NULL,
    [description2]        NVARCHAR (50)      NULL,
    [subjectName]         NVARCHAR (100)     NULL,
    [additionalCaption]   NVARCHAR (150)     NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ItemReference] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [itemNo] ASC, [variantCode] ASC, [unitOfMeasure] ASC, [referenceType] ASC, [referenceTypeNo] ASC, [referenceNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ItemReference_Company_Item_ReferenceNo]
    ON [stg_bc_api].[ItemReference]([CompanyId] ASC, [itemNo] ASC, [referenceNo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ItemReference_Company_SystemModifiedAt]
    ON [stg_bc_api].[ItemReference]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ItemReference_Company_ReferenceNo]
    ON [stg_bc_api].[ItemReference]([CompanyId] ASC, [referenceNo] ASC);


GO

