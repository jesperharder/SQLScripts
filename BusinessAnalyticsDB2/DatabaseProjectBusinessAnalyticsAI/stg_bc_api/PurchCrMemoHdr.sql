CREATE TABLE [stg_bc_api].[PurchCrMemoHdr] (
    [CompanyId]           NVARCHAR (36)    NOT NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [no]                  NVARCHAR (20)    NOT NULL,
    [vendorCrMemoNo]      NVARCHAR (35)    NULL,
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
    [systemCreatedBy]     NVARCHAR (50)    NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (50)    NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_PurchCrMemoHdr] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_PurchCrMemoHdr_SystemModifiedAt]
    ON [stg_bc_api].[PurchCrMemoHdr]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([no], [systemId]);


GO

CREATE NONCLUSTERED INDEX [IX_PurchCrMemoHdr_BuyFromVendor]
    ON [stg_bc_api].[PurchCrMemoHdr]([CompanyId] ASC, [buyFromVendorNo] ASC)
    INCLUDE([no], [postingDate], [vendorCrMemoNo], [amount], [amountIncludingVAT]);


GO

CREATE NONCLUSTERED INDEX [IX_PurchCrMemoHdr_PayToVendor]
    ON [stg_bc_api].[PurchCrMemoHdr]([CompanyId] ASC, [payToVendorNo] ASC)
    INCLUDE([no], [postingDate], [vendorCrMemoNo], [amount], [amountIncludingVAT]);


GO

CREATE NONCLUSTERED INDEX [IX_PurchCrMemoHdr_VendorCrMemoNo]
    ON [stg_bc_api].[PurchCrMemoHdr]([CompanyId] ASC, [vendorCrMemoNo] ASC)
    INCLUDE([no], [postingDate], [buyFromVendorNo], [payToVendorNo], [amount], [amountIncludingVAT]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_PurchCrMemoHdr_Upsert]
    ON [stg_bc_api].[PurchCrMemoHdr]([CompanyId] ASC, [no] ASC);


GO

