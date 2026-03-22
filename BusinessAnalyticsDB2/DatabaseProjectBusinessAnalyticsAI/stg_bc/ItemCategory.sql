CREATE TABLE [stg_bc].[ItemCategory] (
    [timestamp]               VARBINARY (8)      NOT NULL,
    [Code]                    NVARCHAR (20)      NOT NULL,
    [Parent Category]         NVARCHAR (20)      NOT NULL,
    [Description]             NVARCHAR (100)     NOT NULL,
    [Indentation]             INT                NOT NULL,
    [Presentation Order]      INT                NOT NULL,
    [Has Children]            TINYINT            NOT NULL,
    [Last Modified Date Time] DATETIME           NOT NULL,
    [Id]                      NVARCHAR (36)      NOT NULL,
    [$systemId]               NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]        DATETIME           NOT NULL,
    [$systemCreatedBy]        NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]       DATETIME           NOT NULL,
    [$systemModifiedBy]       NVARCHAR (36)      NOT NULL,
    [PipelineName]            NVARCHAR (200)     CONSTRAINT [DF_ItemCategory_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]           NVARCHAR (36)      CONSTRAINT [DF_ItemCategory_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (0) CONSTRAINT [DF_ItemCategory_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]               INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_ItemCategory] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

