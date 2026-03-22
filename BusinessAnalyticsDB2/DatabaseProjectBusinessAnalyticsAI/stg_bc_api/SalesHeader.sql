CREATE TABLE [stg_bc_api].[SalesHeader] (
    [CompanyId]                     INT              NOT NULL,
    [documentType]                  NVARCHAR (50)    NOT NULL,
    [documentTypeInt]               INT              NOT NULL,
    [no]                            NVARCHAR (20)    NOT NULL,
    [systemId]                      UNIQUEIDENTIFIER NULL,
    [status]                        NVARCHAR (50)    NULL,
    [statusInt]                     INT              NULL,
    [externalDocumentNo]            NVARCHAR (35)    NULL,
    [yourReference]                 NVARCHAR (35)    NULL,
    [assignedUserId]                NVARCHAR (50)    NULL,
    [salespersonCode]               NVARCHAR (20)    NULL,
    [reasonCode]                    NVARCHAR (10)    NULL,
    [orderClass]                    NVARCHAR (10)    NULL,
    [postingDescription]            NVARCHAR (100)   NULL,
    [opportunityNo]                 NVARCHAR (20)    NULL,
    [quoteNo]                       NVARCHAR (20)    NULL,
    [quoteValidUntilDate]           DATE             NULL,
    [quoteSentToCustomer]           DATETIME2 (0)    NULL,
    [quoteAccepted]                 BIT              NULL,
    [quoteAcceptedDate]             DATE             NULL,
    [sellToCustomerNo]              NVARCHAR (20)    NULL,
    [sellToCustomerName]            NVARCHAR (100)   NULL,
    [sellToCustomerName2]           NVARCHAR (50)    NULL,
    [sellToAddress]                 NVARCHAR (100)   NULL,
    [sellToAddress2]                NVARCHAR (50)    NULL,
    [sellToCity]                    NVARCHAR (30)    NULL,
    [sellToPostCode]                NVARCHAR (20)    NULL,
    [sellToCounty]                  NVARCHAR (30)    NULL,
    [sellToCountryRegionCode]       NVARCHAR (10)    NULL,
    [sellToContact]                 NVARCHAR (100)   NULL,
    [sellToContactNo]               NVARCHAR (20)    NULL,
    [sellToPhoneNo]                 NVARCHAR (30)    NULL,
    [sellToEmail]                   NVARCHAR (80)    NULL,
    [billToCustomerNo]              NVARCHAR (20)    NULL,
    [billToName]                    NVARCHAR (100)   NULL,
    [billToName2]                   NVARCHAR (50)    NULL,
    [billToAddress]                 NVARCHAR (100)   NULL,
    [billToAddress2]                NVARCHAR (50)    NULL,
    [billToCity]                    NVARCHAR (30)    NULL,
    [billToPostCode]                NVARCHAR (20)    NULL,
    [billToCounty]                  NVARCHAR (30)    NULL,
    [billToCountryRegionCode]       NVARCHAR (10)    NULL,
    [billToContact]                 NVARCHAR (100)   NULL,
    [billToContactNo]               NVARCHAR (20)    NULL,
    [shipToCode]                    NVARCHAR (10)    NULL,
    [shipToName]                    NVARCHAR (100)   NULL,
    [shipToName2]                   NVARCHAR (50)    NULL,
    [shipToAddress]                 NVARCHAR (100)   NULL,
    [shipToAddress2]                NVARCHAR (50)    NULL,
    [shipToCity]                    NVARCHAR (30)    NULL,
    [shipToPostCode]                NVARCHAR (20)    NULL,
    [shipToCounty]                  NVARCHAR (30)    NULL,
    [shipToCountryRegionCode]       NVARCHAR (10)    NULL,
    [shipToContact]                 NVARCHAR (100)   NULL,
    [orderDate]                     DATE             NULL,
    [postingDate]                   DATE             NULL,
    [shipmentDate]                  DATE             NULL,
    [documentDate]                  DATE             NULL,
    [dueDate]                       DATE             NULL,
    [pmtDiscountDate]               DATE             NULL,
    [requestedDeliveryDate]         DATE             NULL,
    [promisedDeliveryDate]          DATE             NULL,
    [shippingTime]                  NVARCHAR (50)    NULL,
    [outboundWhseHandlingTime]      NVARCHAR (50)    NULL,
    [lastShipmentDate]              DATE             NULL,
    [lastEmailSentTime]             DATETIME2 (0)    NULL,
    [currencyCode]                  NVARCHAR (10)    NULL,
    [currencyFactor]                DECIMAL (38, 20) NULL,
    [pricesIncludingVAT]            BIT              NULL,
    [amount]                        DECIMAL (38, 20) NULL,
    [amountIncludingVAT]            DECIMAL (38, 20) NULL,
    [invoiceDiscountValue]          DECIMAL (38, 20) NULL,
    [invoiceDiscountAmount]         DECIMAL (38, 20) NULL,
    [paymentDiscountPct]            DECIMAL (38, 20) NULL,
    [vatBaseDiscountPct]            DECIMAL (38, 20) NULL,
    [prepaymentPct]                 DECIMAL (38, 20) NULL,
    [amtShipNotInvLCY]              DECIMAL (38, 20) NULL,
    [amtShipNotInvLCYBase]          DECIMAL (38, 20) NULL,
    [locationCode]                  NVARCHAR (10)    NULL,
    [shortcutDim1Code]              NVARCHAR (20)    NULL,
    [shortcutDim2Code]              NVARCHAR (20)    NULL,
    [dimensionSetId]                INT              NULL,
    [customerPostingGroup]          NVARCHAR (20)    NULL,
    [customerPriceGroup]            NVARCHAR (10)    NULL,
    [customerDiscGroup]             NVARCHAR (20)    NULL,
    [invoiceDiscCode]               NVARCHAR (20)    NULL,
    [vatBusPostingGroup]            NVARCHAR (20)    NULL,
    [genBusPostingGroup]            NVARCHAR (20)    NULL,
    [paymentTermsCode]              NVARCHAR (10)    NULL,
    [paymentMethodCode]             NVARCHAR (10)    NULL,
    [shipmentMethodCode]            NVARCHAR (10)    NULL,
    [languageCode]                  NVARCHAR (10)    NULL,
    [responsibilityCenter]          NVARCHAR (10)    NULL,
    [sourceCode]                    NVARCHAR (10)    NULL,
    [taxAreaCode]                   NVARCHAR (20)    NULL,
    [taxLiable]                     BIT              NULL,
    [vatRegistrationNo]             NVARCHAR (20)    NULL,
    [vatCountryRegionCode]          NVARCHAR (10)    NULL,
    [transactionType]               NVARCHAR (10)    NULL,
    [transactionSpecification]      NVARCHAR (10)    NULL,
    [transportMethod]               NVARCHAR (10)    NULL,
    [area]                          NVARCHAR (10)    NULL,
    [exitPoint]                     NVARCHAR (10)    NULL,
    [shippingNo]                    NVARCHAR (20)    NULL,
    [postingNo]                     NVARCHAR (20)    NULL,
    [lastShippingNo]                NVARCHAR (20)    NULL,
    [lastPostingNo]                 NVARCHAR (20)    NULL,
    [returnReceiptNo]               NVARCHAR (20)    NULL,
    [lastReturnReceiptNo]           NVARCHAR (20)    NULL,
    [prepaymentNo]                  NVARCHAR (20)    NULL,
    [lastPrepaymentNo]              NVARCHAR (20)    NULL,
    [prepaymentNoSeries]            NVARCHAR (20)    NULL,
    [prepaymentDueDate]             DATE             NULL,
    [prepmtCrMemoNo]                NVARCHAR (20)    NULL,
    [prepmtCrMemoNoSeries]          NVARCHAR (20)    NULL,
    [prepmtPaymentTermsCode]        NVARCHAR (10)    NULL,
    [prepmtPaymentDiscountPct]      DECIMAL (38, 20) NULL,
    [prepmtPmtDiscountDate]         DATE             NULL,
    [comment]                       BIT              NULL,
    [recalculateInvoiceDisc]        BIT              NULL,
    [ship]                          BIT              NULL,
    [invoice]                       BIT              NULL,
    [receive]                       BIT              NULL,
    [printPostedDocuments]          BIT              NULL,
    [combineShipments]              BIT              NULL,
    [correction]                    BIT              NULL,
    [onHold]                        NVARCHAR (3)     NULL,
    [sentAsEmail]                   BIT              NULL,
    [lastEmailNotifCleared]         BIT              NULL,
    [isTest]                        BIT              NULL,
    [packageTrackingNo]             NVARCHAR (30)    NULL,
    [shippingAgentCode]             NVARCHAR (10)    NULL,
    [shippingAgentServiceCode]      NVARCHAR (10)    NULL,
    [paymentServiceSetId]           INT              NULL,
    [directDebitMandateId]          NVARCHAR (35)    NULL,
    [incomingDocumentEntryNo]       INT              NULL,
    [jobQueueEntryId]               UNIQUEIDENTIFIER NULL,
    [noOfArchivedVersions]          INT              NULL,
    [docNoOccurrence]               INT              NULL,
    [campaignNo]                    NVARCHAR (20)    NULL,
    [allowLineDisc]                 BIT              NULL,
    [getShipmentUsed]               BIT              NULL,
    [shippedNotInvoiced]            BIT              NULL,
    [completelyShipped]             BIT              NULL,
    [shipped]                       BIT              NULL,
    [lateOrderShipping]             BIT              NULL,
    [appliesToDocType]              NVARCHAR (50)    NULL,
    [appliesToDocTypeInt]           INT              NULL,
    [balAccountType]                NVARCHAR (50)    NULL,
    [balAccountTypeInt]             INT              NULL,
    [reserve]                       NVARCHAR (50)    NULL,
    [reserveInt]                    INT              NULL,
    [invoiceDiscountCalculation]    NVARCHAR (50)    NULL,
    [invoiceDiscountCalculationInt] INT              NULL,
    [icStatus]                      NVARCHAR (50)    NULL,
    [icStatusInt]                   INT              NULL,
    [icDirection]                   NVARCHAR (50)    NULL,
    [icDirectionInt]                INT              NULL,
    [jobQueueStatus]                NVARCHAR (50)    NULL,
    [jobQueueStatusInt]             INT              NULL,
    [lastEmailSentStatus]           NVARCHAR (50)    NULL,
    [lastEmailSentStatusInt]        INT              NULL,
    [priceCalculationMethod]        NVARCHAR (100)   NULL,
    [priceCalculationMethodInt]     INT              NULL,
    [shippingAdvice]                NVARCHAR (50)    NULL,
    [shippingAdviceInt]             INT              NULL,
    [systemCreatedAt]               DATETIME2 (0)    NULL,
    [systemCreatedBy]               UNIQUEIDENTIFIER NULL,
    [systemModifiedAt]              DATETIME2 (0)    NULL,
    [systemModifiedBy]              UNIQUEIDENTIFIER NULL,
    [PipelineName]                  NVARCHAR (255)   NOT NULL,
    [PipelineRunId]                 NVARCHAR (100)   NOT NULL,
    [PipelineTriggerTime]           DATETIME2 (0)    NOT NULL,
    CONSTRAINT [PK_stg_bc_api_SalesHeader] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [documentType] ASC, [documentTypeInt] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesHeader_CompanyId_systemModifiedAt]
    ON [stg_bc_api].[SalesHeader]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([documentType], [documentTypeInt], [no], [systemId], [status], [postingDate], [documentDate]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesHeader_CompanyId_externalDocumentNo]
    ON [stg_bc_api].[SalesHeader]([CompanyId] ASC, [externalDocumentNo] ASC)
    INCLUDE([documentType], [documentTypeInt], [no], [sellToCustomerNo], [billToCustomerNo], [postingDate], [status]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesHeader_CompanyId_orderDate]
    ON [stg_bc_api].[SalesHeader]([CompanyId] ASC, [orderDate] ASC)
    INCLUDE([documentType], [documentTypeInt], [no], [sellToCustomerNo], [status], [currencyCode], [amountIncludingVAT]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesHeader_CompanyId_sellToCustomerNo]
    ON [stg_bc_api].[SalesHeader]([CompanyId] ASC, [sellToCustomerNo] ASC)
    INCLUDE([documentType], [documentTypeInt], [no], [status], [postingDate], [requestedDeliveryDate], [promisedDeliveryDate], [amount], [amountIncludingVAT]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesHeader_CompanyId_status_documentType]
    ON [stg_bc_api].[SalesHeader]([CompanyId] ASC, [status] ASC, [documentType] ASC)
    INCLUDE([documentTypeInt], [statusInt], [no], [sellToCustomerNo], [billToCustomerNo], [postingDate], [documentDate], [currencyCode], [amountIncludingVAT]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_stg_bc_api_SalesHeader_CompanyId_documentType_documentTypeInt_no]
    ON [stg_bc_api].[SalesHeader]([CompanyId] ASC, [documentType] ASC, [documentTypeInt] ASC, [no] ASC);


GO

