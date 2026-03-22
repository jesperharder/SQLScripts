CREATE TABLE [stg_bc].[ItemScanpan] (
    [timestamp]              VARBINARY (8)      NOT NULL,
    [No_]                    NVARCHAR (20)      NOT NULL,
    [MarkupPurchaseprice]    DECIMAL (38, 20)   NOT NULL,
    [Purch_price pri_vendor] DECIMAL (38, 20)   NOT NULL,
    [ItemBodyType]           INT                NOT NULL,
    [PipelineName]           NVARCHAR (200)     CONSTRAINT [DF_ItemScanpan_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]          NVARCHAR (36)      CONSTRAINT [DF_ItemScanpan_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]    DATETIMEOFFSET (0) CONSTRAINT [DF_ItemScanpan_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]              INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_ItemScanpan] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC)
);


GO

