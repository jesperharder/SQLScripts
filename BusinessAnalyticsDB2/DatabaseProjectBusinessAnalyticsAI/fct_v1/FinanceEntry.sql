CREATE TABLE [fct_v1].[FinanceEntry] (
    [PostingDateKey] INT CONSTRAINT [DF_FinanceEntry_PostingDate] DEFAULT ((-1)) NULL,
    [CompanyKey] INT CONSTRAINT [DF_FinanceEntry_Company] DEFAULT ((-1)) NULL,
    [FinanceAccountKey] INT CONSTRAINT [DF_FinanceEntry_FinanceAccount] DEFAULT ((-1)) NULL,
    [DepartmentKey] INT CONSTRAINT [DF_FinanceEntry_Department] DEFAULT ((-1)) NULL,
    [ChainKey] INT CONSTRAINT [DF_FinanceEntry_Chain] DEFAULT ((-1)) NULL,
    [CountryKey] INT CONSTRAINT [DF_FinanceEntry_Country] DEFAULT ((-1)) NULL,
    [SupplierKey] INT CONSTRAINT [DF_FinanceEntry_Supplier] DEFAULT ((-1)) NULL,
    [MarketingKey] INT CONSTRAINT [DF_FinanceEntry_Marketing] DEFAULT ((-1)) NULL,
    [EmployeeKey] INT CONSTRAINT [DF_FinanceEntry_Employee] DEFAULT ((-1)) NULL,
    [MaintainanceKey] INT CONSTRAINT [DF_FinanceEntry_Maintainance] DEFAULT ((-1)) NULL,
    [M_Amount_LCY] DECIMAL (38, 6) NULL,
    [CompanyID] INT NULL,
    [NK_EntryNo] INT NULL,
    [NK_PostingDate] DATETIME NULL,
    [FactSource] NVARCHAR (128) NULL,
    [timestamp] VARBINARY (8) CONSTRAINT [DF_FinanceEntry_timestamp] DEFAULT (0x) NULL
);

GO

CREATE NONCLUSTERED INDEX [nci_msft_1_FinanceEntry_2D6EDE675EFCC4F8DB46457AC1B51B3A]
    ON [fct_v1].[FinanceEntry]([NK_PostingDate] ASC, [FactSource] ASC)
    INCLUDE ([timestamp])

GO

CREATE NONCLUSTERED INDEX [NIX_fct_FinanceEntry_FactSource_WithIncluded]
    ON [fct_v1].[FinanceEntry]([NK_PostingDate] ASC, [FactSource] ASC)
    INCLUDE ([timestamp])

GO
