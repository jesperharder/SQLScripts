CREATE TABLE [stg_bc_api].[PurchInvHeader] (
    [CompanyId]           INT              NOT NULL,
    [no]                  NVARCHAR (20)    NOT NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [vendorInvoiceNo]     NVARCHAR (35)    NULL,
    [buyFromVendorNo]     NVARCHAR (20)    NULL,
    [buyFromVendorName]   NVARCHAR (100)   NULL,
    [payToVendorNo]       NVARCHAR (20)    NULL,
    [payToName]           NVARCHAR (100)   NULL,
    [yourReference]       NVARCHAR (35)    NULL,
    [postingDate]         DATE             NULL,
    [documentDate]        DATE             NULL,
    [dueDate]             DATE             NULL,
    [currencyCode]        NVARCHAR (10)    NULL,
    [pricesIncludingVAT]  BIT              NULL,
    [amount]              DECIMAL (38, 20) NULL,
    [amountIncludingVAT]  DECIMAL (38, 20) NULL,
    [locationCode]        NVARCHAR (10)    NULL,
    [shortcutDim1Code]    NVARCHAR (20)    NULL,
    [shortcutDim2Code]    NVARCHAR (20)    NULL,
    [vatBusPostingGroup]  NVARCHAR (20)    NULL,
    [genBusPostingGroup]  NVARCHAR (20)    NULL,
    [paymentTermsCode]    NVARCHAR (10)    NULL,
    [paymentMethodCode]   NVARCHAR (10)    NULL,
    [shipmentMethodCode]  NVARCHAR (10)    NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_PurchInvHeader] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_PurchInvHeader_Vendor]
    ON [stg_bc_api].[PurchInvHeader]([CompanyId] ASC, [payToVendorNo] ASC, [postingDate] ASC)
    INCLUDE([no], [amount], [amountIncludingVAT], [currencyCode], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_PurchInvHeader_ModifiedAt]
    ON [stg_bc_api].[PurchInvHeader]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([no]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_PurchInvHeader_Upsert]
    ON [stg_bc_api].[PurchInvHeader]([CompanyId] ASC, [no] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_PurchInvHeader_VendorInvoiceNo]
    ON [stg_bc_api].[PurchInvHeader]([CompanyId] ASC, [vendorInvoiceNo] ASC)
    INCLUDE([no], [payToVendorNo], [postingDate], [amountIncludingVAT]);


GO

