CREATE TABLE [dim].[Marketing] (
    [MarketingKey]       INT            NOT NULL,
    [MarketingCode]      NVARCHAR (20)  NOT NULL,
    [MarketingName]      NVARCHAR (100) NULL,
    [MarketingCodeName]  NVARCHAR (125) NULL,
    [MarketingHashKey]   NVARCHAR (200) NULL,
    [Dimension Code]     NVARCHAR (20)  NOT NULL,
    [CompanyID]          INT            NOT NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Marketing_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Marketing_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Marketing] PRIMARY KEY CLUSTERED ([MarketingKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Marketing] UNIQUE NONCLUSTERED ([CompanyID] ASC, [Dimension Code] ASC, [MarketingCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

