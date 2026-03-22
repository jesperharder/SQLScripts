CREATE TABLE [etl].[NavChainLinked] (
    [CustomerCompanyID]       INT            NOT NULL,
    [CustomerNo]              NVARCHAR (20)  NOT NULL,
    [NAV_CustomerNoFound]     VARCHAR (20)   NULL,
    [BC_CustomerName]         NVARCHAR (100) NULL,
    [NAV_CustomerName]        VARCHAR (50)   NULL,
    [BC_Dimension Value Code] NVARCHAR (20)  NULL,
    [BC_DimName]              NVARCHAR (50)  NULL
);


GO

