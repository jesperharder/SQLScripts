CREATE TABLE [stg_bc].[Stop] (
    [timestamp]           VARBINARY (8)      NOT NULL,
    [Code]                NVARCHAR (10)      NOT NULL,
    [Description]         NVARCHAR (100)     NOT NULL,
    [$systemId]           NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]    DATETIME           NOT NULL,
    [$systemCreatedBy]    NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]   DATETIME           NOT NULL,
    [$systemModifiedBy]   NVARCHAR (36)      NOT NULL,
    [PipelineName]        NVARCHAR (200)     CONSTRAINT [DF_Stop_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]       NVARCHAR (36)      CONSTRAINT [DF_Stop_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (0) CONSTRAINT [DF_Stop_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]           INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_Stop] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

