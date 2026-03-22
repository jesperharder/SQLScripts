CREATE TABLE [stg_bc_api].[CurrencyExchangeRate] (
    [CompanyId]                  INT                NOT NULL,
    [currencyCode]               NVARCHAR (10)      NOT NULL,
    [startingDate]               DATE               NOT NULL,
    [exchangeRateAmount]         DECIMAL (38, 20)   NULL,
    [adjustmentExchRateAmount]   DECIMAL (38, 20)   NULL,
    [relationalCurrencyCode]     NVARCHAR (10)      NULL,
    [relationalExchRateAmount]   DECIMAL (38, 20)   NULL,
    [relationalAdjmtExchRateAmt] DECIMAL (38, 20)   NULL,
    [fixExchangeRateAmount]      NVARCHAR (50)      NULL,
    [fixExchangeRateAmountInt]   INT                NULL,
    [systemId]                   UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]            DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]            UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]           DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]           UNIQUEIDENTIFIER   NULL,
    [PipelineName]               NVARCHAR (200)     NULL,
    [PipelineRunId]              NVARCHAR (100)     NULL,
    [PipelineTriggerTime]        DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_CurrencyExchangeRate] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [currencyCode] ASC, [startingDate] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_CurrencyExchangeRate_Company_StartingDate]
    ON [stg_bc_api].[CurrencyExchangeRate]([CompanyId] ASC, [startingDate] ASC);


GO

