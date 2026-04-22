CREATE TABLE [fct_v1].[FinanceEntry] (
    [PostingDateKey] INT CONSTRAINT [DF_FinanceEntry_PostingDate] DEFAULT ((-1)) NOT NULL,
    [CompanyKey] INT CONSTRAINT [DF_FinanceEntry_Company] DEFAULT ((-1)) NOT NULL,
    [FinanceAccountKey] INT CONSTRAINT [DF_FinanceEntry_FinanceAccount] DEFAULT ((-1)) NOT NULL,
    [DepartmentKey] INT CONSTRAINT [DF_FinanceEntry_Department] DEFAULT ((-1)) NOT NULL,
    [ChainKey] INT CONSTRAINT [DF_FinanceEntry_Chain] DEFAULT ((-1)) NOT NULL,
    [CountryKey] INT CONSTRAINT [DF_FinanceEntry_Country] DEFAULT ((-1)) NOT NULL,
    [SupplierKey] INT CONSTRAINT [DF_FinanceEntry_Supplier] DEFAULT ((-1)) NOT NULL,
    [MarketingKey] INT CONSTRAINT [DF_FinanceEntry_Marketing] DEFAULT ((-1)) NOT NULL,
    [EmployeeKey] INT CONSTRAINT [DF_FinanceEntry_Employee] DEFAULT ((-1)) NOT NULL,
    [MaintainanceKey] INT CONSTRAINT [DF_FinanceEntry_Maintainance] DEFAULT ((-1)) NOT NULL,
    [M_Amount_LCY] DECIMAL (38, 6) NULL,
    [CompanyID] INT NOT NULL,
    [NK_EntryNo] INT NOT NULL,
    [NK_PostingDate] DATETIME NOT NULL,
    [FactSource] NVARCHAR (128) NOT NULL,
    [ADF_SourceModifiedAt] DATETIME2 (7) NULL,
    [timestamp] VARBINARY (8) CONSTRAINT [DF_FinanceEntry_timestamp] DEFAULT (0x) NOT NULL
);


GO

CREATE NONCLUSTERED INDEX [NIX_fct_FinanceEntry_FactSource_WithIncluded]
    ON [fct_v1].[FinanceEntry]([NK_PostingDate] ASC, [FactSource] ASC)
    INCLUDE([timestamp]);


GO

CREATE NONCLUSTERED INDEX [nci_msft_1_FinanceEntry_2D6EDE675EFCC4F8DB46457AC1B51B3A]
    ON [fct_v1].[FinanceEntry]([NK_PostingDate] ASC, [FactSource] ASC)
    INCLUDE([timestamp]);


GO
