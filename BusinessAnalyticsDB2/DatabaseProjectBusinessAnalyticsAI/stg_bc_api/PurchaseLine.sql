CREATE TABLE [stg_bc_api].[PurchaseLine] (
    [CompanyId]                    INT              NOT NULL,
    [documentType]                 NVARCHAR (50)    NOT NULL,
    [documentTypeInt]              INT              NOT NULL,
    [documentNo]                   NVARCHAR (20)    NOT NULL,
    [lineNo]                       INT              NOT NULL,
    [systemId]                     UNIQUEIDENTIFIER NULL,
    [buyFromVendorNo]              NVARCHAR (20)    NOT NULL,
    [payToVendorNo]                NVARCHAR (20)    NOT NULL,
    [orderNo]                      NVARCHAR (20)    NOT NULL,
    [orderLineNo]                  INT              NOT NULL,
    [blanketOrderNo]               NVARCHAR (20)    NOT NULL,
    [blanketOrderLineNo]           INT              NOT NULL,
    [receiptNo]                    NVARCHAR (20)    NOT NULL,
    [receiptLineNo]                INT              NOT NULL,
    [returnShipmentNo]             NVARCHAR (20)    NOT NULL,
    [returnShipmentLineNo]         INT              NOT NULL,
    [type]                         NVARCHAR (50)    NOT NULL,
    [typeInt]                      INT              NOT NULL,
    [no]                           NVARCHAR (20)    NOT NULL,
    [variantCode]                  NVARCHAR (10)    NOT NULL,
    [description]                  NVARCHAR (100)   NOT NULL,
    [description2]                 NVARCHAR (50)    NOT NULL,
    [unitOfMeasureCode]            NVARCHAR (10)    NOT NULL,
    [unitOfMeasure]                NVARCHAR (50)    NOT NULL,
    [qtyPerUnitOfMeasure]          DECIMAL (38, 20) NOT NULL,
    [locationCode]                 NVARCHAR (10)    NOT NULL,
    [binCode]                      NVARCHAR (20)    NOT NULL,
    [postingGroup]                 NVARCHAR (20)    NOT NULL,
    [expectedReceiptDate]          DATE             NULL,
    [requestedReceiptDate]         DATE             NULL,
    [promisedReceiptDate]          DATE             NULL,
    [plannedReceiptDate]           DATE             NULL,
    [orderDate]                    DATE             NULL,
    [leadTimeCalculation]          NVARCHAR (30)    NOT NULL,
    [inboundWhseHandlingTime]      NVARCHAR (30)    NOT NULL,
    [safetyLeadTime]               NVARCHAR (30)    NOT NULL,
    [quantity]                     DECIMAL (38, 20) NOT NULL,
    [quantityBase]                 DECIMAL (38, 20) NOT NULL,
    [outstandingQuantity]          DECIMAL (38, 20) NOT NULL,
    [outstandingQtyBase]           DECIMAL (38, 20) NOT NULL,
    [qtyToInvoice]                 DECIMAL (38, 20) NOT NULL,
    [qtyToInvoiceBase]             DECIMAL (38, 20) NOT NULL,
    [qtyToReceive]                 DECIMAL (38, 20) NOT NULL,
    [qtyToReceiveBase]             DECIMAL (38, 20) NOT NULL,
    [quantityReceived]             DECIMAL (38, 20) NOT NULL,
    [qtyReceivedBase]              DECIMAL (38, 20) NOT NULL,
    [quantityInvoiced]             DECIMAL (38, 20) NOT NULL,
    [qtyInvoicedBase]              DECIMAL (38, 20) NOT NULL,
    [qtyRcdNotInvoiced]            DECIMAL (38, 20) NOT NULL,
    [qtyRcdNotInvoicedBase]        DECIMAL (38, 20) NOT NULL,
    [returnQtyToShip]              DECIMAL (38, 20) NOT NULL,
    [returnQtyToShipBase]          DECIMAL (38, 20) NOT NULL,
    [returnQtyShipped]             DECIMAL (38, 20) NOT NULL,
    [returnQtyShippedBase]         DECIMAL (38, 20) NOT NULL,
    [returnQtyShippedNotInvd]      DECIMAL (38, 20) NOT NULL,
    [retQtyShpdNotInvdBase]        DECIMAL (38, 20) NOT NULL,
    [reservedQuantity]             DECIMAL (38, 20) NOT NULL,
    [reservedQtyBase]              DECIMAL (38, 20) NOT NULL,
    [whseOutstandingQtyBase]       DECIMAL (38, 20) NOT NULL,
    [directUnitCost]               DECIMAL (38, 20) NOT NULL,
    [unitCost]                     DECIMAL (38, 20) NOT NULL,
    [unitCostLCY]                  DECIMAL (38, 20) NOT NULL,
    [unitPriceLCY]                 DECIMAL (38, 20) NOT NULL,
    [lineDiscountPercent]          DECIMAL (38, 20) NOT NULL,
    [lineDiscountAmount]           DECIMAL (38, 20) NOT NULL,
    [invDiscountAmount]            DECIMAL (38, 20) NOT NULL,
    [invDiscAmountToInvoice]       DECIMAL (38, 20) NOT NULL,
    [lineAmount]                   DECIMAL (38, 20) NOT NULL,
    [amount]                       DECIMAL (38, 20) NOT NULL,
    [amountIncludingVAT]           DECIMAL (38, 20) NOT NULL,
    [vatBaseAmount]                DECIMAL (38, 20) NOT NULL,
    [vatDifference]                DECIMAL (38, 20) NOT NULL,
    [outstandingAmount]            DECIMAL (38, 20) NOT NULL,
    [outstandingAmountLCY]         DECIMAL (38, 20) NOT NULL,
    [outstandingAmtExVATLCY]       DECIMAL (38, 20) NOT NULL,
    [amtRcdNotInvoiced]            DECIMAL (38, 20) NOT NULL,
    [amtRcdNotInvoicedLCY]         DECIMAL (38, 20) NOT NULL,
    [returnShpdNotInvd]            DECIMAL (38, 20) NOT NULL,
    [returnShpdNotInvdLCY]         DECIMAL (38, 20) NOT NULL,
    [genBusPostingGroup]           NVARCHAR (20)    NOT NULL,
    [genProdPostingGroup]          NVARCHAR (20)    NOT NULL,
    [vatBusPostingGroup]           NVARCHAR (20)    NOT NULL,
    [vatProdPostingGroup]          NVARCHAR (20)    NOT NULL,
    [vatCalculationType]           NVARCHAR (50)    NOT NULL,
    [vatCalculationTypeInt]        INT              NOT NULL,
    [vatPercent]                   DECIMAL (38, 20) NOT NULL,
    [vatIdentifier]                NVARCHAR (20)    NOT NULL,
    [currencyCode]                 NVARCHAR (10)    NOT NULL,
    [taxAreaCode]                  NVARCHAR (20)    NOT NULL,
    [taxGroupCode]                 NVARCHAR (20)    NOT NULL,
    [taxLiable]                    BIT              NOT NULL,
    [useTax]                       BIT              NOT NULL,
    [shortcutDimension1Code]       NVARCHAR (20)    NOT NULL,
    [shortcutDimension2Code]       NVARCHAR (20)    NOT NULL,
    [dimensionSetId]               INT              NOT NULL,
    [dropShipment]                 BIT              NOT NULL,
    [specialOrder]                 BIT              NOT NULL,
    [salesOrderNo]                 NVARCHAR (20)    NOT NULL,
    [salesOrderLineNo]             INT              NOT NULL,
    [specialOrderSalesNo]          NVARCHAR (20)    NOT NULL,
    [specialOrderSalesLineNo]      INT              NOT NULL,
    [itemReferenceNo]              NVARCHAR (50)    NOT NULL,
    [vendorItemNo]                 NVARCHAR (50)    NOT NULL,
    [itemCategoryCode]             NVARCHAR (20)    NOT NULL,
    [purchasingCode]               NVARCHAR (10)    NOT NULL,
    [returnReasonCode]             NVARCHAR (10)    NOT NULL,
    [attachedToLineNo]             INT              NOT NULL,
    [attachedDocCount]             INT              NOT NULL,
    [completelyReceived]           BIT              NOT NULL,
    [jobNo]                        NVARCHAR (20)    NOT NULL,
    [jobTaskNo]                    NVARCHAR (20)    NOT NULL,
    [jobPlanningLineNo]            INT              NOT NULL,
    [jobLineType]                  NVARCHAR (50)    NOT NULL,
    [jobLineTypeInt]               INT              NOT NULL,
    [prodOrderNo]                  NVARCHAR (20)    NOT NULL,
    [prodOrderLineNo]              INT              NOT NULL,
    [routingNo]                    NVARCHAR (20)    NOT NULL,
    [operationNo]                  NVARCHAR (10)    NOT NULL,
    [workCenterNo]                 NVARCHAR (20)    NOT NULL,
    [faPostingType]                NVARCHAR (50)    NOT NULL,
    [overReceiptQuantity]          DECIMAL (38, 20) NOT NULL,
    [overReceiptCode]              NVARCHAR (20)    NOT NULL,
    [overReceiptApprovalStatus]    NVARCHAR (50)    NOT NULL,
    [overReceiptApprovalStatusInt] INT              NOT NULL,
    [systemCreatedAt]              DATETIME2 (7)    NULL,
    [systemCreatedBy]              UNIQUEIDENTIFIER NULL,
    [systemModifiedAt]             DATETIME2 (7)    NULL,
    [systemModifiedBy]             UNIQUEIDENTIFIER NULL,
    [PipelineName]                 NVARCHAR (200)   NOT NULL,
    [PipelineRunId]                NVARCHAR (100)   NOT NULL,
    [PipelineTriggerTime]          DATETIME2 (7)    NOT NULL,
    CONSTRAINT [PK_PurchaseLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [documentType] ASC, [documentNo] ASC, [lineNo] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_PurchaseLine_Upsert]
    ON [stg_bc_api].[PurchaseLine]([CompanyId] ASC, [documentType] ASC, [documentNo] ASC, [lineNo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_PurchaseLine_ItemLookup]
    ON [stg_bc_api].[PurchaseLine]([CompanyId] ASC, [no] ASC, [variantCode] ASC, [locationCode] ASC)
    INCLUDE([documentType], [documentNo], [lineNo], [buyFromVendorNo], [expectedReceiptDate], [plannedReceiptDate], [quantity], [quantityBase], [outstandingQuantity], [qtyToReceive], [amount]);


GO

CREATE NONCLUSTERED INDEX [IX_PurchaseLine_Vendor]
    ON [stg_bc_api].[PurchaseLine]([CompanyId] ASC, [buyFromVendorNo] ASC, [documentType] ASC, [documentNo] ASC)
    INCLUDE([lineNo], [no], [description], [quantity], [amount], [expectedReceiptDate], [promisedReceiptDate]);


GO

CREATE NONCLUSTERED INDEX [IX_PurchaseLine_SystemModifiedAt]
    ON [stg_bc_api].[PurchaseLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([documentType], [documentNo], [lineNo], [PipelineRunId], [no], [locationCode]);


GO

CREATE NONCLUSTERED INDEX [IX_PurchaseLine_Document]
    ON [stg_bc_api].[PurchaseLine]([CompanyId] ASC, [documentType] ASC, [documentNo] ASC)
    INCLUDE([lineNo], [type], [typeInt], [no], [variantCode], [locationCode], [quantity], [quantityBase], [amount], [amountIncludingVAT], [outstandingQuantity]);


GO

