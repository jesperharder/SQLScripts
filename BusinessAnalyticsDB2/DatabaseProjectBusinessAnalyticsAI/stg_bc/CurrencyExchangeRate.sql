CREATE TABLE [stg_bc].[CurrencyExchangeRate] (
    [timestamp]                      VARBINARY (8)    NOT NULL,
    [Currency Code]                  NVARCHAR (20)    NOT NULL,
    [Starting Date]                  DATETIME         NOT NULL,
    [Exchange Rate Amount]           DECIMAL (38, 20) NULL,
    [Adjustment Exch_ Rate Amount]   DECIMAL (38, 20) NULL,
    [Relational Currency Code]       NVARCHAR (10)    NULL,
    [Relational Exch_ Rate Amount]   DECIMAL (38, 20) NULL,
    [Fix Exchange Rate Amount]       INT              NULL,
    [Relational Adjmt Exch Rate Amt] DECIMAL (38, 20) NULL,
    [$systemId]                      UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]               DATETIME         NULL,
    [$systemCreatedBy]               UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]              DATETIME         NULL,
    [$systemModifiedBy]              UNIQUEIDENTIFIER NULL,
    [PipelineName]                   NVARCHAR (MAX)   NULL,
    [PipelineRunId]                  NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]            NVARCHAR (MAX)   NULL,
    [CompanyID]                      INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_CurrencyExchangeRate] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Currency Code] ASC, [Starting Date] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_CurrencyExchangeRate_timestamp]
    ON [stg_bc].[CurrencyExchangeRate]([CompanyID] ASC, [timestamp] ASC);


GO

