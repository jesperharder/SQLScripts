CREATE TABLE [stg_navdb].[CountryRegion] (
    [CompanyID]                  TINYINT            NOT NULL,
    [timestamp]                  VARBINARY (8)      NOT NULL,
    [Code]                       VARCHAR (10)       NOT NULL,
    [Name]                       VARCHAR (50)       NOT NULL,
    [EU Country_Region Code]     VARCHAR (10)       NOT NULL,
    [Intrastat Code]             VARCHAR (10)       NOT NULL,
    [Address Format]             INT                NOT NULL,
    [Contact Address Format]     INT                NOT NULL,
    [OIOXML Country_Region Code] VARCHAR (10)       NOT NULL,
    [Freight Amount]             DECIMAL (38, 20)   NOT NULL,
    [Order Min_ Amount]          DECIMAL (38, 20)   NOT NULL,
    [G_L Account No_]            VARCHAR (20)       NOT NULL,
    [Geografic Region]           VARCHAR (10)       NOT NULL,
    [Geografic Sub Region]       VARCHAR (10)       NOT NULL,
    [ISO A2]                     VARCHAR (10)       NOT NULL,
    [ISO A3]                     VARCHAR (10)       NOT NULL,
    [Currency Code (Freight)]    VARCHAR (10)       NOT NULL,
    [Freight %]                  DECIMAL (38, 20)   NOT NULL,
    [VAT Pct]                    DECIMAL (38, 20)   NOT NULL,
    [Market Type]                VARCHAR (30)       NOT NULL,
    [Channel Type]               VARCHAR (30)       NOT NULL,
    [PipelineName]               NVARCHAR (128)     NULL,
    [PipelineRunId]              NVARCHAR (36)      NULL,
    [PipelineTriggerTime]        DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_CountryRegion] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_CountryRegion_timestamp]
    ON [stg_navdb].[CountryRegion]([CompanyID] ASC, [timestamp] ASC);


GO

