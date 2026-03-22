CREATE TABLE [dim_v1].[BudgetVersion] (
    [BudgetVersionKey]     INT            NOT NULL,
    [BudgetVersion]        NVARCHAR (20)  NOT NULL,
    [BudgetVersionHashKey] NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]   BIGINT         CONSTRAINT [DF_dim_BudgetVersion_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]   BIGINT         CONSTRAINT [DF_dim_BudgetVersion_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_BudgetVersion] PRIMARY KEY CLUSTERED ([BudgetVersionKey] ASC),
    CONSTRAINT [UQ_dim_BudgetVersion] UNIQUE NONCLUSTERED ([BudgetVersion] ASC)
);


GO

