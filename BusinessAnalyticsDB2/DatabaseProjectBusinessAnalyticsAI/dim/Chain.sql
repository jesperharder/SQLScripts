CREATE TABLE [dim].[Chain] (
    [ChainKey]           INT            NOT NULL,
    [CompanyID]          INT            NOT NULL,
    [ChainGroupCode]     NVARCHAR (20)  NOT NULL,
    [ChainGroupName]     NVARCHAR (100) NULL,
    [ChainGroupCodeName] NVARCHAR (125) NULL,
    [ChainCode]          NVARCHAR (20)  NOT NULL,
    [ChainName]          NVARCHAR (100) NULL,
    [ChainCodeName]      NVARCHAR (125) NULL,
    [ChainHashKey]       NVARCHAR (200) NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Chain_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Chain_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Chain] PRIMARY KEY CLUSTERED ([ChainKey] ASC),
    CONSTRAINT [UQ_dim_Chain] UNIQUE NONCLUSTERED ([CompanyID] ASC, [ChainCode] ASC, [ChainGroupCode] ASC)
);


GO

