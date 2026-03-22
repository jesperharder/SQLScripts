CREATE TABLE [stg_bc].[WorkCenterGroup] (
    [timestamp]           VARBINARY (8)      NOT NULL,
    [Code]                NVARCHAR (10)      NOT NULL,
    [Name]                NVARCHAR (50)      NOT NULL,
    [$systemId]           NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]    DATETIME           NOT NULL,
    [$systemCreatedBy]    NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]   DATETIME           NOT NULL,
    [$systemModifiedBy]   NVARCHAR (36)      NOT NULL,
    [PipelineName]        NVARCHAR (200)     CONSTRAINT [DF_WorkCenterGroup_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]       NVARCHAR (36)      CONSTRAINT [DF_WorkCenterGroup_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (0) CONSTRAINT [DF_WorkCenterGroup_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]           INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_WorkCenterGroup] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

