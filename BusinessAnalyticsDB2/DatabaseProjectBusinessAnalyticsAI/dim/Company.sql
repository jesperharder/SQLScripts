CREATE TABLE [dim].[Company] (
    [CompanyKey]          INT            NOT NULL,
    [CompanyID]           INT            NOT NULL,
    [CompanyNameShort]    NVARCHAR (15)  NULL,
    [CompanyNameLong]     NVARCHAR (30)  NULL,
    [CompanyCountryCode]  NVARCHAR (7)   NULL,
    [CompanyHashKey]      NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]  BIGINT         CONSTRAINT [DF_dim_Company_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]  BIGINT         CONSTRAINT [DF_dim_Company_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    [CompanyCurrencyCode] NCHAR (3)      NULL,
    CONSTRAINT [PK_dim_Company] PRIMARY KEY CLUSTERED ([CompanyKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Company] UNIQUE NONCLUSTERED ([CompanyID] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

