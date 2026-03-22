CREATE TABLE [stg_bc_api].[DimensionSetEntry] (
    [CompanyId]           INT                NOT NULL,
    [dimensionSetId]      INT                NOT NULL,
    [dimensionCode]       NVARCHAR (20)      NOT NULL,
    [dimensionValueCode]  NVARCHAR (20)      NULL,
    [dimensionValueId]    INT                NULL,
    [globalDimensionNo]   INT                NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]     DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       NVARCHAR (100)     NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_DimensionSetEntry] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [dimensionSetId] ASC, [dimensionCode] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_DimensionSetEntry_Company_SystemModified]
    ON [stg_bc_api].[DimensionSetEntry]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

