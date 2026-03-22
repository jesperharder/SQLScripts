CREATE TABLE [meta].[TableColumns] (
    [TABLE_CATALOG]            NVARCHAR (128)     NOT NULL,
    [TABLE_SCHEMA]             NVARCHAR (128)     NOT NULL,
    [TABLE_NAME]               NVARCHAR (128)     NOT NULL,
    [COLUMN_NAME]              NVARCHAR (128)     NOT NULL,
    [ORDINAL_POSITION]         INT                NULL,
    [COLUMN_DEFAULT]           NVARCHAR (4000)    NULL,
    [IS_NULLABLE]              VARCHAR (3)        NULL,
    [DATA_TYPE]                NVARCHAR (128)     NULL,
    [CHARACTER_MAXIMUM_LENGTH] INT                NULL,
    [CHARACTER_OCTET_LENGTH]   INT                NULL,
    [NUMERIC_PRECISION]        TINYINT            NULL,
    [NUMERIC_PRECISION_RADIX]  SMALLINT           NULL,
    [NUMERIC_SCALE]            INT                NULL,
    [DATETIME_PRECISION]       SMALLINT           NULL,
    [CHARACTER_SET_CATALOG]    NVARCHAR (128)     NULL,
    [CHARACTER_SET_SCHEMA]     NVARCHAR (128)     NULL,
    [CHARACTER_SET_NAME]       NVARCHAR (128)     NULL,
    [COLLATION_CATALOG]        NVARCHAR (128)     NULL,
    [COLLATION_SCHEMA]         NVARCHAR (128)     NULL,
    [COLLATION_NAME]           NVARCHAR (128)     NULL,
    [DOMAIN_CATALOG]           NVARCHAR (128)     NULL,
    [DOMAIN_SCHEMA]            NVARCHAR (128)     NULL,
    [DOMAIN_NAME]              NVARCHAR (128)     NULL,
    [PipelineName]             NVARCHAR (200)     NULL,
    [PipelineRunId]            NVARCHAR (36)      NULL,
    [PipelineTriggerTime]      DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_meta_TableColumns] PRIMARY KEY CLUSTERED ([TABLE_CATALOG] ASC, [TABLE_SCHEMA] ASC, [TABLE_NAME] ASC, [COLUMN_NAME] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

CREATE NONCLUSTERED INDEX [NIX_meta_TableColumns_TableCatalog_TableName_WithIncluded]
    ON [meta].[TableColumns]([TABLE_CATALOG] ASC, [TABLE_NAME] ASC)
    INCLUDE([ORDINAL_POSITION], [DATA_TYPE]) WITH (DATA_COMPRESSION = ROW);


GO

