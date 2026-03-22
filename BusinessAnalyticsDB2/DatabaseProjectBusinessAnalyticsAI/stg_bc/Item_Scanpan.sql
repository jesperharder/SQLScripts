CREATE TABLE [stg_bc].[Item_Scanpan] (
    [timestamp]              VARBINARY (8)    NULL,
    [No_]                    NVARCHAR (20)    NULL,
    [MarkupPurchaseprice]    DECIMAL (38, 20) NULL,
    [Purch_price pri_vendor] DECIMAL (38, 20) NULL,
    [ItemBodyType]           INT              NULL,
    [PipelineName]           NVARCHAR (MAX)   NULL,
    [PipelineRunId]          NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]    NVARCHAR (MAX)   NULL,
    [CompanyID]              NVARCHAR (MAX)   NULL
);


GO

