CREATE TABLE [etl].[Configuration] (
    [Configuration]      NVARCHAR (128) NOT NULL,
    [ConfigurationValue] NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_etl_Configuration] PRIMARY KEY CLUSTERED ([Configuration] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

