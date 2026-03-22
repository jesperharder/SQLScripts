CREATE TABLE [dim_v1].[FinanceVoucher] (
    [FinanceVoucherKey]           INT            NOT NULL,
    [CompanyID]                   INT            NOT NULL,
    [FinanceVoucherNumber]        NVARCHAR (50)  NOT NULL,
    [FinanceVoucherType]          NVARCHAR (50)  NOT NULL,
    [FinanceVoucherSourceCode]    NVARCHAR (50)  NOT NULL,
    [FinanceVoucherPostingDate]   DATE           NOT NULL,
    [FinanceVoucherIsClosingDate] NVARCHAR (10)  NOT NULL,
    [FinanceVoucherHashKey]       NVARCHAR (200) NULL,
    [ADF_LastTimestamp]           VARBINARY (8)  CONSTRAINT [DF_FinanceVoucher_LastTimestamp] DEFAULT (0x) NOT NULL,
    [ADF_DimensionSource]         NVARCHAR (128) CONSTRAINT [DF_FinanceVoucher_DimensionSource] DEFAULT ('Default') NOT NULL,
    [ADF_BatchId_Insert]          BIGINT         CONSTRAINT [DF_dim_FinanceVoucher_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]          BIGINT         CONSTRAINT [DF_dim_FinanceVoucher_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_FinanceVoucher] PRIMARY KEY CLUSTERED ([FinanceVoucherKey] ASC)
);


GO

