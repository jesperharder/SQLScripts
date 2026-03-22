CREATE TABLE [stg_bc_api].[Vendor] (
    [CompanyId]                INT                NOT NULL,
    [no]                       NVARCHAR (20)      NOT NULL,
    [name]                     NVARCHAR (100)     NULL,
    [name2]                    NVARCHAR (50)      NULL,
    [searchName]               NVARCHAR (100)     NULL,
    [address]                  NVARCHAR (100)     NULL,
    [address2]                 NVARCHAR (50)      NULL,
    [city]                     NVARCHAR (30)      NULL,
    [postCode]                 NVARCHAR (20)      NULL,
    [county]                   NVARCHAR (30)      NULL,
    [countryRegionCode]        NVARCHAR (10)      NULL,
    [contact]                  NVARCHAR (100)     NULL,
    [phoneNo]                  NVARCHAR (30)      NULL,
    [mobilePhoneNo]            NVARCHAR (30)      NULL,
    [email]                    NVARCHAR (80)      NULL,
    [homePage]                 NVARCHAR (80)      NULL,
    [vendorPostingGroup]       NVARCHAR (20)      NULL,
    [vatBusPostingGroup]       NVARCHAR (20)      NULL,
    [genBusPostingGroup]       NVARCHAR (20)      NULL,
    [vatRegistrationNo]        NVARCHAR (20)      NULL,
    [currencyCode]             NVARCHAR (10)      NULL,
    [paymentTermsCode]         NVARCHAR (10)      NULL,
    [paymentMethodCode]        NVARCHAR (10)      NULL,
    [locationCode]             NVARCHAR (10)      NULL,
    [prepaymentPct]            DECIMAL (18, 5)    NULL,
    [pricesIncludingVAT]       BIT                NULL,
    [balanceLCY]               DECIMAL (18, 5)    NULL,
    [leadTimeCalculation]      NVARCHAR (50)      NULL,
    [payToVendorNo]            NVARCHAR (20)      NULL,
    [purchaserCode]            NVARCHAR (20)      NULL,
    [shipmentMethodCode]       NVARCHAR (10)      NULL,
    [shippingAgentCode]        NVARCHAR (10)      NULL,
    [applicationMethod]        NVARCHAR (50)      NULL,
    [applicationMethodInt]     INT                NULL,
    [blocked]                  NVARCHAR (50)      NULL,
    [blockedInt]               INT                NULL,
    [privacyBlocked]           BIT                NULL,
    [respCenter]               NVARCHAR (10)      NULL,
    [globalDim1Code]           NVARCHAR (20)      NULL,
    [globalDim2Code]           NVARCHAR (20)      NULL,
    [preferredBankAccountCode] NVARCHAR (20)      NULL,
    [creditorNo]               NVARCHAR (20)      NULL,
    [lastModifiedDateTime]     DATETIME2 (7)      NULL,
    [lastDateModified]         DATE               NULL,
    [systemId]                 UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]          DATETIME2 (7)      NULL,
    [systemCreatedBy]          UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]         DATETIME2 (7)      NULL,
    [systemModifiedBy]         UNIQUEIDENTIFIER   NULL,
    [PipelineName]             NVARCHAR (200)     NULL,
    [PipelineRunId]            UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime]      DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_Vendor_PostingGroups]
    ON [stg_bc_api].[Vendor]([CompanyId] ASC, [vendorPostingGroup] ASC, [genBusPostingGroup] ASC, [vatBusPostingGroup] ASC)
    INCLUDE([no], [name], [currencyCode], [blockedInt], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_Vendor_Search]
    ON [stg_bc_api].[Vendor]([CompanyId] ASC, [searchName] ASC)
    INCLUDE([no], [name], [city], [postCode], [phoneNo], [contact], [blockedInt]);


GO

CREATE NONCLUSTERED INDEX [IX_Vendor_Purchaser]
    ON [stg_bc_api].[Vendor]([CompanyId] ASC, [purchaserCode] ASC)
    INCLUDE([no], [name], [payToVendorNo], [currencyCode], [blockedInt], [systemModifiedAt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_Vendor_Upsert]
    ON [stg_bc_api].[Vendor]([CompanyId] ASC, [no] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Vendor_SystemModifiedAt]
    ON [stg_bc_api].[Vendor]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([no], [name], [searchName], [blockedInt], [vendorPostingGroup], [currencyCode], [countryRegionCode], [lastModifiedDateTime]);


GO

