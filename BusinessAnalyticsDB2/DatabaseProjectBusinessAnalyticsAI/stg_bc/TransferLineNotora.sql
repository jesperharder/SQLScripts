CREATE TABLE [stg_bc].[TransferLineNotora] (
    [timestamp]                    VARBINARY (8)      NOT NULL,
    [Document No_]                 NVARCHAR (20)      NOT NULL,
    [Line No_]                     INT                NOT NULL,
    [Container No_]                NVARCHAR (25)      NOT NULL,
    [Purchase Order]               NVARCHAR (20)      NOT NULL,
    [Pallet Type]                  NVARCHAR (20)      NOT NULL,
    [Package Instructions]         NVARCHAR (20)      NOT NULL,
    [Purchase Order No_ NOTO]      NVARCHAR (20)      NOT NULL,
    [Purchase Order Line No_ NOTO] INT                NOT NULL,
    [Container ID NOTO]            NVARCHAR (20)      NOT NULL,
    [Bill of Lading No_ NOTO]      NVARCHAR (20)      NOT NULL,
    [PipelineName]                 NVARCHAR (200)     CONSTRAINT [DF_TransferLineNotora_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]                NVARCHAR (36)      CONSTRAINT [DF_TransferLineNotora_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]          DATETIMEOFFSET (0) CONSTRAINT [DF_TransferLineNotora_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]                    INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_TransferLineNotora] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Document No_] ASC, [Line No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

