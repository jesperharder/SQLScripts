CREATE TABLE [stg_bc].[ItemCrossReference] (
    [timestamp]                VARBINARY (8)      NOT NULL,
    [Item No_]                 NVARCHAR (20)      NOT NULL,
    [Variant Code]             NVARCHAR (10)      NOT NULL,
    [Unit of Measure]          NVARCHAR (10)      NOT NULL,
    [Cross-Reference Type]     INT                NOT NULL,
    [Cross-Reference Type No_] NVARCHAR (30)      NOT NULL,
    [Cross-Reference No_]      NVARCHAR (20)      NOT NULL,
    [Description]              NVARCHAR (100)     NOT NULL,
    [Discontinue Bar Code]     TINYINT            NOT NULL,
    [Description 2]            NVARCHAR (50)      NOT NULL,
    [$systemId]                NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]         DATETIME           NOT NULL,
    [$systemCreatedBy]         NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]        DATETIME           NOT NULL,
    [$systemModifiedBy]        NVARCHAR (36)      NOT NULL,
    [PipelineName]             NVARCHAR (200)     CONSTRAINT [DF_ItemCrossReference_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]            NVARCHAR (36)      CONSTRAINT [DF_ItemCrossReference_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]      DATETIMEOFFSET (0) CONSTRAINT [DF_ItemCrossReference_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]                INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_ItemCrossReference] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Item No_] ASC, [Variant Code] ASC, [Unit of Measure] ASC, [Cross-Reference Type] ASC, [Cross-Reference Type No_] ASC, [Cross-Reference No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

