CREATE TABLE [dim].[InventoryMovementDocument] (
    [InventoryMovementDocumentKey]     INT            NOT NULL,
    [CompanyID]                        INT            NOT NULL,
    [InventoryMovementDocumentNumber]  NVARCHAR (20)  NOT NULL,
    [InventoryMovementCause]           NVARCHAR (100) NULL,
    [ItemLedgerEntryType]              NVARCHAR (50)  NOT NULL,
    [InventoryPostingDate]             DATE           NOT NULL,
    [InventoryUserId]                  NVARCHAR (50)  NOT NULL,
    [InventoryNoSeries]                NVARCHAR (20)  NOT NULL,
    [InventoryMovementDocumentHashKey] NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]               BIGINT         CONSTRAINT [DF_dim_InventoryMovementDocument_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]               BIGINT         CONSTRAINT [DF_dim_InventoryMovementDocument_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_InventoryMovementDocument] PRIMARY KEY CLUSTERED ([InventoryMovementDocumentKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_InventoryMovementDocument] UNIQUE NONCLUSTERED ([CompanyID] ASC, [InventoryMovementDocumentNumber] ASC, [InventoryMovementCause] ASC, [ItemLedgerEntryType] ASC, [InventoryPostingDate] ASC, [InventoryUserId] ASC, [InventoryNoSeries] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

