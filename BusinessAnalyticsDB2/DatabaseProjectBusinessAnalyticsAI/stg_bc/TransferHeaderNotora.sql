CREATE TABLE [stg_bc].[TransferHeaderNotora] (
    [timestamp]               VARBINARY (8)      NOT NULL,
    [No_]                     NVARCHAR (20)      NOT NULL,
    [Container ID NOTO]       NVARCHAR (20)      NOT NULL,
    [Bill of Lading No_ NOTO] NVARCHAR (20)      NOT NULL,
    [PipelineName]            NVARCHAR (200)     CONSTRAINT [DF_TransferHeaderNotora_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]           NVARCHAR (36)      CONSTRAINT [DF_TransferHeaderNotora_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (0) CONSTRAINT [DF_TransferHeaderNotora_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]               INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_TransferHeaderNotora] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

