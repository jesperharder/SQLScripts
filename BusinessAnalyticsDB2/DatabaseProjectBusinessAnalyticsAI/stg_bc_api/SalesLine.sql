DROP TABLE [stg_bc_api].[SalesLine];
GO


CREATE TABLE [stg_bc_api].[SalesLine] (
    [CompanyId]                    INT                NOT NULL,
    [documentType]                 NVARCHAR (50)      NOT NULL,
    [documentTypeInt]              INT                NOT NULL,
    [documentNo]                   NVARCHAR (20)      NOT NULL,
    [lineNo]                       INT                NOT NULL,
    [systemId]                     UNIQUEIDENTIFIER   NULL,

    [sellToCustomerNo]             NVARCHAR (20)      NULL,
    [billToCustomerNo]             NVARCHAR (20)      NULL,
    [blanketOrderNo]               NVARCHAR (20)      NULL,
    [blanketOrderLineNo]           INT                NULL,
    [shipmentNo]                   NVARCHAR (20)      NULL,
    [shipmentLineNo]               INT                NULL,
    [returnReceiptNo]              NVARCHAR (20)      NULL,
    [returnReceiptLineNo]          INT                NULL,
    [purchaseOrderNo]              NVARCHAR (20)      NULL,
    [purchOrderLineNo]             INT                NULL,
    [specialOrderPurchaseNo]       NVARCHAR (20)      NULL,
    [specialOrderPurchLineNo]      INT                NULL,
    [usedCampaignNOTO]             NVARCHAR (255)     NULL,
    [attachedToLineNo]             INT                NULL,

    [type]                         NVARCHAR (50)      NULL,
    [typeInt]                      INT                NULL,
    [no]                           NVARCHAR (20)      NULL,
    [variantCode]                  NVARCHAR (10)      NULL,
    [description]                  NVARCHAR (100)     NULL,
    [description2]                 NVARCHAR (50)      NULL,
    [subtype]                      NVARCHAR (50)      NULL,
    [subtypeInt]                   INT                NULL,

    [locationCode]                 NVARCHAR (10)      NULL,
    [binCode]                      NVARCHAR (20)      NULL,
    [unitOfMeasureCode]            NVARCHAR (10)      NULL,
    [unitOfMeasure]                NVARCHAR (50)      NULL,
    [qtyPerUnitOfMeasure]          DECIMAL (38, 20)   NULL,
    [postingGroup]                 NVARCHAR (20)      NULL,

    [postingDate]                  DATE               NULL,
    [shipmentDate]                 DATE               NULL,
    [requestedDeliveryDate]        DATE               NULL,
    [promisedDeliveryDate]         DATE               NULL,
    [plannedShipmentDate]          DATE               NULL,
    [plannedDeliveryDate]          DATE               NULL,
    [shippingTime]                 NVARCHAR (50)      NULL,
    [outboundWhseHandlingTime]     NVARCHAR (50)      NULL,

    [quantity]                     DECIMAL (38, 20)   NULL,
    [quantityBase]                 DECIMAL (38, 20)   NULL,
    [outstandingQuantity]          DECIMAL (38, 20)   NULL,
    [outstandingQtyBase]           DECIMAL (38, 20)   NULL,
    [qtyToInvoice]                 DECIMAL (38, 20)   NULL,
    [qtyToInvoiceBase]             DECIMAL (38, 20)   NULL,
    [qtyToShip]                    DECIMAL (38, 20)   NULL,
    [qtyToShipBase]                DECIMAL (38, 20)   NULL,
    [quantityShipped]              DECIMAL (38, 20)   NULL,
    [qtyShippedBase]               DECIMAL (38, 20)   NULL,
    [qtyShippedNotInvoiced]        DECIMAL (38, 20)   NULL,
    [qtyShippedNotInvdBase]        DECIMAL (38, 20)   NULL,
    [quantityInvoiced]             DECIMAL (38, 20)   NULL,
    [qtyInvoicedBase]              DECIMAL (38, 20)   NULL,
    [returnQtyToReceive]           DECIMAL (38, 20)   NULL,
    [returnQtyToReceiveBase]       DECIMAL (38, 20)   NULL,
    [returnQtyReceived]            DECIMAL (38, 20)   NULL,
    [returnQtyReceivedBase]        DECIMAL (38, 20)   NULL,
    [returnQtyRcdNotInvd]          DECIMAL (38, 20)   NULL,
    [retQtyRcdNotInvdBase]         DECIMAL (38, 20)   NULL,
    [qtyToAssign]                  DECIMAL (38, 20)   NULL,
    [qtyAssigned]                  DECIMAL (38, 20)   NULL,
    [reservedQuantity]             DECIMAL (38, 20)   NULL,
    [reservedQtyBase]              DECIMAL (38, 20)   NULL,
    [qtyToAssembleToOrder]         DECIMAL (38, 20)   NULL,
    [qtyToAsmToOrderBase]          DECIMAL (38, 20)   NULL,
    [whseOutstandingQty]           DECIMAL (38, 20)   NULL,
    [whseOutstandingQtyBase]       DECIMAL (38, 20)   NULL,
    [atoWhseOutstandingQty]        DECIMAL (38, 20)   NULL,
    [atoWhseOutstandingQtyBase]    DECIMAL (38, 20)   NULL,
    [grossWeight]                  DECIMAL (38, 20)   NULL,
    [netWeight]                    DECIMAL (38, 20)   NULL,
    [unitsPerParcel]               DECIMAL (38, 20)   NULL,
    [unitVolume]                   DECIMAL (38, 20)   NULL,

    [unitPrice]                    DECIMAL (38, 20)   NULL,
    [unitCost]                     DECIMAL (38, 20)   NULL,
    [unitCostLCY]                  DECIMAL (38, 20)   NULL,
    [vatPercent]                   DECIMAL (38, 20)   NULL,
    [profitPercent]                DECIMAL (38, 20)   NULL,
    [lineDiscountPercent]          DECIMAL (38, 20)   NULL,
    [lineDiscountAmount]           DECIMAL (38, 20)   NULL,
    [invDiscountAmount]            DECIMAL (38, 20)   NULL,
    [invDiscAmountToInvoice]       DECIMAL (38, 20)   NULL,
    [lineAmount]                   DECIMAL (38, 20)   NULL,
    [amount]                       DECIMAL (38, 20)   NULL,
    [amountIncludingVAT]           DECIMAL (38, 20)   NULL,
    [vatBaseAmount]                DECIMAL (38, 20)   NULL,
    [vatDifference]                DECIMAL (38, 20)   NULL,
    [outstandingAmount]            DECIMAL (38, 20)   NULL,
    [outstandingAmountLCY]         DECIMAL (38, 20)   NULL,
    [shippedNotInvoiced]           DECIMAL (38, 20)   NULL,
    [shippedNotInvoicedLCY]        DECIMAL (38, 20)   NULL,
    [shippedNotInvLCYNoVAT]        DECIMAL (38, 20)   NULL,
    [returnRcdNotInvd]             DECIMAL (38, 20)   NULL,
    [returnRcdNotInvdLCY]          DECIMAL (38, 20)   NULL,
    [prepaymentPercent]            DECIMAL (38, 20)   NULL,
    [prepmtLineAmount]             DECIMAL (38, 20)   NULL,
    [prepmtAmtInv]                 DECIMAL (38, 20)   NULL,
    [prepmtAmtInclVAT]             DECIMAL (38, 20)   NULL,
    [prepaymentAmount]             DECIMAL (38, 20)   NULL,
    [prepmtVATBaseAmt]             DECIMAL (38, 20)   NULL,
    [prepaymentVATPercent]         DECIMAL (38, 20)   NULL,
    [prepmtAmtToDeduct]            DECIMAL (38, 20)   NULL,
    [prepmtAmtDeducted]            DECIMAL (38, 20)   NULL,
    [prepmtAmountInvInclVAT]       DECIMAL (38, 20)   NULL,
    [prepmtAmountInvLCY]           DECIMAL (38, 20)   NULL,
    [prepmtVATAmountInvLCY]        DECIMAL (38, 20)   NULL,
    [prepaymentVATDifference]      DECIMAL (38, 20)   NULL,
    [prepmtVATDiffToDeduct]        DECIMAL (38, 20)   NULL,
    [prepmtVATDiffDeducted]        DECIMAL (38, 20)   NULL,
    [pmtDiscountAmount]            DECIMAL (38, 20)   NULL,

    [genBusPostingGroup]           NVARCHAR (20)      NULL,
    [genProdPostingGroup]          NVARCHAR (20)      NULL,
    [vatBusPostingGroup]           NVARCHAR (20)      NULL,
    [vatProdPostingGroup]          NVARCHAR (20)      NULL,
    [vatCalculationType]           NVARCHAR (50)      NULL,
    [vatCalculationTypeInt]        INT                NULL,
    [vatIdentifier]                NVARCHAR (20)      NULL,
    [vatClauseCode]                NVARCHAR (20)      NULL,
    [currencyCode]                 NVARCHAR (10)      NULL,
    [taxAreaCode]                  NVARCHAR (20)      NULL,
    [taxGroupCode]                 NVARCHAR (20)      NULL,
    [taxLiable]                    BIT                NULL,

    [shortcutDimension1Code]       NVARCHAR (20)      NULL,
    [shortcutDimension2Code]       NVARCHAR (20)      NULL,
    [dimensionSetId]               INT                NULL,
    [responsibilityCenter]         NVARCHAR (10)      NULL,

    [dropShipment]                 BIT                NULL,
    [specialOrder]                 BIT                NULL,
    [completelyShipped]            BIT                NULL,
    [planned]                      BIT                NULL,
    [allowInvoiceDisc]             BIT                NULL,
    [allowLineDisc]                BIT                NULL,
    [allowItemChargeAssignment]    BIT                NULL,
    [recalculateInvoiceDisc]       BIT                NULL,
    [systemCreatedEntry]           BIT                NULL,
    [prepaymentLine]               BIT                NULL,
    [copiedFromPostedDoc]          BIT                NULL,

    [customerPriceGroup]           NVARCHAR (10)      NULL,
    [customerDiscGroup]            NVARCHAR (20)      NULL,
    [itemCategoryCode]             NVARCHAR (20)      NULL,
    [purchasingCode]               NVARCHAR (10)      NULL,
    [returnReasonCode]             NVARCHAR (10)      NULL,
    [itemReferenceNo]              NVARCHAR (50)      NULL,
    [itemReferenceType]            NVARCHAR (50)      NULL,
    [itemReferenceTypeInt]         INT                NULL,
    [itemReferenceTypeNo]          NVARCHAR (30)      NULL,
    [applToItemEntry]              INT                NULL,
    [applFromItemEntry]            INT                NULL,
    [attachedDocCount]             INT                NULL,

    [reserve]                      NVARCHAR (50)      NULL,
    [reserveInt]                   INT                NULL,
    [priceCalculationMethod]       NVARCHAR (100)     NULL,
    [priceCalculationMethodInt]    INT                NULL,

    [jobNo]                        NVARCHAR (20)      NULL,
    [jobTaskNo]                    NVARCHAR (20)      NULL,
    [jobContractEntryNo]           INT                NULL,
    [workTypeCode]                 NVARCHAR (10)      NULL,

    [systemCreatedAt]              DATETIME2 (0)      NULL,
    [systemCreatedBy]              UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]             DATETIME2 (0)      NULL,
    [systemModifiedBy]             UNIQUEIDENTIFIER   NULL,

    [PipelineName]                 NVARCHAR (255)     NOT NULL,
    [PipelineRunId]                NVARCHAR (100)     NOT NULL,
    [PipelineTriggerTime]          DATETIME2 (0)      NOT NULL,

    CONSTRAINT [PK_stg_bc_api_SalesLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [documentType] ASC, [documentTypeInt] ASC, [documentNo] ASC, [lineNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesLine_CompanyId_document]
    ON [stg_bc_api].[SalesLine]([CompanyId] ASC, [documentType] ASC, [documentTypeInt] ASC, [documentNo] ASC)
    INCLUDE([lineNo], [typeInt], [no], [variantCode], [locationCode], [dropShipment], [quantity], [amount], [amountIncludingVAT], [shipmentDate], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesLine_CompanyId_item]
    ON [stg_bc_api].[SalesLine]([CompanyId] ASC, [typeInt] ASC, [no] ASC, [variantCode] ASC, [locationCode] ASC)
    INCLUDE([documentType], [documentTypeInt], [documentNo], [lineNo], [dropShipment], [shipmentDate], [quantity], [outstandingQuantity], [amount], [amountIncludingVAT], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesLine_CompanyId_systemModifiedAt]
    ON [stg_bc_api].[SalesLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([documentType], [documentTypeInt], [documentNo], [lineNo], [typeInt], [no], [quantity], [amount], [amountIncludingVAT], [dropShipment], [shipmentDate]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_stg_bc_api_SalesLine_CompanyId_documentType_documentTypeInt_documentNo_lineNo]
    ON [stg_bc_api].[SalesLine]([CompanyId] ASC, [documentType] ASC, [documentTypeInt] ASC, [documentNo] ASC, [lineNo] ASC);


GO
