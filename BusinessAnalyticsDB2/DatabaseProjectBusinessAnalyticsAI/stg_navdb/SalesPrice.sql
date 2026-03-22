CREATE TABLE [stg_navdb].[SalesPrice] (
    [CompanyID]                    TINYINT            NOT NULL,
    [timestamp]                    VARBINARY (8)      NOT NULL,
    [Item No_]                     VARCHAR (20)       NOT NULL,
    [Sales Type]                   INT                NOT NULL,
    [Sales Code]                   VARCHAR (20)       NOT NULL,
    [Starting Date]                DATETIME           NOT NULL,
    [Currency Code]                VARCHAR (10)       NOT NULL,
    [Variant Code]                 VARCHAR (10)       NOT NULL,
    [Unit of Measure Code]         VARCHAR (10)       NOT NULL,
    [Minimum Quantity]             DECIMAL (38, 20)   NOT NULL,
    [Unit Price]                   DECIMAL (38, 20)   NOT NULL,
    [Price Includes VAT]           TINYINT            NOT NULL,
    [Allow Invoice Disc_]          TINYINT            NOT NULL,
    [VAT Bus_ Posting Gr_ (Price)] VARCHAR (10)       NOT NULL,
    [Ending Date]                  DATETIME           NOT NULL,
    [Allow Line Disc_]             TINYINT            NOT NULL,
    [Unit Price (Currency)]        DECIMAL (38, 20)   NOT NULL,
    [Discount %]                   DECIMAL (38, 20)   NOT NULL,
    [Unit List Price (Currency)]   DECIMAL (38, 20)   NOT NULL,
    [Unit List Price]              DECIMAL (38, 20)   NOT NULL,
    [Forecast quantity]            DECIMAL (38, 20)   NOT NULL,
    [Forecast %]                   DECIMAL (38, 20)   NOT NULL,
    [Item in sortiment]            TINYINT            NOT NULL,
    [PipelineName]                 NVARCHAR (128)     NULL,
    [PipelineRunId]                NVARCHAR (36)      NULL,
    [PipelineTriggerTime]          DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_SalesPrice] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Item No_] ASC, [Sales Type] ASC, [Sales Code] ASC, [Starting Date] ASC, [Currency Code] ASC, [Variant Code] ASC, [Unit of Measure Code] ASC, [Minimum Quantity] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_SalesPrice_timestamp]
    ON [stg_navdb].[SalesPrice]([CompanyID] ASC, [timestamp] ASC);


GO

