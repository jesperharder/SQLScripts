CREATE TABLE [dim].[Scrap] (
    [ScrapKey]           INT            NOT NULL,
    [ScrapCompanyID]     INT            NOT NULL,
    [ScrapCode]          NVARCHAR (20)  NOT NULL,
    [ScrapName]          NVARCHAR (50)  NOT NULL,
    [ScrapCodeName]      NVARCHAR (73)  NOT NULL,
    [ScrapHashKey]       NVARCHAR (200) NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Scrap_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Scrap_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Scrap] PRIMARY KEY CLUSTERED ([ScrapKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Scrap] UNIQUE NONCLUSTERED ([ScrapCompanyID] ASC, [ScrapCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

