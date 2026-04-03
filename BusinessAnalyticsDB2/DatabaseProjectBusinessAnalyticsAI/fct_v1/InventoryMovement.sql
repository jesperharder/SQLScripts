CREATE TABLE [fct_v1].[InventoryMovement] (
    [DatePostingKey] INT CONSTRAINT [DF_InventoryMovement_Posting] DEFAULT ((-1)) NOT NULL,
    [ItemKey] INT CONSTRAINT [DF_InventoryMovement_Item] DEFAULT ((-1)) NOT NULL,
    [InventoryMovementKey] INT CONSTRAINT [DF_InventoryMovement_InventoryMovement] DEFAULT ((-1)) NOT NULL,
    [ItemPurchaseDocumentKey] INT CONSTRAINT [DF_InventoryMovement_PurchaseDocument] DEFAULT ((-1)) NOT NULL,
    [ItemSaleDocumentKey] INT CONSTRAINT [DF_InventoryMovement_SalesDocument] DEFAULT ((-1)) NOT NULL,
    [LocationKey] INT CONSTRAINT [DF_InventoryMovement_Location] DEFAULT ((-1)) NOT NULL,
    [FinanceVoucherKey] INT CONSTRAINT [DF_InventoryMovement_FinanceVoucher] DEFAULT ((-1)) NOT NULL,
    [FinanceAccountKey] INT CONSTRAINT [DF_InventoryMovement_FinanceAccount] DEFAULT ((-1)) NOT NULL,
    [DepartmentKey] INT CONSTRAINT [DF_InventoryMovement_Department] DEFAULT ((-1)) NOT NULL,
    [CompanyKey] INT CONSTRAINT [DF_InventoryMovement_Company] DEFAULT ((-1)) NOT NULL,
    [CustomerKey] INT CONSTRAINT [DF_InventoryMovement_Customer] DEFAULT ((-1)) NOT NULL,
    [VendorKey] INT CONSTRAINT [DF_InventoryMovement_Vendor] DEFAULT ((-1)) NOT NULL,
    [GeneralBusinessPostingGroupKey] INT CONSTRAINT [DF_InventoryMovement_GeneralBusinessPostingGroup] DEFAULT ((-1)) NOT NULL,
    [GeneralProductPostingGroupKey] INT CONSTRAINT [DF_InventoryMovement_GeneralProductPostingGroup] DEFAULT ((-1)) NOT NULL,
    [M_StockQuantity] DECIMAL (38, 18) NULL,
    [M_AdjustmentInQuantity] DECIMAL (38, 18) NULL,
    [M_StockWithdrawal] DECIMAL (38, 18) NULL,
    [M_StockEntry] DECIMAL (38, 18) NULL,
    [M_PhysicalWeight] DECIMAL (38, 18) NULL,
    [M_PhysicalM3] DECIMAL (38, 18) NULL,
    [CompanyID] INT NOT NULL,
    [ADF_FactSource] VARCHAR (50) NOT NULL,
    [NK_EntryNo] INT NOT NULL,
    [timestamp] VARBINARY (8) CONSTRAINT [DF_InventoryMovement_LastTimestamp] DEFAULT (0x) NOT NULL,
    [ADF_PipelineTriggerTime] DATETIME CONSTRAINT [DF_fct_v1_InventoryMovement_PipelineTriggerTime] DEFAULT (getdate()) NOT NULL
);

GO

CREATE NONCLUSTERED INDEX [IX_fct_v1_InventoryMovement_DatePostingKey_INCLUDE]
    ON [fct_v1].[InventoryMovement]([DatePostingKey] ASC)
    INCLUDE ([ItemKey], [LocationKey], [M_StockQuantity])

GO

CREATE NONCLUSTERED INDEX [IX_fct_v1_InventoryMovement_FinanceVoucherKey]
    ON [fct_v1].[InventoryMovement]([DatePostingKey] ASC, [FinanceVoucherKey] ASC)

GO

CREATE NONCLUSTERED INDEX [IX_fct_v1_InventoryMovement_ItemKey_INCLUDE]
    ON [fct_v1].[InventoryMovement]([ItemKey] ASC)
    INCLUDE ([DatePostingKey], [LocationKey], [M_StockQuantity])

GO

CREATE NONCLUSTERED INDEX [NIX_fct_v1_InventoryMovement_DatePostingKey_ItemKey_LocationKey_WithIncluded]
    ON [fct_v1].[InventoryMovement]([DatePostingKey] ASC, [ItemKey] ASC, [LocationKey] ASC)
    INCLUDE ([M_StockQuantity], [CompanyID])

GO

CREATE NONCLUSTERED INDEX [NIX_fct_v1_InventoryMovement_MStockQuantity_WithIncluded]
    ON [fct_v1].[InventoryMovement]([DatePostingKey] ASC, [M_StockQuantity] ASC)
    INCLUDE ([ItemKey], [LocationKey])

GO

CREATE NONCLUSTERED INDEX [NIX_LocationKey_WithIncluded]
    ON [fct_v1].[InventoryMovement]([DatePostingKey] ASC, [LocationKey] ASC)
    INCLUDE ([ItemKey], [M_StockQuantity])

GO
