CREATE TABLE [dim_v1].[ProductionOrder] (
    [ProductionOrderKey]        INT            NOT NULL,
    [CompanyID]                 INT            NOT NULL,
    [ProductionOrderNumber]     NVARCHAR (20)  NOT NULL,
    [ProductionOrderLineNumber] INT            NOT NULL,
    [ProductionOrderStatus]     NVARCHAR (20)  NOT NULL,
    [StartingDate]              DATE           NOT NULL,
    [DueDate]                   DATE           NOT NULL,
    [EndingDate]                DATE           NOT NULL,
    [ProductionOrderHashKey]    NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]        BIGINT         CONSTRAINT [DF_dim_ProductionOrder_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]        BIGINT         CONSTRAINT [DF_dim_ProductionOrder_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_LastTimestamp]         VARBINARY (8)  CONSTRAINT [DF_ProductionOrder_LastTimestamp] DEFAULT (0x) NOT NULL,
    [ADF_DimensionSource]       NVARCHAR (128) CONSTRAINT [DF_ProductionOrder_DimensionSource] DEFAULT ('Default') NOT NULL,
    [ProductionOrderStatusID]   INT            NOT NULL,
    CONSTRAINT [PK_ProductionOrder] PRIMARY KEY CLUSTERED ([ProductionOrderKey] ASC),
    CONSTRAINT [UQ_ProductionOrder] UNIQUE NONCLUSTERED ([CompanyID] ASC, [ProductionOrderNumber] ASC, [ProductionOrderLineNumber] ASC)
);


GO

