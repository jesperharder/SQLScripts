CREATE TABLE [stg_navdb].[ItemUnitOfMeasure] (
    [CompanyID]                TINYINT            NOT NULL,
    [timestamp]                VARBINARY (8)      NOT NULL,
    [Item No_]                 VARCHAR (20)       NOT NULL,
    [Code]                     VARCHAR (10)       NOT NULL,
    [Qty_ per Unit of Measure] DECIMAL (38, 20)   NOT NULL,
    [Length]                   DECIMAL (38, 20)   NOT NULL,
    [Width]                    DECIMAL (38, 20)   NOT NULL,
    [Height]                   DECIMAL (38, 20)   NOT NULL,
    [Cubage]                   DECIMAL (38, 20)   NOT NULL,
    [Weight]                   DECIMAL (38, 20)   NOT NULL,
    [PipelineName]             NVARCHAR (128)     NULL,
    [PipelineRunId]            NVARCHAR (36)      NULL,
    [PipelineTriggerTime]      DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_ItemUnitOfMeasure] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Item No_] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_ItemUnitOfMeasure_timestamp]
    ON [stg_navdb].[ItemUnitOfMeasure]([CompanyID] ASC, [timestamp] ASC);


GO

