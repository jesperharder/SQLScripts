CREATE TABLE [etl].[CountryDistributionFactors] (
    [CompanyID]          INT            NULL,
    [CountryCodeISO2]    CHAR (2)       NULL,
    [CountryName]        NVARCHAR (100) NULL,
    [DistributionFactor] DECIMAL (5, 2) NULL,
    [Comments]           NVARCHAR (255) NULL,
    [CheckFactorBalance] DECIMAL (6, 2) NULL
);


GO

