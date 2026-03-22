CREATE TABLE [stg_bc].[TariffNumber] (
    [timestamp]           VARBINARY (8)      NOT NULL,
    [No_]                 NVARCHAR (20)      NOT NULL,
    [Description]         NVARCHAR (100)     NOT NULL,
    [Supplementary Units] TINYINT            NOT NULL,
    [$systemId]           NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]    DATETIME           NOT NULL,
    [$systemCreatedBy]    NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]   DATETIME           NOT NULL,
    [$systemModifiedBy]   NVARCHAR (36)      NOT NULL,
    [PipelineName]        NVARCHAR (200)     CONSTRAINT [DF_TariffNumber_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]       NVARCHAR (36)      CONSTRAINT [DF_TariffNumber_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (0) CONSTRAINT [DF_TariffNumber_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]           INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_TariffNumber] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

