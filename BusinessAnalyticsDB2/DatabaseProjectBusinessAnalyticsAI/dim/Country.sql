CREATE TABLE [dim].[Country] (
    [CountryKey]         INT            NOT NULL,
    [CountryCode]        NVARCHAR (20)  NOT NULL,
    [CountryName]        NVARCHAR (100) NULL,
    [CountryCodeName]    NVARCHAR (125) NULL,
    [CountryHashKey]     NVARCHAR (200) NULL,
    [Dimension Code]     NVARCHAR (20)  NOT NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Country_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Country_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Country] PRIMARY KEY CLUSTERED ([CountryKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Country] UNIQUE NONCLUSTERED ([Dimension Code] ASC, [CountryCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

