CREATE TABLE [stg_bc_api].[DefaultDimension] (
    [CompanyId]           INT                NOT NULL,
    [tableId]             INT                NOT NULL,
    [no]                  NVARCHAR (20)      NOT NULL,
    [dimensionCode]       NVARCHAR (20)      NOT NULL,
    [dimensionValueCode]  NVARCHAR (20)      NULL,
    [valuePosting]        NVARCHAR (50)      NULL,
    [valuePostingInt]     INT                NULL,
    [tableIdInt]          INT                NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]     DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       NVARCHAR (100)     NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_DefaultDimension] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [tableId] ASC, [no] ASC, [dimensionCode] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_DefaultDimension_Company_SystemModified]
    ON [stg_bc_api].[DefaultDimension]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

