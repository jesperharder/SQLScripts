CREATE TABLE [fct].[ProductionOrder] (
    [CreatedDateKey]               INT             CONSTRAINT [DF_ProductionOrder_CreatedDate] DEFAULT ((-1)) NOT NULL,
    [DueDateKey]                   INT             CONSTRAINT [DF_ProductionOrder_DueDate] DEFAULT ((-1)) NOT NULL,
    [StartingDateKey]              INT             CONSTRAINT [DF_ProductionOrder_StartingDate] DEFAULT ((-1)) NOT NULL,
    [EndingDateKey]                INT             CONSTRAINT [DF_ProductionOrder_EndingDate] DEFAULT ((-1)) NOT NULL,
    [StartingTimeKey]              INT             CONSTRAINT [DF_ProductionOrder_StartingTime] DEFAULT ((-1)) NOT NULL,
    [EndingTimeKey]                INT             CONSTRAINT [DF_ProductionOrder_EndingTime] DEFAULT ((-1)) NOT NULL,
    [CompanyKey]                   INT             CONSTRAINT [DF_ProductionOrder_Company] DEFAULT ((-1)) NOT NULL,
    [ItemKey]                      INT             CONSTRAINT [DF_ProductionOrder_Item] DEFAULT ((-1)) NOT NULL,
    [ProductionOrderKey]           INT             CONSTRAINT [DF_ProductionOrder_ProductionOrder] DEFAULT ((-1)) NOT NULL,
    [LocationKey]                  INT             CONSTRAINT [DF_ProductionOrder_Location] DEFAULT ((-1)) NOT NULL,
    [AdHocKey]                     INT             CONSTRAINT [DF_ProductionOrder_AdHoc] DEFAULT ((-1)) NOT NULL,
    [DepartmentKey]                INT             CONSTRAINT [DF_ProductionOrder_Department] DEFAULT ((-1)) NOT NULL,
    [ChainKey]                     INT             CONSTRAINT [DF_ProductionOrder_Chain] DEFAULT ((-1)) NOT NULL,
    [CountryKey]                   INT             CONSTRAINT [DF_ProductionOrder_Country] DEFAULT ((-1)) NOT NULL,
    [SupplierKey]                  INT             CONSTRAINT [DF_ProductionOrder_Supplier] DEFAULT ((-1)) NOT NULL,
    [MarketingKey]                 INT             CONSTRAINT [DF_ProductionOrder_Marketing] DEFAULT ((-1)) NOT NULL,
    [EmployeeKey]                  INT             CONSTRAINT [DF_ProductionOrder_Employee] DEFAULT ((-1)) NOT NULL,
    [MaintainanceKey]              INT             CONSTRAINT [DF_ProductionOrder_Maintainance] DEFAULT ((-1)) NOT NULL,
    [M_Quantity]                   DECIMAL (18, 4) NULL,
    [M_QuantityFinished]           DECIMAL (18, 4) NULL,
    [M_QuantityRemaining]          DECIMAL (18, 4) NULL,
    [CompanyID]                    INT             NOT NULL,
    [NK_ProductionOrderNumber]     NVARCHAR (20)   NOT NULL,
    [NK_ProductionOrderLineNumber] INT             NOT NULL,
    [ADF_FactSource]               NVARCHAR (128)  NOT NULL,
    [timestamp]                    VARBINARY (8)   CONSTRAINT [DF_ProductionOrder_timestamp] DEFAULT (0x) NOT NULL,
    [ItemProductionQuantity]       INT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ProductionOrder] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [NK_ProductionOrderNumber] ASC, [NK_ProductionOrderLineNumber] ASC, [ADF_FactSource] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

