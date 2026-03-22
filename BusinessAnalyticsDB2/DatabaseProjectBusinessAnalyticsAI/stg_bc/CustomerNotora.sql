CREATE TABLE [stg_bc].[CustomerNotora] (
    [timestamp]                     VARBINARY (8)      NOT NULL,
    [No_]                           NVARCHAR (20)      NOT NULL,
    [Del_ SO_s With Rem_ Qty_ NOTO] TINYINT            NOT NULL,
    [Use Barcode]                   TINYINT            NOT NULL,
    [Old Customer No_]              NVARCHAR (20)      NOT NULL,
    [Calculate Freight]             TINYINT            NOT NULL,
    [ChainGroup]                    NVARCHAR (20)      NOT NULL,
    [Priority NOTO]                 INT                NOT NULL,
    [Batch Posting]                 TINYINT            NOT NULL,
    [PipelineName]                  NVARCHAR (200)     CONSTRAINT [DF_CustomerNotora_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]                 NVARCHAR (36)      CONSTRAINT [DF_CustomerNotora_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]           DATETIMEOFFSET (0) CONSTRAINT [DF_CustomerNotora_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]                     INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_CustomerNotora] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

