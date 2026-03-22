CREATE TABLE [stg_bc_api].[SalesInvHeader] (
    [CompanyId]                     INT              NOT NULL,
    [no]                            NVARCHAR (20)    NOT NULL,
    [systemId]                      UNIQUEIDENTIFIER NULL,
    [orderNo]                       NVARCHAR (20)    NULL,
    [preAssignedNo]                 NVARCHAR (20)    NULL,
    [externalDocumentNo]            NVARCHAR (35)    NULL,
    [yourReference]                 NVARCHAR (35)    NULL,
    [reasonCode]                    NVARCHAR (10)    NULL,
    [postingDescription]            NVARCHAR (100)   NULL,
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
    [remainingAmount]               DECIMAL (38, 20) NULL,
    [locationCode]                  NVARCHAR (10)    NULL,
    [shortcutDim1Code]              NVARCHAR (20)    NULL,
    [shortcutDim2Code]              NVARCHAR (20)    NULL,
    [dimensionSetId]                INT              NULL,
    [customerPostingGroup]          NVARCHAR (20)    NULL,
    [customerPriceGroup]            NVARCHAR (10)    NULL,
    [customerDiscGroup]             NVARCHAR (20)    NULL,
    [vatBusPostingGroup]            NVARCHAR (20)    NULL,
    [genBusPostingGroup]            NVARCHAR (20)    NULL,
    [paymentTermsCode]              NVARCHAR (10)    NULL,
    [paymentMethodCode]             NVARCHAR (10)    NULL,
    [shipmentMethodCode]            NVARCHAR (10)    NULL,
    [languageCode]                  NVARCHAR (10)    NULL,
    [salespersonCode]               NVARCHAR (20)    NULL,
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
    [comment]                       BIT              NULL,
    [correction]                    BIT              NULL,
    [closed]                        BIT              NULL,
    [cancelled]                     BIT              NULL,
    [corrective]                    BIT              NULL,
    [reversed]                      BIT              NULL,
    [sentAsEmail]                   BIT              NULL,
    [lastEmailNotifCleared]         BIT              NULL,
    [prepaymentInvoice]             BIT              NULL,
    [prepaymentOrderNo]             NVARCHAR (20)    NULL,
    [prepaymentNoSeries]            NVARCHAR (20)    NULL,
    [quoteNo]                       NVARCHAR (20)    NULL,
    [campaignNo]                    NVARCHAR (20)    NULL,
    [opportunityNo]                 NVARCHAR (20)    NULL,
    [eu3PartyTrade]                 BIT              NULL,
    [onHold]                        NVARCHAR (3)     NULL,
    [userId]                        NVARCHAR (50)    NULL,
    [paymentReference]              NVARCHAR (50)    NULL,
    [paymentServiceSetId]           INT              NULL,
    [documentExchangeIdentifier]    NVARCHAR (50)    NULL,
    [docExchOriginalIdentifier]     NVARCHAR (50)    NULL,
    [directDebitMandateId]          NVARCHAR (35)    NULL,
    [packageTrackingNo]             NVARCHAR (30)    NULL,
    [shippingAgentCode]             NVARCHAR (10)    NULL,
    [appliesToDocType]              NVARCHAR (50)    NULL,
    [appliesToDocTypeInt]           INT              NULL,
    [balAccountType]                NVARCHAR (50)    NULL,
    [balAccountTypeInt]             INT              NULL,
    [invoiceDiscountCalculation]    NVARCHAR (50)    NULL,
    [invoiceDiscountCalculationInt] INT              NULL,
    [lastEmailSentStatus]           NVARCHAR (50)    NULL,
    [lastEmailSentStatusInt]        INT              NULL,
    [documentExchangeStatus]        NVARCHAR (100)   NULL,
    [documentExchangeStatusInt]     INT              NULL,
    [priceCalculationMethod]        NVARCHAR (100)   NULL,
    [priceCalculationMethodInt]     INT              NULL,
    [systemCreatedAt]               DATETIME2 (0)    NULL,
    [systemCreatedBy]               UNIQUEIDENTIFIER NULL,
    [systemModifiedAt]              DATETIME2 (0)    NULL,
    [systemModifiedBy]              UNIQUEIDENTIFIER NULL,
    [PipelineName]                  NVARCHAR (255)   NOT NULL,
    [PipelineRunId]                 NVARCHAR (100)   NOT NULL,
    [PipelineTriggerTime]           DATETIME2 (0)    NOT NULL,
    CONSTRAINT [PK_stg_bc_api_SalesInvHeader] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesInvHeader_CompanyId_PostingDate]
    ON [stg_bc_api].[SalesInvHeader]([CompanyId] ASC, [postingDate] ASC)
    INCLUDE([no], [sellToCustomerNo], [billToCustomerNo], [currencyCode], [amount], [amountIncludingVAT], [remainingAmount], [documentDate], [dueDate]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_stg_bc_api_SalesInvHeader_CompanyId_no]
    ON [stg_bc_api].[SalesInvHeader]([CompanyId] ASC, [no] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesInvHeader_CompanyId_SystemModifiedAt]
    ON [stg_bc_api].[SalesInvHeader]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([no], [systemId], [postingDate], [documentDate]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesInvHeader_CompanyId_SellToCustomerNo]
    ON [stg_bc_api].[SalesInvHeader]([CompanyId] ASC, [sellToCustomerNo] ASC)
    INCLUDE([no], [postingDate], [documentDate], [currencyCode], [amount], [amountIncludingVAT], [remainingAmount]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesInvHeader_CompanyId_OrderNo]
    ON [stg_bc_api].[SalesInvHeader]([CompanyId] ASC, [orderNo] ASC)
    INCLUDE([no], [postingDate], [sellToCustomerNo], [externalDocumentNo], [amountIncludingVAT]);


GO

