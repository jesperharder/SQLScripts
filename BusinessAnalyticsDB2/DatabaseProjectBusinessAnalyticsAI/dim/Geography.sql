CREATE TABLE [dim].[Geography] (
    [GeographyKey]                INT            NOT NULL,
    [CountryCode]                 NVARCHAR (7)   NOT NULL,
    [CountryName]                 NVARCHAR (60)  NOT NULL,
    [GeographyRegion]             NVARCHAR (10)  NOT NULL,
    [GeographySubRegion]          NVARCHAR (35)  NOT NULL,
    [GeographyIntermediateRegion] NVARCHAR (15)  NOT NULL,
    [GeographyLevel0]             NVARCHAR (7)   NOT NULL,
    [GeographyLevel1]             NVARCHAR (60)  NOT NULL,
    [GeographyLevel2]             NVARCHAR (60)  NULL,
    [GeographyLevel3]             NVARCHAR (60)  NULL,
    [GeographyLevel4]             NVARCHAR (60)  NULL,
    [GeographyHashKey]            NVARCHAR (200) NULL,
    [ADF_LastTimestamp]           VARBINARY (8)  CONSTRAINT [DF_Geography_LastTimestamp] DEFAULT (0x) NOT NULL,
    [ADF_DimensionSource]         NVARCHAR (128) CONSTRAINT [DF_Geography_DimensionSource] DEFAULT ('Default') NOT NULL,
    [ADF_BatchId_Insert]          BIGINT         CONSTRAINT [DF_dim_Geography_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]          BIGINT         CONSTRAINT [DF_dim_Geography_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    [CompanyID]                   INT            NOT NULL,
    [MarketType]                  INT            NOT NULL,
    [MarketTypeText]              NVARCHAR (30)  NOT NULL,
    [ChannelType]                 INT            NOT NULL,
    [ChannelTypeText]             NVARCHAR (30)  NOT NULL,
    [SalesMarket]                 NVARCHAR (30)  NOT NULL,
    [SalesMarketCountryName]      NVARCHAR (30)  NOT NULL,
    CONSTRAINT [PK_Geography] PRIMARY KEY CLUSTERED ([GeographyKey] ASC),
    CONSTRAINT [UQ_Geography] UNIQUE NONCLUSTERED ([CompanyID] ASC, [CountryCode] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'UnknownEntityName', @value = N'Geography', @level0type = N'SCHEMA', @level0name = N'dim', @level1type = N'TABLE', @level1name = N'Geography';


GO

