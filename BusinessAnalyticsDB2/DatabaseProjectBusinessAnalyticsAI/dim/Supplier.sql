CREATE TABLE [dim].[Supplier] (
    [SupplierKey]        INT            NOT NULL,
    [SupplierCode]       NVARCHAR (20)  NOT NULL,
    [SupplierName]       NVARCHAR (100) NULL,
    [SupplierCodeName]   NVARCHAR (125) NULL,
    [SupplierHashKey]    NVARCHAR (200) NULL,
    [Dimension Code]     NVARCHAR (20)  NOT NULL,
    [CompanyID]          INT            NOT NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Supplier_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Supplier_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Supplier] PRIMARY KEY CLUSTERED ([SupplierKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Supplier] UNIQUE NONCLUSTERED ([CompanyID] ASC, [Dimension Code] ASC, [SupplierCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

