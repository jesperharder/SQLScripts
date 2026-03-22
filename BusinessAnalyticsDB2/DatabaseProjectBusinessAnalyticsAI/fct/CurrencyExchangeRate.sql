CREATE TABLE [fct].[CurrencyExchangeRate] (
    [CompanyID]        INT             NOT NULL,
    [DateKey]          INT             CONSTRAINT [DF_CurrencyExchangeRate_Date] DEFAULT ((-1)) NOT NULL,
    [CurrencyFromKey]  INT             CONSTRAINT [DF_CurrencyExchangeRate_CurrencyFrom] DEFAULT ((-1)) NOT NULL,
    [CurrencyToKey]    INT             CONSTRAINT [DF_CurrencyExchangeRate_CurrencyTo] DEFAULT ((-1)) NOT NULL,
    [ExchangeRate]     DECIMAL (18, 6) NULL,
    [ExchangeRateTo]   DECIMAL (18, 6) NULL,
    [ExchangeRateFrom] DECIMAL (18, 6) NULL,
    [FromCurrency]     NVARCHAR (20)   NOT NULL,
    [ToCurrency]       NVARCHAR (20)   NOT NULL,
    CONSTRAINT [PK_CurrencyExchangeRate] PRIMARY KEY NONCLUSTERED ([CompanyID] ASC, [DateKey] ASC, [FromCurrency] ASC, [ToCurrency] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NIX_fct_CurrencyExchangeRate_CurrencyToKey_WithIncluded]
    ON [fct].[CurrencyExchangeRate]([CompanyID] ASC, [CurrencyToKey] ASC)
    INCLUDE([DateKey], [CurrencyFromKey], [ExchangeRate]);


GO

