CREATE TABLE [dim].[Currency] (
    [CurrencyKey]        INT            NOT NULL,
    [CurrencyCompanyID]  INT            NOT NULL,
    [CurrencyCode]       NVARCHAR (20)  NOT NULL,
    [CurrencyName]       NVARCHAR (100) NULL,
    [CurrencyCodeName]   NVARCHAR (125) NULL,
    [CurrencyHashKey]    NVARCHAR (200) NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Currency_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Currency_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Currency] PRIMARY KEY CLUSTERED ([CurrencyKey] ASC),
    CONSTRAINT [UQ_dim_Currency] UNIQUE NONCLUSTERED ([CurrencyCompanyID] ASC, [CurrencyCode] ASC)
);


GO

