CREATE TABLE [stg_bc].[GL-ItemLedgerRelation] (
    [timestamp]           VARBINARY (8)      NOT NULL,
    [G_L Entry No_]       INT                NOT NULL,
    [Value Entry No_]     INT                NOT NULL,
    [G_L Register No_]    INT                NOT NULL,
    [$systemId]           NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]    DATETIME           NOT NULL,
    [$systemCreatedBy]    NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]   DATETIME           NOT NULL,
    [$systemModifiedBy]   NVARCHAR (36)      NOT NULL,
    [PipelineName]        NVARCHAR (200)     CONSTRAINT [DF_GL-ItemLedgerRelation_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]       NVARCHAR (36)      CONSTRAINT [DF_GL-ItemLedgerRelation_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (0) CONSTRAINT [DF_GL-ItemLedgerRelation_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]           INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_GL-ItemLedgerRelation] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [G_L Entry No_] ASC, [Value Entry No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

