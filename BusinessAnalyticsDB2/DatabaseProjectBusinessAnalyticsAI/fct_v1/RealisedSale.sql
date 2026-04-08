CREATE TABLE [fct_v1].[RealisedSale] (
    [IntakeDateKey] INT CONSTRAINT [DF_RealisedSale_IntakeDate] DEFAULT ((-1)) NOT NULL,
    [PostingDateKey] INT CONSTRAINT [DF_RealisedSale_PostingDate] DEFAULT ((-1)) NOT NULL,
    [ReportingDateKey] INT CONSTRAINT [DF_RealisedSale_ReportingDate] DEFAULT ((-1)) NOT NULL,
    [CompanyKey] INT CONSTRAINT [DF_RealisedSale_NavCompany] DEFAULT ((-1)) NOT NULL,
    [SalesOrderKey] INT CONSTRAINT [DF_RealisedSale_SalesOrder] DEFAULT ((-1)) NOT NULL,
    [ItemKey] INT CONSTRAINT [DF_RealisedSale_Item] DEFAULT ((-1)) NOT NULL,
    [FinanceVoucherKey] INT CONSTRAINT [DF_RealisedSale_FinanceVoucher] DEFAULT ((-1)) NOT NULL,
    [GLAccountKey] INT CONSTRAINT [DF_RealisedSale_GLAccount] DEFAULT ((-1)) NOT NULL,
    [CustomerKey] INT CONSTRAINT [DF_RealisedSale_Customer] DEFAULT ((-1)) NOT NULL,
    [DeliveryMethodKey] INT CONSTRAINT [DF_RealisedSale_DeliveryMethod] DEFAULT ((-1)) NOT NULL,
    [CompanyCurrencyKey] INT CONSTRAINT [DF_RealisedSale_CompanyCurrency] DEFAULT ((-1)) NOT NULL,
    [DocumentCurrencyKey] INT CONSTRAINT [DF_RealisedSale_DocumentCurrency] DEFAULT ((-1)) NOT NULL,
    [LocationKey] INT CONSTRAINT [DF_RealisedSale_Location] DEFAULT ((-1)) NOT NULL,
    [TeamKey] INT CONSTRAINT [DF_RealisedSale_Employee_Team] DEFAULT ((-1)) NOT NULL,
    [GeographyCustomerKey] INT CONSTRAINT [DF_RealisedSale_Geography_Customer] DEFAULT ((-1)) NOT NULL,
    [ReturnReasonKey] INT CONSTRAINT [DF_RealisedSale_ReturnReason] DEFAULT ((-1)) NOT NULL,
    [ShipmentMethodKey] INT CONSTRAINT [DF_RealisedSale_ShipmentMethod] DEFAULT ((-1)) NOT NULL,
    [ChainKey] INT CONSTRAINT [DF_RealisedSale_Chain] DEFAULT ((-1)) NOT NULL,
    [M_Quantity] DECIMAL (18, 4) NULL,
    [M_UnitCost] DECIMAL (18, 4) NULL,
    [M_UnitCost_LCY] DECIMAL (18, 4) NULL,
    [M_Amount] DECIMAL (18, 4) NULL,
    [M_COGS] DECIMAL (18, 4) NULL,
    [M_GM] DECIMAL (18, 4) NULL,
    [M_Amount_LCY] DECIMAL (18, 4) NULL,
    [M_COGS_LCY] DECIMAL (18, 4) NULL,
    [M_GM_LCY] DECIMAL (18, 4) NULL,
    [M_CurrencyFactor] DECIMAL (18, 6) NULL,
    [NK_SalesOrderNumber] NVARCHAR (50) NOT NULL,
    [NK_DocumentNumber] NVARCHAR (20) NOT NULL,
    [NK_DocumentLineNumber] INT NOT NULL,
    [NK_LineEntryType] NVARCHAR (50) NOT NULL,
    [NK_LineEntrySource] NVARCHAR (50) NOT NULL,
    [NK_PostingDate] DATETIME NOT NULL,
    [CompanyID] INT NOT NULL,
    [ADF_SourceModifiedAt] DATETIME2 (7) NULL,
    [ADF_LastTimestamp] VARBINARY (8) NOT NULL,
    [ADF_FactSource] NVARCHAR (128) NOT NULL,
    [YearCodeKey] INT NOT NULL,
    [TeamSellToCustomerCardKey] INT NOT NULL,
    [CampaignKey] INT NULL,
    CONSTRAINT [PK_RealisedSale] PRIMARY KEY CLUSTERED ([PostingDateKey] ASC, [CompanyID] ASC, [NK_SalesOrderNumber] ASC, [NK_DocumentNumber] ASC, [NK_DocumentLineNumber] ASC, [NK_LineEntryType] ASC, [ADF_FactSource] ASC)
);

GO

CREATE NONCLUSTERED INDEX [nci_msft_1_RealisedSale_8087B66DDA809F9FE1A061B094510515]
    ON [fct_v1].[RealisedSale]([PostingDateKey] ASC, [GLAccountKey] ASC, [CustomerKey] ASC)
    INCLUDE ([IntakeDateKey], [ReportingDateKey], [CompanyKey], [SalesOrderKey], [ItemKey], [FinanceVoucherKey], [DeliveryMethodKey], [CompanyCurrencyKey], [DocumentCurrencyKey], [LocationKey], [TeamKey], [GeographyCustomerKey], [ReturnReasonKey], [ShipmentMethodKey], [ChainKey], [M_Quantity], [M_UnitCost], [M_UnitCost_LCY], [M_Amount], [M_COGS], [M_GM], [M_Amount_LCY], [M_COGS_LCY], [M_GM_LCY], [M_CurrencyFactor], [NK_LineEntrySource], [NK_PostingDate], [YearCodeKey], [TeamSellToCustomerCardKey], [CampaignKey])

GO

CREATE NONCLUSTERED INDEX [nci_wi_RealisedSale_38DE12BA37802E8C411F5B8695747AB0]
    ON [fct_v1].[RealisedSale]([PostingDateKey] ASC, [ADF_FactSource] ASC)
    INCLUDE ([ADF_LastTimestamp], [ADF_SourceModifiedAt])

GO
