CREATE TABLE [fct].[BudgetEntry] (
    [PostingDateKey]    INT             CONSTRAINT [DF_BudgetEntry_PostingDate] DEFAULT ((-1)) NOT NULL,
    [CompanyKey]        INT             CONSTRAINT [DF_BudgetEntry_Company] DEFAULT ((-1)) NOT NULL,
    [BudgetVersionKey]  INT             CONSTRAINT [DF_BudgetEntry_BudgetVersion] DEFAULT ((-1)) NOT NULL,
    [GLAccountKey]      INT             CONSTRAINT [DF_BudgetEntry_GLAccount] DEFAULT ((-1)) NOT NULL,
    [DepartmentKey]     INT             CONSTRAINT [DF_BudgetEntry_Department] DEFAULT ((-1)) NOT NULL,
    [ChainKey]          INT             CONSTRAINT [DF_BudgetEntry_Chain] DEFAULT ((-1)) NOT NULL,
    [CountryKey]        INT             CONSTRAINT [DF_BudgetEntry_Country] DEFAULT ((-1)) NOT NULL,
    [EmployeeKey]       INT             CONSTRAINT [DF_BudgetEntry_Employee] DEFAULT ((-1)) NOT NULL,
    [M_Amount_LCY]      DECIMAL (38, 6) NULL,
    [CompanyID]         INT             NOT NULL,
    [NK_EntryNo]        INT             NOT NULL,
    [NK_PostingDate]    DATE            NOT NULL,
    [ADF_FactSource]    NVARCHAR (128)  NOT NULL,
    [ADF_LastTimestamp] VARBINARY (8)   CONSTRAINT [DF_BudgetEntry_timestamp] DEFAULT (0x) NOT NULL,
    CONSTRAINT [PK_BudgetEntry] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [NK_EntryNo] ASC, [NK_PostingDate] ASC, [ADF_FactSource] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

