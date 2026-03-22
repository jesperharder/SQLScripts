CREATE TABLE [stg_navdb].[CurrencyExchangeRate] (
    [CompanyID]                      TINYINT            NOT NULL,
    [timestamp]                      VARBINARY (8)      NOT NULL,
    [Currency Code]                  VARCHAR (10)       NOT NULL,
    [Starting Date]                  DATETIME           NOT NULL,
    [Exchange Rate Amount]           DECIMAL (38, 20)   NOT NULL,
    [Adjustment Exch_ Rate Amount]   DECIMAL (38, 20)   NOT NULL,
    [Relational Currency Code]       VARCHAR (10)       NOT NULL,
    [Relational Exch_ Rate Amount]   DECIMAL (38, 20)   NOT NULL,
    [Fix Exchange Rate Amount]       INT                NOT NULL,
    [Relational Adjmt Exch Rate Amt] DECIMAL (38, 20)   NOT NULL,
    [PipelineName]                   NVARCHAR (128)     NULL,
    [PipelineRunId]                  NVARCHAR (36)      NULL,
    [PipelineTriggerTime]            DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_CurrencyExchangeRate] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Currency Code] ASC, [Starting Date] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_CurrencyExchangeRate_timestamp]
    ON [stg_navdb].[CurrencyExchangeRate]([CompanyID] ASC, [timestamp] ASC);


GO

CREATE NONCLUSTERED INDEX [NIX_stg_navdb_CurrencyExchangeRate_CompanyID_StartingDate_WithIncluded]
    ON [stg_navdb].[CurrencyExchangeRate]([CompanyID] ASC, [Starting Date] ASC)
    INCLUDE([Exchange Rate Amount], [Relational Exch_ Rate Amount]) WITH (DATA_COMPRESSION = ROW);


GO

