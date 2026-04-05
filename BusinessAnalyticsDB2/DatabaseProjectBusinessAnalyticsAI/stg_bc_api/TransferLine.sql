CREATE TABLE [stg_bc_api].[TransferLine] (
    [CompanyId]                INT                NOT NULL,
    [documentNo]               NVARCHAR (20)      NOT NULL,
    [lineNo]                   INT                NOT NULL,
    [systemId]                 UNIQUEIDENTIFIER   NULL,
    [status]                   NVARCHAR (50)      NULL,
    [statusInt]                INT                NULL,
    [itemNo]                   NVARCHAR (20)      NULL,
    [variantCode]              NVARCHAR (10)      NULL,
    [description]              NVARCHAR (100)     NULL,
    [description2]             NVARCHAR (50)      NULL,
    [unitOfMeasureCode]        NVARCHAR (10)      NULL,
    [qtyPerUnitOfMeasure]      DECIMAL (18, 5)    NULL,
    [itemCategoryCode]         NVARCHAR (20)      NULL,
    [transferFromCode]         NVARCHAR (10)      NULL,
    [transferFromBinCode]      NVARCHAR (20)      NULL,
    [transferToCode]           NVARCHAR (10)      NULL,
    [transferToBinCode]        NVARCHAR (20)      NULL,
    [inTransitCode]            NVARCHAR (10)      NULL,
    [quantity]                 DECIMAL (18, 5)    NULL,
    [quantityBase]             DECIMAL (18, 5)    NULL,
    [qtyToShip]                DECIMAL (18, 5)    NULL,
    [qtyToShipBase]            DECIMAL (18, 5)    NULL,
    [qtyToReceive]             DECIMAL (18, 5)    NULL,
    [qtyToReceiveBase]         DECIMAL (18, 5)    NULL,
    [qtyShipped]               DECIMAL (18, 5)    NULL,
    [qtyShippedBase]           DECIMAL (18, 5)    NULL,
    [qtyReceived]              DECIMAL (18, 5)    NULL,
    [qtyReceivedBase]          DECIMAL (18, 5)    NULL,
    [outstandingQuantity]      DECIMAL (18, 5)    NULL,
    [outstandingQtyBase]       DECIMAL (18, 5)    NULL,
    [qtyInTransit]             DECIMAL (18, 5)    NULL,
    [qtyInTransitBase]         DECIMAL (18, 5)    NULL,
    [shipmentDate]             DATE               NULL,
    [receiptDate]              DATE               NULL,
    [shortcutDim1Code]         NVARCHAR (20)      NULL,
    [shortcutDim2Code]         NVARCHAR (20)      NULL,
    [dimensionSetId]           INT                NULL,
    [derivedFromLineNo]        INT                NULL,
    [directTransfer]           BIT                NULL,
    [shippingAgentCode]        NVARCHAR (10)      NULL,
    [shippingAgentServiceCode] NVARCHAR (10)      NULL,
    [completelyShipped]        BIT                NULL,
    [completelyReceived]       BIT                NULL,
    [systemCreatedAt]          DATETIME2 (7)      NULL,
    [systemCreatedBy]          UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]         DATETIME2 (7)      NULL,
    [systemModifiedBy]         UNIQUEIDENTIFIER   NULL,
    [PipelineName]             NVARCHAR (200)     NULL,
    [PipelineRunId]            UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime]      DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_TransferLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [documentNo] ASC, [lineNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_TransferLine_SystemModifiedAt]
    ON [stg_bc_api].[TransferLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([documentNo], [lineNo], [itemNo], [statusInt], [shipmentDate], [receiptDate], [quantity], [outstandingQuantity], [dimensionSetId]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_TransferLine_Upsert]
    ON [stg_bc_api].[TransferLine]([CompanyId] ASC, [documentNo] ASC, [lineNo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TransferLine_Document]
    ON [stg_bc_api].[TransferLine]([CompanyId] ASC, [documentNo] ASC)
    INCLUDE([lineNo], [itemNo], [variantCode], [statusInt], [shipmentDate], [receiptDate], [quantity], [outstandingQuantity], [systemModifiedAt], [dimensionSetId]);


GO

CREATE NONCLUSTERED INDEX [IX_TransferLine_ItemShipment]
    ON [stg_bc_api].[TransferLine]([CompanyId] ASC, [itemNo] ASC, [variantCode] ASC, [shipmentDate] ASC)
    INCLUDE([documentNo], [lineNo], [transferFromCode], [transferToCode], [quantity], [outstandingQuantity], [statusInt], [systemModifiedAt]);


GO

