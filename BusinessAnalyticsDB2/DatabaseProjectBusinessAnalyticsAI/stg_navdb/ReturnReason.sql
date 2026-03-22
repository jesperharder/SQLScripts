CREATE TABLE [stg_navdb].[ReturnReason] (
    [CompanyID]             TINYINT            NOT NULL,
    [timestamp]             VARBINARY (8)      NOT NULL,
    [Code]                  VARCHAR (10)       NOT NULL,
    [Description]           VARCHAR (50)       NOT NULL,
    [Default Location Code] VARCHAR (10)       NOT NULL,
    [Inventory Value Zero]  TINYINT            NOT NULL,
    [PipelineName]          NVARCHAR (128)     NULL,
    [PipelineRunId]         NVARCHAR (36)      NULL,
    [PipelineTriggerTime]   DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_ReturnReason] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_ReturnReason_timestamp]
    ON [stg_navdb].[ReturnReason]([CompanyID] ASC, [timestamp] ASC);


GO

