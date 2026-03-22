CREATE TABLE [stg_bc_api].[ItemUnitofMeasure] (
    [CompanyId]           INT                NOT NULL,
    [itemNo]              NVARCHAR (20)      NOT NULL,
    [code]                NVARCHAR (10)      NOT NULL,
    [qtyPerUnitOfMeasure] DECIMAL (38, 20)   NULL,
    [length]              DECIMAL (38, 20)   NULL,
    [width]               DECIMAL (38, 20)   NULL,
    [height]              DECIMAL (38, 20)   NULL,
    [cubage]              DECIMAL (38, 20)   NULL,
    [weight]              DECIMAL (38, 20)   NULL,
    [itemDescription]     NVARCHAR (100)     NULL,
    [uomDescription]      NVARCHAR (100)     NULL,
    [additionalCaption]   NVARCHAR (150)     NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]     DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_stg_ItemUnitofMeasure] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [itemNo] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_stg_ItemUnitofMeasure_Watermark]
    ON [stg_bc_api].[ItemUnitofMeasure]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_stg_ItemUnitofMeasure_Item]
    ON [stg_bc_api].[ItemUnitofMeasure]([CompanyId] ASC, [itemNo] ASC);


GO

