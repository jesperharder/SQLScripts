CREATE TABLE [meta].[ISO-3166-Countries-with-Regional-Codes] (
    [name]                     NVARCHAR (100) NOT NULL,
    [alpha_2]                  NVARCHAR (50)  NOT NULL,
    [alpha_3]                  NVARCHAR (50)  NOT NULL,
    [country_code]             SMALLINT       NOT NULL,
    [iso_3166_2]               NVARCHAR (50)  NOT NULL,
    [region]                   NVARCHAR (50)  NULL,
    [sub_region]               NVARCHAR (50)  NULL,
    [intermediate_region]      NVARCHAR (50)  NULL,
    [region_code]              TINYINT        NULL,
    [sub_region_code]          SMALLINT       NULL,
    [intermediate_region_code] SMALLINT       NULL,
    CONSTRAINT [PK_ISO-3166-Countries-with-Regional-Codes] PRIMARY KEY CLUSTERED ([country_code] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

