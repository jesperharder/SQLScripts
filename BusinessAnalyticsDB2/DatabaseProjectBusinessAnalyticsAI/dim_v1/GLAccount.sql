CREATE TABLE [dim_v1].[GLAccount] (
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
    CONSTRAINT [PK_dim_GLAccount] PRIMARY KEY CLUSTERED ([GLAccountKey] ASC),
    CONSTRAINT [UQ_dim_GLAccount] UNIQUE NONCLUSTERED ([CompanyID] ASC, [AccountNo] ASC)
);


GO

