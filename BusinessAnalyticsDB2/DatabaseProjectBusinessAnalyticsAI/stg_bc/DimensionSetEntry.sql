CREATE TABLE [stg_bc].[DimensionSetEntry] (
    [timestamp]            VARBINARY (8)      NOT NULL,
    [Dimension Set ID]     INT                NOT NULL,
    [Dimension Code]       NVARCHAR (20)      NOT NULL,
    [Dimension Value Code] NVARCHAR (20)      NOT NULL,
    [Dimension Value ID]   INT                NOT NULL,
    [Global Dimension No_] INT                NOT NULL,
    [$systemId]            NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]     DATETIME           NOT NULL,
    [$systemCreatedBy]     NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]    DATETIME           NOT NULL,
    [$systemModifiedBy]    NVARCHAR (36)      NOT NULL,
    [PipelineName]         NVARCHAR (200)     CONSTRAINT [DF_DimensionSetEntry_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]        NVARCHAR (36)      CONSTRAINT [DF_DimensionSetEntry_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (0) CONSTRAINT [DF_DimensionSetEntry_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]            INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_DimensionSetEntry] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Dimension Set ID] ASC, [Dimension Code] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

