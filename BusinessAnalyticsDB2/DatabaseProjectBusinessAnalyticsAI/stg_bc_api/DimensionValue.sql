CREATE TABLE [stg_bc_api].[DimensionValue] (
    [CompanyId]                 INT                NOT NULL,
    [code]                      NVARCHAR (20)      NOT NULL,
    [dimensionCode]             NVARCHAR (20)      NOT NULL,
    [consolidationCode]         NVARCHAR (20)      NULL,
    [dimensionId]               UNIQUEIDENTIFIER   NULL,
    [dimensionValueID]          INT                NULL,
    [dimensionValueType]        NVARCHAR (50)      NULL,
    [dimensionValueTypeInt]     INT                NULL,
    [globalDimensionNo]         INT                NULL,
    [indentation]               INT                NULL,
    [lastModifiedDateTime]      DATETIMEOFFSET (7) NULL,
    [mapToICDimensionCode]      NVARCHAR (20)      NULL,
    [mapToICDimensionValueCode] NVARCHAR (20)      NULL,
    [name]                      NVARCHAR (100)     NULL,
    [totaling]                  NVARCHAR (MAX)     NULL,
    [systemId]                  UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]           DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]           UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]          DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]          UNIQUEIDENTIFIER   NULL,
    [PipelineName]              NVARCHAR (200)     NULL,
    [PipelineRunId]             NVARCHAR (100)     NULL,
    [PipelineTriggerTime]       DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_DimensionValue] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [dimensionCode] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_DimensionValue_Company_SystemModified]
    ON [stg_bc_api].[DimensionValue]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

