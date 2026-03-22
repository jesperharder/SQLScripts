CREATE TABLE [stg_bc_api].[Customer] (
    [CompanyId]            INT                NOT NULL,
    [no]                   NVARCHAR (20)      NOT NULL,
    [name]                 NVARCHAR (100)     NULL,
    [name2]                NVARCHAR (50)      NULL,
    [searchName]           NVARCHAR (100)     NULL,
    [address]              NVARCHAR (100)     NULL,
    [address2]             NVARCHAR (50)      NULL,
    [city]                 NVARCHAR (30)      NULL,
    [postCode]             NVARCHAR (20)      NULL,
    [county]               NVARCHAR (30)      NULL,
    [countryRegionCode]    NVARCHAR (10)      NULL,
    [phoneNo]              NVARCHAR (30)      NULL,
    [eMail]                NVARCHAR (80)      NULL,
    [homePage]             NVARCHAR (250)     NULL,
    [contact]              NVARCHAR (100)     NULL,
    [customerPostingGroup] NVARCHAR (20)      NULL,
    [genBusPostingGroup]   NVARCHAR (20)      NULL,
    [vatBusPostingGroup]   NVARCHAR (20)      NULL,
    [currencyCode]         NVARCHAR (10)      NULL,
    [paymentTermsCode]     NVARCHAR (10)      NULL,
    [paymentMethodCode]    NVARCHAR (10)      NULL,
    [locationCode]         NVARCHAR (10)      NULL,
    [globalDimension1Code] NVARCHAR (20)      NULL,
    [globalDimension2Code] NVARCHAR (20)      NULL,
    [responsibilityCenter] NVARCHAR (10)      NULL,
    [blocked]              NVARCHAR (50)      NULL,
    [blockedInt]           INT                NULL,
    [balanceLCY]           DECIMAL (38, 20)   NULL,
    [salesLCY]             DECIMAL (38, 20)   NULL,
    [paymentsLCY]          DECIMAL (38, 20)   NULL,
    [lastModifiedDateTime] DATETIMEOFFSET (7) NULL,
    [systemId]             UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]      DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]      UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]     DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]     UNIQUEIDENTIFIER   NULL,
    [PipelineName]         NVARCHAR (200)     NULL,
    [PipelineRunId]        NVARCHAR (100)     NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_Customer_Company_LastModified]
    ON [stg_bc_api].[Customer]([CompanyId] ASC, [lastModifiedDateTime] ASC);


GO

