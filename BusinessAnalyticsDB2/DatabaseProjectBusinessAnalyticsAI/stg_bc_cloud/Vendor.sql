CREATE TABLE [stg_bc_cloud].[Vendor] (
    [Vendor_No]                    NVARCHAR (MAX)   NULL,
    [Vendor_Name]                  NVARCHAR (MAX)   NULL,
    [Balance_Due]                  DECIMAL (38, 18) NULL,
    [Posting_Date]                 DATETIME2 (7)    NULL,
    [Applied_Vend_Ledger_Entry_No] INT              NULL,
    [Amount]                       DECIMAL (38, 18) NULL,
    [Amount_LCY]                   DECIMAL (38, 18) NULL,
    [Transaction_No]               INT              NULL,
    [Entry_No]                     INT              NULL,
    [Remaining_Pmt_Disc_Possible]  DECIMAL (38, 18) NULL,
    [CompanyID]                    INT              NULL
);


GO

