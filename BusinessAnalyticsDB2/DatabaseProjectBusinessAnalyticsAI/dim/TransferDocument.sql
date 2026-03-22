CREATE TABLE [dim].[TransferDocument] (
    [TransferDocumentKey]        INT            NOT NULL,
    [CompanyID]                  INT            NOT NULL,
    [TransferDocumentNumber]     NVARCHAR (20)  NOT NULL,
    [TransferDocumentLineNumber] INT            NOT NULL,
    [IsCompletelyReceived]       NVARCHAR (7)   NOT NULL,
    [TransferStatus]             NVARCHAR (8)   NOT NULL,
    [ReceiptDate]                DATE           NOT NULL,
    [ShipmentDate]               DATE           NOT NULL,
    [TransferDocumentHashKey]    NVARCHAR (200) NULL,
    [ADF_LastTimestamp]          VARBINARY (8)  CONSTRAINT [DF_TransferDocument_LastTimestamp] DEFAULT (0x) NOT NULL,
    [ADF_DimensionSource]        NVARCHAR (128) CONSTRAINT [DF_TransferDocument_DimensionSource] DEFAULT ('Default') NOT NULL,
    [ADF_BatchId_Insert]         BIGINT         CONSTRAINT [DF_dim_TransferDocument_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]         BIGINT         CONSTRAINT [DF_dim_TransferDocument_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_TransferDocument] PRIMARY KEY CLUSTERED ([TransferDocumentKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_TransferDocument] UNIQUE NONCLUSTERED ([CompanyID] ASC, [TransferDocumentNumber] ASC, [TransferDocumentLineNumber] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

EXECUTE sp_addextendedproperty @name = N'UnknownEntityName', @value = N'TransferDocument', @level0type = N'SCHEMA', @level0name = N'dim', @level1type = N'TABLE', @level1name = N'TransferDocument';


GO

