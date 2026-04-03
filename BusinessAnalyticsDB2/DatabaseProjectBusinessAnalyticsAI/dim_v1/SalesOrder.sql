CREATE TABLE [dim_v1].[SalesOrder] (
    [SalesOrderKey] INT NOT NULL,
    [SalesOrderNumber] NVARCHAR (20) NOT NULL,
    [SalesOrderStatus] NVARCHAR (20) NULL,
    [SalesPersonCode] NVARCHAR (20) NULL,
    [RequestedDeliveryDateOrderHeader] DATE NOT NULL,
    [CompanyID] INT NOT NULL,
    [SalesOrderHashKey] NVARCHAR (200) NULL,
    [AFD_DimensionSource] NVARCHAR (128) CONSTRAINT [DF_dim_SalesOrder_DimensionSource] DEFAULT (N'Default') NOT NULL,
    [ADF_BatchId_Insert] BIGINT CONSTRAINT [DF_dim_SalesOrder_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT CONSTRAINT [DF_dim_SalesOrder_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_SalesOrder] PRIMARY KEY CLUSTERED ([SalesOrderKey] ASC)
);
