CREATE TABLE [dim].[PurchaseDocument] (
    [PurchaseDocumentKey]        INT            NOT NULL,
    [CompanyID]                  INT            NOT NULL,
    [PurchaseDocumentNumber]     NVARCHAR (20)  NOT NULL,
    [PurchaseDocumentLineNumber] INT            NOT NULL,
    [PurchaseDocumentType]       NVARCHAR (20)  NOT NULL,
    [PurchaseDocumentLineType]   NVARCHAR (20)  NOT NULL,
    [PurchaseOrderNumber]        NVARCHAR (20)  NOT NULL,
    [ResponsiblePurchaserCode]   NVARCHAR (20)  NOT NULL,
    [CurrencyCode]               NVARCHAR (7)   NOT NULL,
    [PurchaseOrderCreatedDate]   DATE           NOT NULL,
    [IsCompletelyReceived]       NVARCHAR (7)   NOT NULL,
    [IsDropShipment]             NVARCHAR (7)   NOT NULL,
    [SalesOrderNumber]           NVARCHAR (20)  NOT NULL,
    [ExpectedReceiptDate]        DATE           NOT NULL,
    [RequestedReceiptDate]       DATE           NOT NULL,
    [PromisedReceiptDate]        DATE           NOT NULL,
    [PlannedReceiptDate]         DATE           NOT NULL,
    [OrderDate]                  DATE           NOT NULL,
    [PurchaseDocumentHashKey]    NVARCHAR (200) NULL,
    [ADF_LastTimestamp]          VARBINARY (8)  CONSTRAINT [DF_PurchaseDocument_LastTimestamp] DEFAULT (0x) NOT NULL,
    [ADF_DimensionSource]        NVARCHAR (128) CONSTRAINT [DF_PurchaseDocument_DimensionSource] DEFAULT ('Default') NOT NULL,
    [ADF_BatchId_Insert]         BIGINT         CONSTRAINT [DF_dim_PurchaseDocument_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]         BIGINT         CONSTRAINT [DF_dim_PurchaseDocument_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PurchaseDocument] PRIMARY KEY CLUSTERED ([PurchaseDocumentKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_PurchaseDocument] UNIQUE NONCLUSTERED ([CompanyID] ASC, [PurchaseDocumentNumber] ASC, [PurchaseDocumentLineNumber] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

EXECUTE sp_addextendedproperty @name = N'UnknownEntityName', @value = N'PurchaseDocument', @level0type = N'SCHEMA', @level0name = N'dim', @level1type = N'TABLE', @level1name = N'PurchaseDocument';


GO

