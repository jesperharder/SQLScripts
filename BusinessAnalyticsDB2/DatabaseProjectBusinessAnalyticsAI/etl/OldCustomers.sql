CREATE TABLE [etl].[OldCustomers] (
    [CompanyID]     INT       NOT NULL,
    [OldCustomerNo] CHAR (20) NOT NULL,
    [NewCustomerNo] CHAR (20) NOT NULL,
    CONSTRAINT [PK_etl.OldCustomers] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [OldCustomerNo] ASC, [NewCustomerNo] ASC)
);


GO

