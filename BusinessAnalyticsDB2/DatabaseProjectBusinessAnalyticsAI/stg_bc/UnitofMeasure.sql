CREATE TABLE [stg_bc].[UnitofMeasure] (
    [timestamp]                   VARBINARY (8)      NOT NULL,
    [Code]                        NVARCHAR (10)      NOT NULL,
    [Description]                 NVARCHAR (50)      NOT NULL,
    [International Standard Code] NVARCHAR (10)      NOT NULL,
    [Symbol]                      NVARCHAR (10)      NOT NULL,
    [Last Modified Date Time]     DATETIME           NOT NULL,
    [Id]                          NVARCHAR (36)      NOT NULL,
    [$systemId]                   NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]            DATETIME           NOT NULL,
    [$systemCreatedBy]            NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]           DATETIME           NOT NULL,
    [$systemModifiedBy]           NVARCHAR (36)      NOT NULL,
    [PipelineName]                NVARCHAR (200)     CONSTRAINT [DF_UnitofMeasure_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]               NVARCHAR (36)      CONSTRAINT [DF_UnitofMeasure_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]         DATETIMEOFFSET (0) CONSTRAINT [DF_UnitofMeasure_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]                   INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_UnitofMeasure] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

