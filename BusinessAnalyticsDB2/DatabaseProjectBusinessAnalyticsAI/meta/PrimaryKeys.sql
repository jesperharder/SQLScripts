CREATE TABLE [meta].[PrimaryKeys] (
    [TableCatalog]        NVARCHAR (128)     NOT NULL,
    [SchemaName]          NVARCHAR (128)     NOT NULL,
    [TableName]           NVARCHAR (128)     NOT NULL,
    [ColumnName]          NVARCHAR (128)     NOT NULL,
    [KeyOrderNr]          TINYINT            NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       NVARCHAR (36)      NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_meta_PrimaryKeys] PRIMARY KEY CLUSTERED ([TableCatalog] ASC, [SchemaName] ASC, [TableName] ASC, [ColumnName] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

