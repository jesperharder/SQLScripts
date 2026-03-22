CREATE TABLE [dim].[GLAccount] (
    [GLAccountKey]           INT            NOT NULL,
    [CompanyID]              INT            NOT NULL,
    [AccountNo]              NVARCHAR (20)  NOT NULL,
    [AccountName]            NVARCHAR (100) NULL,
    [AccountNoDescription]   NVARCHAR (123) NULL,
    [Account_Income_Balance] NVARCHAR (10)  NULL,
    [Account_Main]           NVARCHAR (10)  NULL,
    [GLAccountHashKey]       NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]     BIGINT         CONSTRAINT [DF_dim_GLAccount_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]     BIGINT         CONSTRAINT [DF_dim_GLAccount_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_GLAccount] PRIMARY KEY CLUSTERED ([GLAccountKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_GLAccount] UNIQUE NONCLUSTERED ([CompanyID] ASC, [AccountNo] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

