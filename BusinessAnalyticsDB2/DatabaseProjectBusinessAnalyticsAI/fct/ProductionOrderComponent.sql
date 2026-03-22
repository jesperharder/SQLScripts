CREATE TABLE [fct].[ProductionOrderComponent] (
    [CreatedDateKey]                        INT             CONSTRAINT [DF_ProductionOrderComponent_CreatedDate] DEFAULT ((-1)) NOT NULL,
    [StartingDateKey]                       INT             CONSTRAINT [DF_ProductionOrderComponent_StartingDate] DEFAULT ((-1)) NOT NULL,
    [StartingTimeKey]                       INT             CONSTRAINT [DF_ProductionOrderComponent_StartingTime] DEFAULT ((-1)) NOT NULL,
    [DueDateKey]                            INT             CONSTRAINT [DF_ProductionOrderComponent_DueDate] DEFAULT ((-1)) NOT NULL,
    [DueTimeKey]                            INT             CONSTRAINT [DF_ProductionOrderComponent_DueTime] DEFAULT ((-1)) NOT NULL,
    [CompanyKey]                            INT             CONSTRAINT [DF_ProductionOrderComponent_Company] DEFAULT ((-1)) NOT NULL,
    [ItemKey]                               INT             CONSTRAINT [DF_ProductionOrderComponent_Item] DEFAULT ((-1)) NOT NULL,
    [ProductionOrderKey]                    INT             CONSTRAINT [DF_ProductionOrderComponent_ProductionOrder] DEFAULT ((-1)) NOT NULL,
    [LocationKey]                           INT             CONSTRAINT [DF_ProductionOrderComponent_Location] DEFAULT ((-1)) NOT NULL,
    [AdHocKey]                              INT             CONSTRAINT [DF_ProductionOrderComponent_AdHoc] DEFAULT ((-1)) NOT NULL,
    [DepartmentKey]                         INT             CONSTRAINT [DF_ProductionOrderComponent_Department] DEFAULT ((-1)) NOT NULL,
    [ChainKey]                              INT             CONSTRAINT [DF_ProductionOrderComponent_Chain] DEFAULT ((-1)) NOT NULL,
    [CountryKey]                            INT             CONSTRAINT [DF_ProductionOrderComponent_Country] DEFAULT ((-1)) NOT NULL,
    [SupplierKey]                           INT             CONSTRAINT [DF_ProductionOrderComponent_Supplier] DEFAULT ((-1)) NOT NULL,
    [MarketingKey]                          INT             CONSTRAINT [DF_ProductionOrderComponent_Marketing] DEFAULT ((-1)) NOT NULL,
    [EmployeeKey]                           INT             CONSTRAINT [DF_ProductionOrderComponent_Employee] DEFAULT ((-1)) NOT NULL,
    [MaintainanceKey]                       INT             CONSTRAINT [DF_ProductionOrderComponent_Maintainance] DEFAULT ((-1)) NOT NULL,
    [M_Quantity]                            DECIMAL (18, 4) NULL,
    [M_QuantityExpected]                    DECIMAL (18, 4) NULL,
    [M_QuantityRemaining]                   DECIMAL (18, 4) NULL,
    [M_UnitCost_LCY]                        DECIMAL (18, 4) NULL,
    [M_DirectUnitCost_LCY]                  DECIMAL (18, 4) NULL,
    [M_IndirectUnitCost_LCY]                DECIMAL (18, 4) NULL,
    [M_CostAmount_LCY]                      DECIMAL (18, 4) NULL,
    [M_DirectCostAmount_LCY]                DECIMAL (18, 4) NULL,
    [CompanyID]                             INT             NOT NULL,
    [NK_ProductionOrderNumber]              NVARCHAR (20)   NOT NULL,
    [NK_ProductionOrderLineNumber]          INT             NOT NULL,
    [NK_ProductionOrderComponentLineNumber] INT             NOT NULL,
    [ADF_FactSource]                        NVARCHAR (128)  NOT NULL,
    [timestamp]                             VARBINARY (8)   CONSTRAINT [DF_ProductionOrderComponent_timestamp] DEFAULT (0x) NOT NULL,
    CONSTRAINT [PK_ProductionOrderComponent] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [NK_ProductionOrderNumber] ASC, [NK_ProductionOrderComponentLineNumber] ASC, [ADF_FactSource] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

