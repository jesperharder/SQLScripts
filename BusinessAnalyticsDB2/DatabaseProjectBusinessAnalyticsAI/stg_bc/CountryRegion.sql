CREATE TABLE [stg_bc].[CountryRegion] (
    [timestamp]                  VARBINARY (8)    NOT NULL,
    [Code]                       NVARCHAR (20)    NOT NULL,
    [Name]                       NVARCHAR (50)    NULL,
    [ISO Code]                   NVARCHAR (2)     NULL,
    [ISO Numeric Code]           NVARCHAR (3)     NULL,
    [EU Country_Region Code]     NVARCHAR (10)    NULL,
    [Intrastat Code]             NVARCHAR (10)    NULL,
    [Address Format]             INT              NULL,
    [Contact Address Format]     INT              NULL,
    [VAT Scheme]                 NVARCHAR (10)    NULL,
    [Last Modified Date Time]    DATETIME         NULL,
    [County Name]                NVARCHAR (30)    NULL,
    [Id]                         UNIQUEIDENTIFIER NULL,
    [OIOUBL Country_Region Code] NVARCHAR (10)    NULL,
    [$systemId]                  UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]           DATETIME         NULL,
    [$systemCreatedBy]           UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]          DATETIME         NULL,
    [$systemModifiedBy]          UNIQUEIDENTIFIER NULL,
    [PipelineName]               NVARCHAR (MAX)   NULL,
    [PipelineRunId]              NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]        NVARCHAR (MAX)   NULL,
    [CompanyID]                  INT              NOT NULL,
    [SalesMarket]                NVARCHAR (20)    NOT NULL,
    [Market Types]               INT              NOT NULL,
    [Channel Types]              INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_CountryRegion] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_CountryRegion_timestamp]
    ON [stg_bc].[CountryRegion]([CompanyID] ASC, [timestamp] ASC);


GO

