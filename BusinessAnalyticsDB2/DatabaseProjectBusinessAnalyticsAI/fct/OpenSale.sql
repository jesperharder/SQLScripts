CREATE TABLE [fct].[OpenSale] (
    [IntakeDateKey]                INT             CONSTRAINT [DF_OpenSale_IntakeDate] DEFAULT ((-1)) NOT NULL,
    [PostingDateKey]               INT             CONSTRAINT [DF_OpenSale_PostingDate] DEFAULT ((-1)) NOT NULL,
    [ReportingDateKey]             INT             CONSTRAINT [DF_OpenSale_ReportingDate] DEFAULT ((-1)) NOT NULL,
    [PlannedDeliveryDateKey]       INT             CONSTRAINT [DF_OpenSale_DatePlannedDelivery] DEFAULT ((-1)) NOT NULL,
    [CompanyKey]                   INT             CONSTRAINT [DF_OpenSale_Company] DEFAULT ((-1)) NOT NULL,
    [SalesOrderKey]                INT             CONSTRAINT [DF_OpenSale_SalesOrder] DEFAULT ((-1)) NOT NULL,
    [ItemKey]                      INT             CONSTRAINT [DF_OpenSale_Item] DEFAULT ((-1)) NOT NULL,
    [GLAccountKey]                 INT             CONSTRAINT [DF_OpenSale_GLAccount] DEFAULT ((-1)) NOT NULL,
    [CustomerKey]                  INT             CONSTRAINT [DF_OpenSale_Customer] DEFAULT ((-1)) NOT NULL,
    [CompanyCurrencyKey]           INT             CONSTRAINT [DF_OpenSale_Currency_Company] DEFAULT ((-1)) NOT NULL,
    [DocumentCurrencyKey]          INT             CONSTRAINT [DF_OpenSale_Currency_Document] DEFAULT ((-1)) NOT NULL,
    [IntakeTimeKey]                INT             CONSTRAINT [DF_OpenSale_Time_Intake] DEFAULT ((-1)) NOT NULL,
    [LocationKey]                  INT             CONSTRAINT [DF_OpenSale_Location] DEFAULT ((-1)) NOT NULL,
    [EmployeeSalespersonKey]       INT             CONSTRAINT [DF_OpenSale_Salesperson] DEFAULT ((-1)) NOT NULL,
    [TeamKey]                      INT             CONSTRAINT [DF_OpenSale_Team] DEFAULT ((-1)) NOT NULL,
    [GeographyCustomerKey]         INT             CONSTRAINT [DF_OpenSale_Geography_Customer] DEFAULT ((-1)) NOT NULL,
    [ShipmentMethodKey]            INT             CONSTRAINT [DF_OpenSale_ShipmentMethod] DEFAULT ((-1)) NOT NULL,
    [ChainKey]                     INT             CONSTRAINT [DF_OpenSale_Chain] DEFAULT ((-1)) NOT NULL,
    [M_Quantity]                   DECIMAL (18, 4) NULL,
    [M_QuantityInvoiced]           DECIMAL (18, 4) NULL,
    [M_OutstandingQuantity]        DECIMAL (18, 4) NULL,
    [M_QuantityShippedNotInvoiced] DECIMAL (18, 4) NULL,
    [M_UnitCost]                   DECIMAL (18, 4) NULL,
    [M_UnitCost_LCY]               DECIMAL (18, 4) NULL,
    [M_Amount]                     DECIMAL (18, 4) NULL,
    [M_COGS]                       DECIMAL (18, 4) NULL,
    [M_GM]                         DECIMAL (18, 4) NULL,
    [M_Amount_LCY]                 DECIMAL (18, 4) NULL,
    [M_COGS_LCY]                   DECIMAL (18, 4) NULL,
    [M_GM_LCY]                     DECIMAL (18, 4) NULL,
    [M_OutstandingAmount]          DECIMAL (18, 4) NULL,
    [M_Outstanding_COGS]           DECIMAL (18, 4) NULL,
    [M_Outstanding_GM]             DECIMAL (18, 4) NULL,
    [M_OutstandingAmount_LCY]      DECIMAL (18, 4) NULL,
    [M_Outstanding_COGS_LCY]       DECIMAL (18, 4) NULL,
    [M_Outstanding_GM_LCY]         DECIMAL (18, 4) NULL,
    [DocumentType]                 VARCHAR (20)    NULL,
    [CompanyID]                    INT             NOT NULL,
    [NK_SalesOrderNumber]          VARCHAR (50)    NOT NULL,
    [NK_DocumentLineNumber]        INT             NOT NULL,
    [ADF_FactSource]               NVARCHAR (128)  NOT NULL,
    [GeographySellToCustomerKey]   INT             NOT NULL,
    [CampaignKey]                  INT             NOT NULL,
    CONSTRAINT [PK_OpenSale] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [NK_SalesOrderNumber] ASC, [NK_DocumentLineNumber] ASC, [ADF_FactSource] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

CREATE NONCLUSTERED INDEX [IX_fct_OpenSale_PostingDateKey]
    ON [fct].[OpenSale]([PostingDateKey] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_fct_OpenSale_ItemKey]
    ON [fct].[OpenSale]([ItemKey] ASC);


GO

