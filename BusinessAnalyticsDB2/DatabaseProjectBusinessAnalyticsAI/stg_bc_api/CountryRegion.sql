CREATE TABLE [stg_bc_api].[CountryRegion] (
    [CompanyId]               INT                NOT NULL,
    [code]                    NVARCHAR (10)      NOT NULL,
    [name]                    NVARCHAR (100)     NULL,
    [isoCode]                 NVARCHAR (10)      NULL,
    [isoNumericCode]          NVARCHAR (10)      NULL,
    [euCountryRegionCode]     NVARCHAR (10)      NULL,
    [intrastatCode]           NVARCHAR (10)      NULL,
    [addressFormat]           NVARCHAR (50)      NULL,
    [addressFormatInt]        INT                NULL,
    [contactAddressFormat]    NVARCHAR (50)      NULL,
    [contactAddressFormatInt] INT                NULL,
    [vatScheme]               NVARCHAR (50)      NULL,
    [lastModifiedDateTime]    DATETIMEOFFSET (7) NULL,
    [countyName]              NVARCHAR (100)     NULL,
    [freightCurrencyCode]     NVARCHAR (10)      NULL,
    [freightAmount]           DECIMAL (19, 4)    NULL,
    [freightOrderMinAmount]   DECIMAL (19, 4)    NULL,
    [freightGLAccountNo]      NVARCHAR (20)      NULL,
    [freightDescription]      NVARCHAR (250)     NULL,
    [salesMarket]             NVARCHAR (50)      NULL,
    [marketTypes]             NVARCHAR (100)     NULL,
    [marketTypesInt]          INT                NULL,
    [channelTypes]            NVARCHAR (100)     NULL,
    [channelTypesInt]         INT                NULL,
    [systemId]                UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]         DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]         UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]        DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]        UNIQUEIDENTIFIER   NULL,
    [PipelineName]            NVARCHAR (200)     NULL,
    [PipelineRunId]           NVARCHAR (100)     NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_CountryRegion] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

