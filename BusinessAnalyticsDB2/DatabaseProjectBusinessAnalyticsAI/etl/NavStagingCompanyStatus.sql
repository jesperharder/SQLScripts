CREATE TABLE [etl].[NavStagingCompanyStatus] (
    [CompanyID]     TINYINT        NOT NULL,
    [CountryCode]   VARCHAR (10)   NOT NULL,
    [StagingStatus] VARCHAR (20)   NOT NULL,
    [UpdatedAtUtc]  DATETIME2 (0)  NOT NULL,
    [UpdatedBy]     NVARCHAR (128) NOT NULL,
    [Comment]       NVARCHAR (400) NULL,
    CONSTRAINT [PK_NavStagingCompanyStatus] PRIMARY KEY CLUSTERED ([CompanyID] ASC),
    CONSTRAINT [UQ_NavStagingCompanyStatus_CountryCode] UNIQUE NONCLUSTERED ([CountryCode] ASC),
    CONSTRAINT [CK_NavStagingCompanyStatus_StagingStatus] CHECK ([StagingStatus]='Historical' OR [StagingStatus]='Operational')
);


GO

CREATE NONCLUSTERED INDEX [IX_NavStagingCompanyStatus_CountryStatus]
    ON [etl].[NavStagingCompanyStatus]([CountryCode] ASC, [StagingStatus] ASC)

GO
