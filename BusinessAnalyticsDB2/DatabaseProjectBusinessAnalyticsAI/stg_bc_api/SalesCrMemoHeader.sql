CREATE TABLE [stg_bc_api].[SalesCrMemoHeader] (
    [CompanyId]           INT              NOT NULL,
    [no]                  NVARCHAR (20)    NOT NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [externalDocumentNo]  NVARCHAR (35)    NULL,
    [yourReference]       NVARCHAR (35)    NULL,
    [reasonCode]          NVARCHAR (10)    NULL,
    [sellToCustomerNo]    NVARCHAR (20)    NULL,
    [sellToCustomerName]  NVARCHAR (100)   NULL,
    [sellToPostCode]      NVARCHAR (20)    NULL,
    [sellToCountryRegionCode] NVARCHAR (10) NULL,
    [billToCustomerNo]    NVARCHAR (20)    NULL,
    [billToName]          NVARCHAR (100)   NULL,
    [postingDate]         DATE             NULL,
    [documentDate]        DATE             NULL,
    [dueDate]             DATE             NULL,
    [currencyCode]        NVARCHAR (10)    NULL,
    [currencyFactor]      DECIMAL (38, 20) NULL,
    [pricesIncludingVAT]  BIT              NULL,
    [amount]              DECIMAL (38, 20) NULL,
    [amountIncludingVAT]  DECIMAL (38, 20) NULL,
    [locationCode]        NVARCHAR (10)    NULL,
    [shortcutDim1Code]    NVARCHAR (20)    NULL,
    [shortcutDim2Code]    NVARCHAR (20)    NULL,
    [dimensionSetId]      INT              NULL,
    [vatBusPostingGroup]  NVARCHAR (20)    NULL,
    [genBusPostingGroup]  NVARCHAR (20)    NULL,
    [paymentTermsCode]    NVARCHAR (10)    NULL,
    [paymentMethodCode]   NVARCHAR (10)    NULL,
    [shipmentMethodCode]  NVARCHAR (10)    NULL,
    [salespersonCode]     NVARCHAR (20)    NULL,
    [shippingAgentCode]   NVARCHAR (10)    NULL,
    [appliesToDocNo]      NVARCHAR (20)    NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_SalesCrMemoHeader] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_SalesCrMemoHeader_ExternalDocNo]
    ON [stg_bc_api].[SalesCrMemoHeader]([CompanyId] ASC, [externalDocumentNo] ASC)
    INCLUDE([no], [billToCustomerNo], [postingDate], [amountIncludingVAT], [appliesToDocNo], [salespersonCode]);


GO

CREATE NONCLUSTERED INDEX [IX_SalesCrMemoHeader_ModifiedAt]
    ON [stg_bc_api].[SalesCrMemoHeader]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([no], [postingDate], [amountIncludingVAT], [currencyCode], [currencyFactor], [dimensionSetId], [appliesToDocNo], [salespersonCode], [shippingAgentCode]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_SalesCrMemoHeader_Upsert]
    ON [stg_bc_api].[SalesCrMemoHeader]([CompanyId] ASC, [no] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_SalesCrMemoHeader_Customer]
    ON [stg_bc_api].[SalesCrMemoHeader]([CompanyId] ASC, [billToCustomerNo] ASC, [postingDate] ASC)
    INCLUDE([no], [amount], [amountIncludingVAT], [currencyCode], [currencyFactor], [reasonCode], [sellToCustomerNo], [sellToPostCode], [sellToCountryRegionCode], [shipmentMethodCode], [systemModifiedAt]);


GO

