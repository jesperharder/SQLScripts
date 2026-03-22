CREATE TABLE [stg_bc_api].[PurchaseHeader] (
    [CompanyId]           INT                NOT NULL,
    [documentType]        NVARCHAR (50)      NULL,
    [documentTypeInt]     INT                NOT NULL,
    [no]                  NVARCHAR (20)      NOT NULL,
    [status]              NVARCHAR (50)      NULL,
    [statusInt]           INT                NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [buyFromVendorNo]     NVARCHAR (20)      NULL,
    [buyFromVendorName]   NVARCHAR (100)     NULL,
    [payToVendorNo]       NVARCHAR (20)      NULL,
    [payToName]           NVARCHAR (100)     NULL,
    [yourReference]       NVARCHAR (35)      NULL,
    [purchaserCode]       NVARCHAR (20)      NULL,
    [assignedUserId]      NVARCHAR (50)      NULL,
    [orderDate]           DATE               NULL,
    [postingDate]         DATE               NULL,
    [documentDate]        DATE               NULL,
    [dueDate]             DATE               NULL,
    [expectedReceiptDate] DATE               NULL,
    [currencyCode]        NVARCHAR (10)      NULL,
    [pricesIncludingVAT]  BIT                NULL,
    [amount]              DECIMAL (18, 5)    NULL,
    [amountIncludingVAT]  DECIMAL (18, 5)    NULL,
    [vendorInvoiceNo]     NVARCHAR (35)      NULL,
    [locationCode]        NVARCHAR (10)      NULL,
    [shortcutDim1Code]    NVARCHAR (20)      NULL,
    [shortcutDim2Code]    NVARCHAR (20)      NULL,
    [vatBusPostingGroup]  NVARCHAR (20)      NULL,
    [genBusPostingGroup]  NVARCHAR (20)      NULL,
    [paymentTermsCode]    NVARCHAR (10)      NULL,
    [paymentMethodCode]   NVARCHAR (10)      NULL,
    [shipmentMethodCode]  NVARCHAR (10)      NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_PurchaseHeader] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [documentTypeInt] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_PurchaseHeader_Lookups]
    ON [stg_bc_api].[PurchaseHeader]([CompanyId] ASC, [no] ASC)
    INCLUDE([documentTypeInt], [documentType], [statusInt], [status], [buyFromVendorNo], [buyFromVendorName], [payToVendorNo], [payToName], [orderDate], [postingDate], [documentDate], [dueDate], [expectedReceiptDate], [currencyCode], [amount], [amountIncludingVAT], [vendorInvoiceNo], [locationCode], [purchaserCode], [assignedUserId]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_PurchaseHeader_UpsertKey]
    ON [stg_bc_api].[PurchaseHeader]([CompanyId] ASC, [documentTypeInt] ASC, [no] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_PurchaseHeader_SystemModifiedAt]
    ON [stg_bc_api].[PurchaseHeader]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([documentTypeInt], [no], [statusInt], [postingDate], [vendorInvoiceNo]);


GO

