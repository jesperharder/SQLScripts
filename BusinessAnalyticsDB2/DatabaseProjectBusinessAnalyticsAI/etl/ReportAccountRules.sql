CREATE TABLE [etl].[ReportAccountRules] (
    [ReportNo]      SMALLINT     NOT NULL,
    [ReportSection] VARCHAR (50) NOT NULL,
    [FromAccountNo] VARCHAR (50) NOT NULL,
    [ToAccountNo]   VARCHAR (50) NULL,
    [CompanyID]     VARCHAR (2)  NULL
);


GO

