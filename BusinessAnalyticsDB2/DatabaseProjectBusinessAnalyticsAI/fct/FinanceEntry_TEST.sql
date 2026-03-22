CREATE TABLE [fct].[FinanceEntry_TEST] (
    [PostingDateKey]    INT             NOT NULL,
    [CompanyKey]        INT             NOT NULL,
    [FinanceAccountKey] INT             NOT NULL,
    [DepartmentKey]     INT             NOT NULL,
    [ChainKey]          INT             NOT NULL,
    [CountryKey]        INT             NOT NULL,
    [SupplierKey]       INT             NOT NULL,
    [MarketingKey]      INT             NOT NULL,
    [EmployeeKey]       INT             NOT NULL,
    [MaintainanceKey]   INT             NOT NULL,
    [M_Amount_LCY]      DECIMAL (38, 6) NULL,
    [CompanyID]         INT             NOT NULL,
    [NK_EntryNo]        INT             NOT NULL,
    [NK_PostingDate]    DATETIME        NOT NULL,
    [FactSource]        NVARCHAR (128)  NOT NULL,
    [timestamp]         VARBINARY (8)   NOT NULL,
    CONSTRAINT [PK_FinanceEntry_TEST] PRIMARY KEY CLUSTERED ([NK_PostingDate] ASC, [CompanyID] ASC, [NK_EntryNo] ASC, [FactSource] ASC) ON [psFinanceEntry] ([NK_PostingDate])
) ON [psFinanceEntry] ([NK_PostingDate]);


GO

CREATE NONCLUSTERED INDEX [NIX_fct_FinanceEntry_FactSource_WithIncluded]
    ON [fct].[FinanceEntry_TEST]([FactSource] ASC)
    INCLUDE([timestamp])
    ON [psFinanceEntry] ([NK_PostingDate]);


GO

CREATE NONCLUSTERED INDEX [nci_msft_1_FinanceEntry_2D6EDE675EFCC4F8DB46457AC1B51B3A]
    ON [fct].[FinanceEntry_TEST]([NK_PostingDate] ASC, [FactSource] ASC)
    INCLUDE([timestamp])
    ON [psFinanceEntry] ([NK_PostingDate]);


GO

