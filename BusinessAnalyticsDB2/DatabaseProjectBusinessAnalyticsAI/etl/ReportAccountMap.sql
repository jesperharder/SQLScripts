CREATE TABLE [etl].[ReportAccountMap] (
    [ReportNo]   SMALLINT      NOT NULL,
    [Report]     VARCHAR (50)  NOT NULL,
    [AccountKey] INT           NOT NULL,
    [Function]   VARCHAR (255) NOT NULL,
    [CompanyID]  VARCHAR (2)   NOT NULL
);


GO

