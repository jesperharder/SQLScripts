CREATE TABLE [etl].[Company] (
    [CompanyId]           TINYINT       NOT NULL,
    [CompanyNameShort]    NCHAR (15)    NULL,
    [CompanyNameLong]     NCHAR (30)    NULL,
    [CompanyCountryCode]  NCHAR (3)     NULL,
    [Tablename NAV]       VARCHAR (200) NULL,
    [Tablename BC]        VARCHAR (200) NULL,
    [CompanyCurrencyCode] NCHAR (3)     NULL
);


GO

