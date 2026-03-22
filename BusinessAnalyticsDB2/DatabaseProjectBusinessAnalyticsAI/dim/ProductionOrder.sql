CREATE TABLE [dim].[ProductionOrder] (
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
    CONSTRAINT [PK_ProductionOrder] PRIMARY KEY CLUSTERED ([ProductionOrderKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_ProductionOrder] UNIQUE NONCLUSTERED ([CompanyID] ASC, [ProductionOrderNumber] ASC, [ProductionOrderLineNumber] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

EXECUTE sp_addextendedproperty @name = N'UnknownEntityName', @value = N'ProductionOrder', @level0type = N'SCHEMA', @level0name = N'dim', @level1type = N'TABLE', @level1name = N'ProductionOrder';


GO

