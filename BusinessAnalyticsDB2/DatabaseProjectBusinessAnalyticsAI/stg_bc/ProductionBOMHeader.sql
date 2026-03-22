CREATE TABLE [stg_bc].[ProductionBOMHeader] (
    [timestamp]            VARBINARY (8)      NOT NULL,
    [No_]                  NVARCHAR (20)      NOT NULL,
    [Description]          NVARCHAR (100)     NOT NULL,
    [Description 2]        NVARCHAR (50)      NOT NULL,
    [Search Name]          NVARCHAR (100)     NOT NULL,
    [Unit of Measure Code] NVARCHAR (10)      NOT NULL,
    [Low-Level Code]       INT                NOT NULL,
    [Creation Date]        DATETIME           NOT NULL,
    [Last Date Modified]   DATETIME           NOT NULL,
    [Status]               INT                NOT NULL,
    [Version Nos_]         NVARCHAR (20)      NOT NULL,
    [No_ Series]           NVARCHAR (20)      NOT NULL,
    [$systemId]            NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]     DATETIME           NOT NULL,
    [$systemCreatedBy]     NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]    DATETIME           NOT NULL,
    [$systemModifiedBy]    NVARCHAR (36)      NOT NULL,
    [PipelineName]         NVARCHAR (200)     CONSTRAINT [DF_ProductionBOMHeader_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]        NVARCHAR (36)      CONSTRAINT [DF_ProductionBOMHeader_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (0) CONSTRAINT [DF_ProductionBOMHeader_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]            INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_ProductionBOMHeader] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

